import 'package:animation_playground/blocs/blocs.dart';
import 'package:animation_playground/blocs/room/room_bloc.dart';
import 'package:animation_playground/blocs/room/room_state.dart';
import 'package:animation_playground/core/common/constants/app_contants.dart';
import 'package:animation_playground/data/models/room_model.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/pages/base_page.dart';
import 'package:animation_playground/pages/manager/card_manager_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/player_model.dart';

class RoomPage extends StatefulWidget {
  final PlayerModel playerModel;

  const RoomPage({
    super.key,
    required this.playerModel,
  });

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  late RoomBloc _roomBloc;

  @override
  void initState() {
    _roomBloc = getIt();
    _roomBloc.getRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: buildAppBar(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 32),
            width: 500,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: BlocConsumer(
              bloc: _roomBloc,
              listener: (context, state) {
                if (state is CreateNewRoomSuccess) {
                  goToCardManager(state.room);
                }
                if (state is JoinRoomSuccess) {
                  goToCardManager(state.room);
                }
              },
              buildWhen: (previous, current) {
                return current is GetRoomsSuccess ||
                    previous is InitializedState && current is InProgressState;
              },
              builder: (context, state) {
                if (state is InProgressState) {
                  return Center(
                    child: const CircularProgressIndicator(),
                  );
                }
                if (state is GetRoomsSuccess) {
                  if (state.rooms.isEmpty) {
                    return Center(
                      child: Text("No rooms."),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.rooms.length,
                    itemBuilder: (context, index) {
                      final room = state.rooms[index];
                      return InkWell(
                        onTap: () {
                          _roomBloc.joinRoom(widget.playerModel.id, room.id);
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Room id: ${room.id}"),
                                  Text(
                                    "Players ${room.playerModels.length}/${AppConstants.maxPlayer}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1),
                          ],
                        ),
                      );
                    },
                  );
                }
                if (state is ErrorState) {
                  return Text(state.exception.message);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Text("Room page"),
          Spacer(),
          Text(
            "Hello, ${widget.playerModel.name}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: () {
              _roomBloc.getRooms();
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(
                  color: Colors.black12,
                  width: 1,
                ),
              ),
              child: Icon(Icons.refresh),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                color: Colors.black12,
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: createNewRoom,
              child: Row(
                children: [
                  Icon(Icons.add),
                  const SizedBox(width: 4),
                  Text(
                    "Create room",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void createNewRoom() {
    _roomBloc.createNew(widget.playerModel.id);
  }

  void goToCardManager(RoomModel roomModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CardManagerPage(
              mainPlayer: widget.playerModel, room: roomModel);
        },
      ),
    ).then((_) {
      _roomBloc.getRooms();
    });
  }
}
