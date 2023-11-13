import 'package:animation_playground/blocs/blocs.dart';
import 'package:animation_playground/data/models/room_model.dart';

class GetRoomsSuccess extends BaseState {
  final List<RoomModel> rooms;

  GetRoomsSuccess({
    required this.rooms,
  });
}
