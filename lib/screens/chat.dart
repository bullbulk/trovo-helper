import 'package:flutter/material.dart';
import 'package:trovo_helper/elements/drawer.dart';

import '../elements/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      drawer: const NavDrawer(),
      body: const ChatWidget(),
    );
  }
}
