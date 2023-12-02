import 'package:animation_playground/data/models/base_model.dart';

class PlayerModel extends BaseModel {
  final String name;
  final int tablePlace;

  PlayerModel({
    required super.id,
    required this.name,
    this.tablePlace = 0,
  });

  factory PlayerModel.fromJson(Map? json) {
    return PlayerModel(
      id: json?["id"],
      name: json?["name"] ?? "",
      tablePlace: json?["table_place"] ?? 0,
    );
  }
}
