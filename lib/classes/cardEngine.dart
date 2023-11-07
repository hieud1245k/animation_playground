import 'package:flutter/material.dart';

class CardEngine extends StatefulWidget {
  CardEngine({
    required Key key,
    required this.cards,
  }) : super(key: key);
  final List<Widget> cards;
  _CardEngineState createState() => _CardEngineState();
}

class _CardEngineState extends State<CardEngine> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: widget.cards,
    );
  }
}

class CardEngines {
  final List<Card> cards;
  CardEngines({
    required this.cards,
  });
}
