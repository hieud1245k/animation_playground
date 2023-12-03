import 'dart:async';
import 'dart:convert';

import 'package:animation_playground/blocs/room/room_bloc.dart';
import 'package:animation_playground/data/models/player_model.dart';
import 'package:animation_playground/data/models/room_model.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/main.dart';
import 'package:animation_playground/pages/base_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../widgets/player_item.dart';

class CardManagerPage extends StatefulWidget {
  final PlayerModel mainPlayer;
  final RoomModel room;

  const CardManagerPage({
    super.key,
    required this.mainPlayer,
    required this.room,
  });

  @override
  State<CardManagerPage> createState() => _CardManagerPageState();
}

class _CardManagerPageState extends State<CardManagerPage> {
  late StreamController<RoomModel> _roomStreamController;
  late StreamController<RoomModel> _roundStreamController;
  late RoomBloc _roomBloc;

  @override
  void initState() {
    _roomStreamController = StreamController();
    _roundStreamController = StreamController();
    stompClient.subscribe(
      destination: "/queue/room/${widget.room.id}",
      callback: (frame) {
        final roomModel = RoomModel.fromJson(jsonDecode(frame.body ?? ""));
        _roomStreamController.sink.add(roomModel);
      },
    );
    stompClient.subscribe(
      destination: "/queue/round/${widget.room.id}",
      callback: (frame) {
        final roomModel = RoomModel.fromJson(jsonDecode(frame.body ?? ""));
        _roundStreamController.sink.add(roomModel);
      },
    );
    _roomBloc = getIt<RoomBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _roomStreamController.sink.close();
    _roundStreamController.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: StreamBuilder<RoomModel>(
        stream: _roomStreamController.stream,
        builder: (context, snapshot) {
          final room = snapshot.data ?? widget.room;
          final players = room.getPlayers(context, widget.mainPlayer);
          return Stack(
            children: [
              Stack(
                children: players.map((e) => PlayerItem(player: e)).toList(),
              ),
              Positioned(
                bottom: 24,
                right: 24,
                child: TextButton(
                  onPressed: leaveRoom,
                  child: Text("Leave room"),
                ),
              ),
              if (players.length == 1)
                Center(
                  child: Text(
                    "Waiting players...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              if (players.length > 1 &&
                  widget.mainPlayer.id == room.playerModels[0].id)
                Center(
                  child: ElevatedButton(
                    onPressed: startGame,
                    child: Text("Start"),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void leaveRoom() async {
    try {
      await _roomBloc.leaveRoom(widget.mainPlayer.id, widget.room.id);
      Navigator.pop(context);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Leave room failed due to: ${error}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_RIGHT,
      );
    }
  }

  void startGame() async {
    try {
      await _roomBloc.startGame(widget.room.id);
      Navigator.pop(context);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Start game failed due to: ${error}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_RIGHT,
      );
    }
  }
}
