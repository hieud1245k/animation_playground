import 'package:animation_playground/classes/card.dart';
import 'package:animation_playground/models/card_manager_model.dart';
import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:scoped_model/scoped_model.dart';

class CardManager extends StatefulWidget {
  final List<GlobalKey<CardItemState>> allCardKey;

  CardManager({
    Key? key,
    required this.allCardKey,
  }) : super(key: key);

  _CardManagerState createState() => _CardManagerState();
}

class _CardManagerState extends State<CardManager> {
  List<CardItem> allCards = [];
  @override
  void initState() {
    for (var i = 0; i < widget.allCardKey.length; i++) {
      allCards.add(
        CardItem(
          key: widget.allCardKey[i],
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
    return ScopedModelDescendant<CardManagerModel>(
      builder: (context, child, model) => Stack(
        children: <Widget>[
          if (!model.distributed)
            Align(
              alignment: Alignment(0, 0),
              child: TextButton(
                child: Text(
                  "Start",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    model.distributed = true;
                  });
                  model.distribute();
                },
              ),
            ),
          Stack(
            children: allCards,
          )
        ],
      ),
    );
  }
}
