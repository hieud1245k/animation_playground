import 'package:animation_playground/data/models/BaseModel.dart';

class PlayerModel extends BaseModel {
  final String name;

  PlayerModel({
    required super.id,
    required this.name,
  });

  factory PlayerModel.fromJson(Map? json) {
    return PlayerModel(
      id: json?["id"],
      name: json?["name"] ?? "",
    );
  }
}
