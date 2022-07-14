import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trovo_helper/api/bot/bot.dart';
import 'package:trovo_helper/api/utils/models.dart';

class BotController extends GetxController {
  final Bot bot = Bot();
  final chatMessages = <ChatMessage>[].obs;
  final List<StreamSubscription> _streamSubs = [];

  bool running = false;
  bool starting = false;
  bool stopping = false;

  bool get ready => bot.ready;

  Future<void> startBot() async {
    if (running || (starting || stopping)) {
      return;
    }
    starting = true;

    try {
      if (!ready) await bot.init();
      await bot.start();
      await bot.subscribe(onData);

      running = true;
    } finally {
      starting = false;
    }
  }

  Future<void> onData(ChatMessage value) async {
    chatMessages.add(value);
    update();
  }

  Future<void> stopBot() async {
    if (!running || (starting || stopping)) return;
    stopping = true;

    await bot.stop();
    for (var element in _streamSubs) {
      element.cancel();
    }

    running = false;
    stopping = false;
  }

  Future<StreamSubscription?> subscribe(
      Function(ChatMessage data) onData) async {
    if (!ready) return null;

    var sub = await bot.subscribe(onData);
    _streamSubs.add(sub);
    return sub;
  }
}

class GlobalController extends GetxController {
  Rx<Uri>? avatar;
  var nickname = "Trovo Helper".obs;

  setAvatar(Uri uri) {
    avatar = uri.obs;
    update();
  }

  setNickname(String nickname) {
    this.nickname = nickname.obs;
    update();
  }

  showDialog(String text) {
    Get.defaultDialog(
      title: "Authentication required",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Go to the following link:"),
          const SizedBox(height: 12),
          SizedBox(
            width: 400,
            child: SelectableText(text),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                child: const Text("Copy"),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: text));
                },
              ),
              ElevatedButton(
                child: const Text("Close"),
                onPressed: () {
                  var context = Get.overlayContext;
                  if (context != null) {
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

class MessagesController extends GetxController {
  newMessage() {
    update(); // Tell every listener that we received a message
  }
}
