import 'package:flutter/material.dart';

class StatusText extends StatelessWidget {
  final String text;

  const StatusText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.blueAccent,
      ),
    );
  }
}
