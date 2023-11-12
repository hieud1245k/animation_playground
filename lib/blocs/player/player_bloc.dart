import 'package:animation_playground/blocs/blocs.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/repositories/player_repository.dart';

class PlayerBloc extends BaseBloc {
  final PlayerRepository _playerRepository;

  PlayerBloc() : _playerRepository = getIt();
}
