import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trovo_helper/elements/drawer.dart';
import 'package:trovo_helper/utils/getx.dart';

class BotScreen extends StatefulWidget {
  static const String routeName = '/bot';

  const BotScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BotScreenState();
}

class BotScreenState extends State<BotScreen> {
  final BotController _botController = Get.find<BotController>();

  void _startBot() async {
    await _botController.startBot();
  }

  void _stopBot() async {
    await _botController.stopBot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bot"),
      ),
      drawer: const NavDrawer(),
      body: Center(
        child: Column(
          children: [
            TextButton(child: const Text("Start bot"), onPressed: _startBot),
            TextButton(child: const Text("Stop bot"), onPressed: _stopBot),
          ],
        ),
      ),
    );
  }
}
