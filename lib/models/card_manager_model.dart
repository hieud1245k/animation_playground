//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:animation_playground/classes/card.dart';
import 'package:animation_playground/classes/player.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

/// APP MODEL
class CardManagerModel extends Model {
  double _screenWidth = 0;
  double _screenHeight = 0;
  List<GlobalKey<CardItemState>> allCards = [];
  List<Player> players = [];
  bool distributed = false;

  Future init({
    required List<GlobalKey<CardItemState>> allC,
    required List<Player> allPlayers,
    required double screenWidth,
    required double screenHeight,
  }) async {
    allCards = allC;
    players = allPlayers;

    _screenHeight = screenHeight;
    _screenWidth = screenWidth;

    //Setting player places to player class, however it should be in PlayerItem
    for (var player in players) {
      switch (player.tablePlace) {
        case 0: //Root player table place
          player.left = (_screenWidth / 2) - 50;
          player.top = _screenHeight - 150;
          break;
        case 1:
          player.left = 80;
          player.top = _screenHeight / 2;
          break;
        case 2:
          player.left = 80;
          player.top = 30;
          break;
        case 3: //Fron player table place
          player.left = (_screenWidth / 2);
          player.top = 15;
          break;
        case 4:
          player.left = _screenWidth - 80;
          player.top = 30;
          break;
        case 5:
          player.left = _screenWidth - 80;
          player.top = _screenHeight / 2;
          break;
        case 6:
          player.left = _screenWidth - 80;
          player.top = _screenHeight - 150;
          break;
        case 7:
          player.left = 80;
          player.top = _screenHeight - 150;
          break;
      }
    }
    //LocalShuffling card
    allC.shuffle();

    notifyListeners();
  }

  Future distribute() async {
    for (var i = 0; i < allCards.length; i++) {
      var player = players[i % players.length];
      var card = allCards[i];
      card.currentState?.canOpen = player.tablePlace == 0;
      player.addCard(card);
      await Future.delayed(Duration(milliseconds: 200));
    }
  }
}
