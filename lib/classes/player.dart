import 'package:animation_playground/classes/card.dart';
import 'package:animation_playground/classes/vector.dart';
import 'package:flutter/material.dart';

class Player {
  final int tablePlace;
  final String avatar;
  final String name;
  List<GlobalKey<CardItemState>> playerCards = [];
  double left = 0;
  double top = 0;

  Player({
    required this.tablePlace,
    required this.avatar,
    required this.name,
  });

  Vector get playerPosition => new Vector(left, top);

  void addCard(GlobalKey<CardItemState> newCard) {
    playerCards.add(newCard);
    if (tablePlace != 0) {
      switch (playerCards.length) {
        case 1:
          newCard.currentState?.moveTo(Vector(left - 25 - 50, top));
          break;
        case 2:
          newCard.currentState?.moveTo(Vector(left - 25, top));
          break;
        case 3:
          newCard.currentState?.moveTo(Vector(left - 25 + 50, top));
          break;
        default:
      }
      //newCard.currentState.moveTo(playerPosition);
      newCard.currentState?.scaleTo(Vector(50, 75));
    } else {
      switch (playerCards.length) {
        case 1:
          newCard.currentState?.moveTo(Vector(left - 110, top - 50));
          break;
        case 2:
          newCard.currentState?.moveTo(Vector(left, top - 50));
          break;
        case 3:
          newCard.currentState?.moveTo(Vector(left + 110, top - 50));
          break;
        default:
      }
      //newCard.currentState.moveTo(playerPosition);
      newCard.currentState?.scaleTo(Vector(100, 142.8));
    }
  }
}
