import 'package:animation_playground/data/source/remote/data_sources/round_remote_data_source.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/repositories/repositories.dart';

import '../data/models/round_model.dart';

abstract class RoundRepository extends BaseRepository {
  Future<RoundModel> create(roomId);

  Future<RoundModel> openCard(roomId, Map<String, dynamic> params);
}

class RoundRepositoryImpl implements RoundRepository {
  final RoundRemoteDataSource _roundRemoteDataSource;

  RoundRepositoryImpl() : _roundRemoteDataSource = getIt();

  @override
  Future<RoundModel> create(roomId) {
    return _roundRemoteDataSource.create(roomId);
  }

  @override
  Future<RoundModel> openCard(roomId, Map<String, dynamic> params) {
    print(params);
    return _roundRemoteDataSource.openCard(roomId, params);
  }
}
