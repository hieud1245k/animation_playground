import 'package:playing_cards/playing_cards.dart';

class CardModel {
  final CardValue cardValue;
  final Suit suit;
  bool isOpen = false;

  CardModel({
    required this.cardValue,
    required this.suit,
    this.isOpen = false,
  });

  factory CardModel.fromJson(Map? json) {
    return CardModel(
      cardValue: SUITED_VALUES[json?["card_value"] ?? 0],
      suit: STANDARD_SUITS[json?["suit"] ?? 0],
    );
  }

  PlayingCard get playingCard => PlayingCard(suit, cardValue);
}
