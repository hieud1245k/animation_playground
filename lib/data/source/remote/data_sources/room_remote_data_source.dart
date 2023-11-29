import 'package:animation_playground/data/models/room_model.dart';
import 'package:animation_playground/data/source/remote/services/dio_client.dart';
import 'package:animation_playground/di/injection.dart';

abstract class RoomRemoteDataSource {
  Future<RoomModel> createNew(playerId);

  Future<List<RoomModel>> getAll();

  Future<RoomModel> leaveRoom(playerId, roomId);

  Future<RoomModel> joinRoom(playerId, roomId);
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final DioService _dioService;

  RoomRemoteDataSourceImpl() : _dioService = getIt<DioService>();

  @override
  Future<List<RoomModel>> getAll() async {
    final response = await _dioService.get(
      "/api/rooms/",
      queryParameters: {},
    );
    print(response);
    if (response is List) {
      return response.map((e) => RoomModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<RoomModel> createNew(playerId) async {
    final response = await _dioService.post(
      "/api/rooms/",
      queryParameters: {
        "player_id": playerId,
      },
    );
    return RoomModel.fromJson(response);
  }

  @override
  Future<RoomModel> leaveRoom(playerId, roomId) async {
    final response = await _dioService.put(
      "/api/rooms/remove-player/$roomId/",
      queryParameters: {
        "player_id": playerId,
      },
    );
    return RoomModel.fromJson(response);
  }

  @override
  Future<RoomModel> joinRoom(playerId, roomId) async {
    final response = await _dioService.put(
      "/api/rooms/join/$roomId/",
      queryParameters: {
        "player_id": playerId,
      },
    );
    return RoomModel.fromJson(response);
  }
}
