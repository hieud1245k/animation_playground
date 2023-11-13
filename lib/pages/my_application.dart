import 'package:animation_playground/blocs/player/player_bloc.dart';
import 'package:animation_playground/core/common/utils/app_preferences.dart';
import 'package:animation_playground/data/models/player_model.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/pages/home/home_page.dart';
import 'package:animation_playground/pages/room/room_page.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MyApplication extends StatefulWidget {
  const MyApplication({super.key});

  @override
  State<MyApplication> createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication> {
  late PlayerBloc _playerBloc;

  @override
  void initState() {
    _playerBloc = getIt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card games',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case ConnectState.SUCCESS:
              return _buildContent();
            default:
              return Center(
                child: const CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }

  Widget _buildContent() {
    return RoomPage(
      playerModel: PlayerModel(id: 1, name: "test"),
    );
    return HomePage(
      playerName: AppPreferences.instance.getString("player_name") ?? "",
    );
  }
}
