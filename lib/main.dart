import 'package:animation_playground/classes/card.dart';
import 'package:animation_playground/classes/player.dart';
import 'package:animation_playground/models/app_model.dart';
import 'package:animation_playground/models/card_manager_model.dart';
import 'package:animation_playground/widgets/cardManager.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

final AppModel model = AppModel();
double screenWidth = 0;
double screenHeight = 0;

void main() async {
  await model.init();
  runApp(MyApp());
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

Player mainPlayer = Player(tablePlace: 0, avatar: "sexy", name: "Daniyar");
Player player2 = Player(tablePlace: 2, avatar: "notsexy", name: "Elnar");
Player player3 = Player(tablePlace: 3, avatar: "notsexy", name: "Sundet");
Player player4 = Player(tablePlace: 4, avatar: "notsexy", name: "Sanzhar");

List<Player> allPlayers = List.generate(
  8,
  (index) => Player(
    tablePlace: index,
    avatar: "notsexy",
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
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ScopedModel<AppModel>(
      model: model,
      child: ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_card_game.png'),
                fit: BoxFit.fill,
              ),
            ),
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
          ),
        ),
      ),
    );
  }
}
