import 'dart:async';
import 'dart:convert';

import 'package:animation_playground/blocs/room/room_bloc.dart';
import 'package:animation_playground/blocs/round/round_bloc.dart';
import 'package:animation_playground/classes/card.dart';
import 'package:animation_playground/classes/player.dart';
import 'package:animation_playground/data/models/player_model.dart';
import 'package:animation_playground/data/models/room_model.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/main.dart';
import 'package:animation_playground/pages/base_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:playing_cards/playing_cards.dart';

import '../../data/models/round_model.dart';
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
  late RoomBloc _roomBloc;
  late RoundBloc _roundBloc;

  bool _isPending = false;

  List<GlobalKey<CardItemState>> allCardStates =
      List.generate(52, (index) => GlobalKey());
  List<CardItem> allCards = [];
  List<Player> players = [];
  RoomModel? roomModel;

  @override
  void initState() {
    for (var i = 0; i < allCardStates.length; i++) {
      allCards.add(
        CardItem(
          key: allCardStates[i],
          color: Colors.black12,
          card: PlayingCard(
            STANDARD_SUITS[
                ((i + 1) ~/ SUITED_VALUES.length) % STANDARD_SUITS.length],
            SUITED_VALUES[(i + 1) % SUITED_VALUES.length],
          ),
        ),
      );
    }
    stompClient.subscribe(
      destination: "/queue/room/${widget.room.id}",
      callback: (frame) {
        if (_isPending) {
          return;
        }
        setState(() {
          roomModel = RoomModel.fromJson(jsonDecode(frame.body ?? ""));
        });
      },
    );
    stompClient.subscribe(
      destination: "/queue/round/${widget.room.id}",
      callback: (frame) async {
        _isPending = true;
        print(frame.body);
        final roundModel = RoundModel.fromJson(jsonDecode(frame.body ?? ""));
        for (int i = 0; i < roundModel.cardModels.length; i++) {
          allCards[i].card.copy(roundModel.cardModels[i].playingCard);
        }
        for (var i = 0; i < players.length * 3; i++) {
          var player = players[i % players.length];
          var card = allCardStates[i];
          player.addCard(card);
          await Future.delayed(Duration(milliseconds: 200));
        }
        players
            .firstWhere((element) => element.tablePlace == 0)
            .playerCards
            .forEach((element) {
          element.currentState?.canOpen = true;
        });
      },
    );
    _roomBloc = getIt();
    _roundBloc = getIt();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final room = roomModel ?? widget.room;
    players = room.getPlayers(context, widget.mainPlayer);
    return BasePage(
      child: Stack(
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
          Stack(
            children: allCards,
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
      _isPending = true;
      await _roundBloc.start(widget.room.id);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Start game failed due to: ${error}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_RIGHT,
      );
    }
  }
}
