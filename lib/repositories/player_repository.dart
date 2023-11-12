import 'package:animation_playground/data/source/remote/data_sources/player_remote_data_source.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/repositories/repositories.dart';

abstract class PlayerRepository extends BaseRepository {}

class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerRemoteDataSource _playerRemoteDataSource;

  PlayerRepositoryImpl() : _playerRemoteDataSource = getIt();
}
