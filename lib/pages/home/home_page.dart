import 'package:animation_playground/pages/base_page.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 400,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.transparent.withOpacity(0.25),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: buildForm(),
          ),
        ],
      ),
    );
  }

  Column buildForm() {
    return Column(
      children: [
        Text(
          "Online Scratch Cards",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 48),
        TextFormField(
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: "Input name",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green,
              ),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: goToRoomPage,
          child: Text("Submit"),
        ),
      ],
    );
  }

  void goToRoomPage() {
    if (stompClient.connected) {
      stompClient.send(
        destination: "/app/add-player",
        body: "User name 1",
      );
    }
  }
}
