import 'package:animation_playground/data/models/round_model.dart';
import 'package:animation_playground/data/source/remote/services/dio_client.dart';
import 'package:animation_playground/di/injection.dart';

const _endpoint = "/api/rounds";

abstract class RoundRemoteDataSource {
  Future<RoundModel> create(roomId);
}

class RoundRemoteDataSourceImpl implements RoundRemoteDataSource {
  final DioService _dioService;

  RoundRemoteDataSourceImpl() : _dioService = getIt();

  @override
  Future<RoundModel> create(roomId) async {
    final response = await _dioService.post(
      "$_endpoint/",
      queryParameters: {
        "room_id": roomId,
      },
    );
    return RoundModel.fromJson(response);
  }
}
