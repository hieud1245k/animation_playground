import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const BasePage({
    super.key,
    required this.child,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_card_game.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: child,
        ),
      ),
    );
  }
}
