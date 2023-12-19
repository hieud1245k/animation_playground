import 'dart:convert';

import 'package:animation_playground/core/common/utils/utils.dart';
import 'package:animation_playground/helpers/app_helpers.dart';
import 'package:animation_playground/pages/base_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stomp_dart_client/stomp_handler.dart';

import '../../core/common/utils/app_preferences.dart';
import '../../data/models/player_model.dart';
import '../../main.dart';
import '../room/room_page.dart';

class HomePage extends StatefulWidget {
  final String playerName;

  const HomePage({
    super.key,
    this.playerName = "",
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    _nameController = TextEditingController()..text = widget.playerName;
    if (widget.playerName.isNotEmpty) {
      sendPlayerName();
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
          controller: _nameController,
          onFieldSubmitted: (value) => sendPlayerName(),
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
          onPressed: sendPlayerName,
          child: Text("Submit"),
        ),
      ],
    );
  }

  void sendPlayerName() {
    final playerName = _nameController.text;
    if (playerName.length < 4) {
      Fluttertoast.showToast(
        msg: "Player name should be greater than 4 characters",
      );
      return;
    }
    String path = "/specific/player/${Utils.convertNameToPath(playerName)}";
    print(path);
    StompUnsubscribe? successUnsubscribe;
    successUnsubscribe = stompClient.subscribe(
      destination: "$path/success",
      callback: (frame) async {
        successUnsubscribe?.call();
        print("success ${frame.body}");
        final playerModel = PlayerModel.fromJson(jsonDecode(frame.body ?? ""));
        await AppPreferences.instance.setString(
          "player_name",
          playerModel.name,
        );
        Navigator.of(context)
            .push(
          AppHelpers.getSlideLeftRightRoute(
            RoomPage(
              playerModel: playerModel,
            ),
          ),
        )
            .then((_) {
          AppPreferences.instance.remove("player_name");
        });
      },
    );
    StompUnsubscribe? failedUnsubscribe;
    failedUnsubscribe = stompClient.subscribe(
      destination: "$path/failed",
      callback: (frame) {
        failedUnsubscribe?.call();
        Fluttertoast.showToast(
          msg: "Submit failed! cause by: ${frame.body}",
          gravity: ToastGravity.TOP_RIGHT,
        );
      },
    );
    if (stompClient.connected) {
      stompClient.send(
        destination: "/app/add-player",
        body: playerName,
      );
    }
  }
}
