import 'package:animation_playground/blocs/player/player_bloc.dart';
import 'package:animation_playground/core/common/utils/app_preferences.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      home: ChangeNotifierProvider<bool>(
        create: (context) => true,
        builder: (context, child) {
          return HomePage();
        },
      ),
    );
  }

  Widget _buildContent() {
    String? playerName = AppPreferences.instance.getString("player_name");
    if (playerName == null) {
      return HomePage();
    }

    return HomePage();
  }
}
