import 'package:animation_playground/classes/card_item.dart';
import 'package:animation_playground/classes/vector.dart';
import 'package:flutter/material.dart';

class Player {
  final dynamic playerId;
  final int tablePlace;
  final String name;
  final bool isAdmin;
  List<GlobalKey<CardItemState>> playerCards = [];
  double left = 0;
  double top = 0;

  Player({
    this.playerId,
    required this.tablePlace,
    required this.name,
    this.isAdmin = false,
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

  double get itemLeft {
    switch (tablePlace) {
      case 0:
        return left + 220;
      case 1:
      case 2:
        return left - 60;
      case 3:
        return left + 80;
      default:
        return left;
    }
  }

  double get itemTop {
    switch (tablePlace) {
      case 1:
      case 5:
        return top - 80;
      case 2:
      case 4:
        return top + 80;
      default:
        return top;
    }
  }

  Map<String, dynamic> get params => {
        "name": name,
        "table_place": tablePlace,
      };
}
