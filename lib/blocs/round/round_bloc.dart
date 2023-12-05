import 'package:animation_playground/blocs/blocs.dart';
import 'package:animation_playground/data/models/round_model.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/repositories/round_repository.dart';

class RoundBloc extends BaseBloc {
  final RoundRepository _roundRepository;

  RoundBloc() : _roundRepository = getIt();

  Future<RoundModel> start(roomId) {
    return _roundRepository.create(roomId);
  }
}
