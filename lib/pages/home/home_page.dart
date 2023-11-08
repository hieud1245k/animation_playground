import 'package:animation_playground/classes/card.dart';
import 'package:animation_playground/classes/player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<CardItem> allCards;
  late List<Player> players;

  @override
  void initState() {
    allCards = [];
    players = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.2),
            child: TextButton(
              child: Text("Distribute"),
              onPressed: () {},
            ),
          ),
          Stack(
            children: allCards,
          ),
        ],
      ),
    );
  }
}
