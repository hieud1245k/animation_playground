import 'package:animation_playground/data/source/remote/data_sources/room_remote_data_source.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/repositories/repositories.dart';

import '../data/models/room_model.dart';

abstract class RoomRepository extends BaseRepository {
  Future<RoomModel> createNew(playerId);

  Future<List<RoomModel>> getAll();

  Future<RoomModel> leaveRoom(playerId, roomId);

  Future<RoomModel> joinRoom(playerId, roomId);
}

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource _roomRemoteDataSource;

  RoomRepositoryImpl() : _roomRemoteDataSource = getIt();

  @override
  Future<List<RoomModel>> getAll() {
    return _roomRemoteDataSource.getAll();
  }

  @override
  Future<RoomModel> createNew(playerId) {
    return _roomRemoteDataSource.createNew(playerId);
  }

  @override
  Future<RoomModel> leaveRoom(playerId, roomId) {
    return _roomRemoteDataSource.leaveRoom(playerId, roomId);
  }

  @override
  Future<RoomModel> joinRoom(playerId, roomId) {
    return _roomRemoteDataSource.joinRoom(playerId, roomId);
  }
}
