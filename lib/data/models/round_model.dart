import 'package:animation_playground/data/models/base_model.dart';
import 'package:animation_playground/data/models/card_model.dart';

class RoundModel extends BaseModel {
  final List<CardModel> cardModels;

  RoundModel({
    required super.id,
    required this.cardModels,
  });

  factory RoundModel.fromJson(Map? json) {
    final cardJson = json?["cards"] as List? ?? [];
    return RoundModel(
      id: json?["id"],
      cardModels: cardJson.map((e) => CardModel.fromJson(e)).toList(),
    );
  }
}
