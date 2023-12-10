import 'package:animation_playground/data/models/base_model.dart';
import 'package:animation_playground/data/models/card_model.dart';

class RoundModel extends BaseModel {
  final List<CardModel> cardModels;
  final dynamic winnerId;

  RoundModel({
    required super.id,
    required this.cardModels,
    this.winnerId,
  });

  factory RoundModel.fromJson(Map? json) {
    final cardJson = json?["cards"] as List? ?? [];
    return RoundModel(
      id: json?["id"],
      cardModels: cardJson.map((e) => CardModel.fromJson(e)).toList(),
      winnerId: json?["winner_id"],
    );
  }

  dynamic computeWinner() {
    Map<dynamic, List<CardModel>> cardMap = {};
    for (var card in cardModels) {
      List<CardModel> cards = cardMap[card.playerId] ?? [];
      cards.add(card);
      cardMap[card.playerId] = cards;
    }
  }
}
