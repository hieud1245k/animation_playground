import 'package:animation_playground/classes/player.dart';
import 'package:flutter/material.dart';

class PlayerItem extends StatelessWidget {
  final Player player;

  const PlayerItem({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: player.itemLeft,
      top: player.itemTop,
      child: Column(
        children: [
          SizedBox.square(
            dimension: 44,
            child: CircleAvatar(
              backgroundColor: Colors.white70,
              child: Icon(
                Icons.person,
                size: 36,
                color: Colors.greenAccent,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${player.name}_${player.tablePlace}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
