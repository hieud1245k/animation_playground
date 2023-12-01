import 'package:animation_playground/core/common/extensions/context_extensions.dart';
import 'package:animation_playground/data/models/BaseModel.dart';
import 'package:animation_playground/data/models/player_model.dart';
import 'package:flutter/cupertino.dart';

import '../../classes/player.dart';

class RoomModel extends BaseModel {
  final List<PlayerModel> playerModels;

  RoomModel({
    required super.id,
    required this.playerModels,
  });

  factory RoomModel.fromJson(Map? json) {
    final playerJson = json?["playerDTOs"] as List? ?? [];
    return RoomModel(
      id: json?["id"],
      playerModels: playerJson.map((e) => PlayerModel.fromJson(e)).toList(),
    );
  }

  List<Player> getPlayers(BuildContext context, PlayerModel mainPlayer) {
    List<Player> players = [];
    final playerModels = [
      mainPlayer,
      ...this.playerModels.where((e) => e.id != mainPlayer.id),
    ];
    for (var i = 0; i < playerModels.length; i++) {
      Player player = Player(
        tablePlace: i,
        name: playerModels[i].name,
      );
      double _screenWidth = context.screenSize.width;
      double _screenHeight = context.screenSize.height;
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
      players.add(player);
    }
    return players;
  }
}
