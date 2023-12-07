import 'package:flutter/material.dart';

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [leaveRoom, showHistories];

  static const leaveRoom = MenuItem(
    text: 'Leave room',
    icon: Icons.logout,
  );
  static const showHistories = MenuItem(
    text: 'Show histories',
    icon: Icons.history,
  );

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: Colors.grey,
          size: 22,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }
}
