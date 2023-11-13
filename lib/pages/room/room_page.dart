import 'package:animation_playground/pages/base_page.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Center(
        child: Text("Room page ${widget.playerModel.name}"),
      ),
    );
  }
}
