import 'dart:convert';

import 'package:animation_playground/blocs/room/room_bloc.dart';
import 'package:animation_playground/blocs/round/round_bloc.dart';
import 'package:animation_playground/classes/card_item.dart';
import 'package:animation_playground/classes/player.dart';
import 'package:animation_playground/core/common/extensions/list_extensions.dart';
import 'package:animation_playground/data/models/card_model.dart';
import 'package:animation_playground/data/models/player_model.dart';
import 'package:animation_playground/data/models/room_model.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/main.dart';
import 'package:animation_playground/pages/base_page.dart';
import 'package:animation_playground/pages/manager/widgets/menu_item.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
  RoundModel? roundModel;

  @override
  void initState() {
    for (var i = 0; i < allCardStates.length; i++) {
      PlayingCard playingCard = PlayingCard(
        STANDARD_SUITS[
            ((i + 1) ~/ SUITED_VALUES.length) % STANDARD_SUITS.length],
        SUITED_VALUES[(i + 1) % SUITED_VALUES.length],
      );
      allCards.add(
        CardItem(
          state: allCardStates[i],
          color: Colors.black12,
          card: playingCard,
          onTap: () async {
            try {
              _roundBloc.openCard(roundModel?.id, playingCard);
            } catch (e) {
              Fluttertoast.showToast(msg: "Open card error, $e");
            }
          },
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
      destination: "/queue/room/round/${widget.room.id}",
      callback: (frame) async {
        _isPending = true;
        final roundModel = RoundModel.fromJson(jsonDecode(frame.body ?? ""));
        this.roundModel = roundModel;
        stompClient.subscribe(
          destination: "/queue/round/${roundModel.id}",
          callback: (roundFrame) {
            final newRoundModel =
                RoundModel.fromJson(jsonDecode(roundFrame.body ?? ""));
            int cardOpenCount = 0;
            for (int i = 0; i < newRoundModel.cardModels.length; i++) {
              CardModel newCardModel = newRoundModel.cardModels[i];
              if (newCardModel.isOpen) {
                cardOpenCount++;
                PlayingCard newPlayingCard = newCardModel.playingCard;
                for (var cardItem in allCards) {
                  PlayingCard originPlayingCard = cardItem.card;
                  if (originPlayingCard.suit == newPlayingCard.suit &&
                      originPlayingCard.value == newPlayingCard.value &&
                      originPlayingCard.playerId == newPlayingCard.playerId) {
                    cardItem.state.currentState?.openCard();
                    break;
                  }
                }
              }
            }
            if (cardOpenCount == newRoundModel.cardModels.length) {
              showWinnerAlert("Test");
            }
          },
        );
        for (int i = 0; i < roundModel.cardModels.length; i++) {
          var card = allCards[i].card;
          card.copy(roundModel.cardModels[i].playingCard);
          var player = players.firstWhereOrNull(
            (e) => e.playerId == card.playerId,
          );
          player?.addCard(allCards[i].state);
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
              widget.mainPlayer.id == room.playerModels[0].id &&
              !_isPending)
            Center(
              child: ElevatedButton(
                onPressed: startGame,
                child: Text("Start"),
              ),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: buildMenuWidget(),
          ),
        ],
      ),
    );
  }

  Widget buildMenuWidget() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: CircleAvatar(
          child: const Icon(
            Icons.menu,
            size: 24,
            color: Colors.blue,
          ),
        ),
        items: MenuItems.firstItems
            .map((item) => DropdownMenuItem<MenuItem>(
                  value: item,
                  child: MenuItems.buildItem(item),
                ))
            .toList(),
        onChanged: (value) {
          switch (value) {
            case MenuItems.leaveRoom:
              leaveRoom();
              break;
            case MenuItems.showHistories:
              showHistories();
              break;
          }
        },
        dropdownStyleData: DropdownStyleData(
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          offset: const Offset(0, 8),
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
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

  void showHistories() {
    showWinnerAlert("Hieu Nguyen");
  }

  void showWinnerAlert(String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Congrats"),
          content: Text("$name is winner!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  void startGame() async {
    try {
      setState(() {
        _isPending = true;
      });
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
