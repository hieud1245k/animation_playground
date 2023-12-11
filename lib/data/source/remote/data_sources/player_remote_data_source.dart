import 'package:animation_playground/data/source/remote/services/dio_client.dart';
import 'package:animation_playground/di/injection.dart';

const _endpoint = "/api/players";

abstract class PlayerRemoteDataSource {
  Future logout(playerId);
}

class PlayerRemoteDataSourceImpl implements PlayerRemoteDataSource {
  final DioService _dioService;

  PlayerRemoteDataSourceImpl() : _dioService = getIt();

  @override
  Future logout(playerId) {
    final response = _dioService.post("$_endpoint/logout/$playerId");
    return response;
  }
}
