import 'package:animation_playground/blocs/blocs.dart';
import 'package:animation_playground/data/models/room_model.dart';

class GetRoomsSuccess extends BaseState {
  final List<RoomModel> rooms;

  GetRoomsSuccess({
    required this.rooms,
  });
}

class CreateNewRoomSuccess extends BaseState {
  final RoomModel room;

  CreateNewRoomSuccess({
    required this.room,
  });
}

class LeaveRoomSuccess extends BaseState {
  final RoomModel room;

  LeaveRoomSuccess({
    required this.room,
  });
}

class JoinRoomSuccess extends BaseState {
  final RoomModel room;

  JoinRoomSuccess({
    required this.room,
  });
}
