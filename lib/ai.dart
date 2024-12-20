import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff5c5aa7),
          title: const Text('Kommunicate sample app'),
        ),
        body: const Center(
            child: Text(
          "center",
        )),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.chat),
            onPressed: () async {
              KommunicateFlutterPlugin.openConversations();
              dynamic conversationObject = {
                'appId': "272bb1091d69a77adb831e84329b2f6fd"
              };
            }),
      ),
    );
  }
}
