import 'package:animation_playground/blocs/blocs.dart';
import 'package:animation_playground/blocs/player/player_bloc.dart';
import 'package:animation_playground/blocs/room/room_bloc.dart';
import 'package:animation_playground/blocs/room/room_state.dart';
import 'package:animation_playground/core/common/constants/app_contants.dart';
import 'package:animation_playground/core/common/extensions/context_extensions.dart';
import 'package:animation_playground/data/models/room_model.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/helpers/app_helpers.dart';
import 'package:animation_playground/pages/base_page.dart';
import 'package:animation_playground/pages/manager/card_manager_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  final double maxContainWith = 500;
  final double containPadding = 32;

  late RoomBloc _roomBloc;
  late PlayerBloc _playerBloc;

  @override
  void initState() {
    _roomBloc = getIt();
    _playerBloc = getIt();
    _roomBloc.getRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isOverContainWith =
        context.screenSize.width < maxContainWith + containPadding * 2;
    if (isOverContainWith) {
      return BasePage(
        appBar: buildOverAppBar(context),
        child: Container(
          color: Colors.white,
          child: buildBlocConsumer(),
        ),
      );
    }
    return BasePage(
      appBar: buildAppBar(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: containPadding,
            ),
            width: maxContainWith,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: buildBlocConsumer(),
          ),
        ],
      ),
    );
  }

  Widget buildBlocConsumer() {
    return BlocConsumer(
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
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => showLogoutDialog(context),
      ),
      title: Row(
        children: [
          Text("Room page"),
          Spacer(),
          buildPlayerText(),
          const SizedBox(width: 16),
          buildAction(),
        ],
      ),
    );
  }

  PreferredSize buildOverAppBar(BuildContext buildContext) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => showLogoutDialog(context),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Room page"),
                  const SizedBox(width: 8),
                  buildPlayerText(),
                ],
              ),
            ),
            buildAction(),
          ],
        ),
      ),
    );
  }

  Widget buildPlayerText() {
    return Text(
      "Hello, ${widget.playerModel.name}",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget buildAction() {
    return Row(
      children: [
        InkWell(
          onTap: () => _roomBloc.getRooms(),
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
    );
  }

  void createNewRoom() {
    _roomBloc.createNew(widget.playerModel.id);
  }

  void goToCardManager(RoomModel roomModel) {
    Navigator.of(context)
        .push(
      AppHelpers.getFadeRoute(
        CardManagerPage(
          mainPlayer: widget.playerModel,
          room: roomModel,
        ),
      ),
    )
        .then((_) {
      _roomBloc.getRooms();
    });
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Notice"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              logout();
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  void logout() async {
    try {
      await _playerBloc.logout(widget.playerModel.id);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Has some thing wrong? $e",
        gravity: ToastGravity.TOP_RIGHT,
      );
    } finally {
      Navigator.of(context).pop();
    }
  }
}
