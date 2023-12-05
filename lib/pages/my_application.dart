import 'package:animation_playground/blocs/player/player_bloc.dart';
import 'package:animation_playground/core/common/extensions/context_extensions.dart';
import 'package:animation_playground/core/common/utils/app_preferences.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/pages/home/home_page.dart';
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
    screenWidth = context.screenSize.width;
    screenHeight = context.screenSize.height;
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
            case ConnectState.ERROR:
              return Center(
                child: Text(
                  "Connect to server error",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              );
            case ConnectState.IN_PROGRESS:
              return Center(
                child: const CircularProgressIndicator(),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildContent() {
    // return RoomPage(
    //   playerModel: PlayerModel(id: 1, name: "test"),
    // );
    return HomePage(
      playerName: AppPreferences.instance.getString("player_name") ?? "",
    );
  }
}
