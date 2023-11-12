import 'package:animation_playground/data/source/remote/services/dio_client.dart';
import 'package:animation_playground/di/injection.dart';

abstract class PlayerRemoteDataSource {}

class PlayerRemoteDataSourceImpl implements PlayerRemoteDataSource {
  final DioService _dioService;

  PlayerRemoteDataSourceImpl() : _dioService = getIt();
}
