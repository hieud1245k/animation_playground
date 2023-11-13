import 'package:animation_playground/data/source/remote/data_sources/room_remote_data_source.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/repositories/repositories.dart';

import '../data/models/room_model.dart';

abstract class RoomRepository extends BaseRepository {
  Future<List<RoomModel>> getAll();
}

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource _roomRemoteDataSource;

  RoomRepositoryImpl() : _roomRemoteDataSource = getIt();

  @override
  Future<List<RoomModel>> getAll() {
    return _roomRemoteDataSource.getAll();
  }
}
