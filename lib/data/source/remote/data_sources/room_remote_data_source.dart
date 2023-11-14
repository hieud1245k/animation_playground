import 'package:animation_playground/data/models/room_model.dart';
import 'package:animation_playground/data/source/remote/services/dio_client.dart';
import 'package:animation_playground/di/injection.dart';

abstract class RoomRemoteDataSource {
  Future<List<RoomModel>> getAll();
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
}
