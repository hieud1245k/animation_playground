import 'package:animation_playground/data/models/BaseModel.dart';
import 'package:animation_playground/data/models/player_model.dart';

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
}
