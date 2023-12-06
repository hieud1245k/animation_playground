import 'package:animation_playground/blocs/blocs.dart';
import 'package:animation_playground/data/models/round_model.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/repositories/round_repository.dart';
import 'package:playing_cards/playing_cards.dart';

class RoundBloc extends BaseBloc {
  final RoundRepository _roundRepository;

  RoundBloc() : _roundRepository = getIt();

  Future<RoundModel> start(roomId) {
    return _roundRepository.create(roomId);
  }

  Future<RoundModel> openCard(roomId, PlayingCard playingCard) {
    return _roundRepository.openCard(roomId, {
      "suit": STANDARD_SUITS.indexOf(playingCard.suit),
      "card_value": SUITED_VALUES.indexOf(playingCard.value),
      "player_id": playingCard.playerId,
      "is_open": true,
    });
  }
}
