import 'package:animation_playground/classes/card_item.dart';
import 'package:animation_playground/classes/player.dart';
import 'package:animation_playground/widgets/player_item.dart';
import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

class CardManager extends StatefulWidget {
  final List<GlobalKey<CardItemState>> allCardKey;
  final List<Player> players;

  CardManager({
    Key? key,
    required this.allCardKey,
    required this.players,
  }) : super(key: key);

  _CardManagerState createState() => _CardManagerState();
}

class _CardManagerState extends State<CardManager> {
  List<CardItem> allCards = [];
  bool distributed = false;

  @override
  void initState() {
    for (var i = 0; i < widget.allCardKey.length; i++) {
      allCards.add(
        CardItem(
          state: widget.allCardKey[i],
          color: Colors.black12,
          card: PlayingCard(
            STANDARD_SUITS[
                ((i + 1) ~/ SUITED_VALUES.length) % STANDARD_SUITS.length],
            SUITED_VALUES[(i + 1) % SUITED_VALUES.length],
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment(0, 0),
          child: distributed
              ? Text(
                  "Click on the card to open it",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                )
              : ElevatedButton(
                  child: Text(
                    "Start",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent,
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      distributed = true;
                    });
                    var players = widget.players;
                    for (var i = 0; i < players.length * 3; i++) {
                      var player = players[i % players.length];
                      var card = widget.allCardKey[i];
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
                ),
        ),
        Stack(
          children: allCards,
        ),
        Stack(
          children: widget.players.map((e) => PlayerItem(player: e)).toList(),
        ),
      ],
    );
  }
}
