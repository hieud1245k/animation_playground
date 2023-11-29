import 'package:animation_playground/blocs/blocs.dart';
import 'package:animation_playground/blocs/room/room_state.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/repositories/room_repository.dart';

class RoomBloc extends BaseBloc with SingleBlocMixin {
  final RoomRepository _repository;
  RoomBloc() : _repository = getIt();

  void getRooms() {
    single(
      () => _repository.getAll(),
      onSuccess: (data) => GetRoomsSuccess(rooms: data),
    );
  }

  void createNew(playerId) {
    print("createNew");
    single(
      () => _repository.createNew(playerId),
      onSuccess: (data) => CreateNewRoomSuccess(room: data),
    );
  }

  Future leaveRoom(playerId, roomId) {
    return _repository.leaveRoom(playerId, roomId);
  }

  void joinRoom(playerId, roomId) {
    single(
      () => _repository.joinRoom(playerId, roomId),
      onSuccess: (data) => JoinRoomSuccess(room: data),
    );
  }
}
