import 'package:animation_playground/classes/card.dart';
import 'package:animation_playground/classes/player.dart';
import 'package:animation_playground/core/common/extensions/context_extensions.dart';
import 'package:animation_playground/core/config/build_config.dart';
import 'package:animation_playground/di/injection.dart';
import 'package:animation_playground/models/card_manager_model.dart';
import 'package:animation_playground/pages/base_page.dart';
import 'package:animation_playground/pages/my_application.dart';
import 'package:animation_playground/widgets/card_manager.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import 'core/common/utils/app_preferences.dart';

double screenWidth = 0;
double screenHeight = 0;

void onConnect(StompFrame frame) {
  print("Connect successful!");
  stompClient.subscribe(
    destination: "/queue/player/success",
    callback: (p0) {
      print("po ${p0.body}");
    },
  );

  stompClient.subscribe(
    destination: "/queue/player/failed",
    callback: (p1) {
      print("po ${p1.body}");
    },
  );
}

final stompClient = StompClient(
  config: StompConfig(
    url: 'ws://192.168.0.29:8080/ws',
    onConnect: onConnect,
    beforeConnect: () async {
      print('connecting...');
    },
    onDisconnect: (p0) {
      print("onDisconnect");
    },
    onWebSocketError: (dynamic error) {
      print(error);
    },
  ),
);

void main() async {
  await BuildConfig.ensureInitialized(Environment.LOCAL);
  AppPreferences.instance = await SharedPreferences.getInstance();
  await configureDependencies();

  stompClient.activate();

  runApp(MyApplication());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Card Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Card Game Home Page'),
    );
  }
}

List<GlobalKey<CardItemState>> allC = List.generate(52, (index) => GlobalKey());

List<Player> allPlayers = List.generate(
  6,
  (index) => Player(
    tablePlace: index,
    name: "Sanzhar",
  ),
);

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = context.screenSize.width;
    screenHeight = context.screenSize.height;
    return BasePage(
      child: ScopedModel<CardManagerModel>(
        model: CardManagerModel()
          ..init(
            allC: allC,
            allPlayers: allPlayers,
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),
        child: CardManager(
          allCardKey: allC,
        ),
      ),
    );
  }
}
