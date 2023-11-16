import 'dart:async';
import 'dart:convert';

import 'package:animation_playground/data/models/player_model.dart';
import 'package:animation_playground/data/models/room_model.dart';
import 'package:animation_playground/main.dart';
import 'package:animation_playground/pages/base_page.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    _roomStreamController = StreamController();
    stompClient.subscribe(
      destination: "/queue/room/${widget.room.id}",
      callback: (frame) {
        final roomModel = RoomModel.fromJson(jsonDecode(frame.body ?? ""));
        _roomStreamController.sink.add(roomModel);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _roomStreamController.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: StreamBuilder<RoomModel>(
        stream: _roomStreamController.stream,
        builder: (context, snapshot) {
          final room = snapshot.data ?? widget.room;
          return Stack(
            children: room
                .getPlayers(context)
                .map((e) => PlayerItem(player: e))
                .toList(),
          );
        },
      ),
    );
  }
}
