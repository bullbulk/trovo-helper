import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trovo_helper/api/bot/bot.dart';
import 'package:trovo_helper/api/utils/models.dart';
import 'package:trovo_helper/elements/alert_box.dart';

class BotController extends GetxController {
  final Bot bot = Bot();
  final chatMessages = <MessageItem>[].obs;
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

  Future<void> onData(MessageItem value) async {
    chatMessages.add(value);
    // TODO: Create setting with messages limit
    if (chatMessages.length > 300) {
      chatMessages.removeAt(0);
    }

    update();
    update(["chatWidgetUpdate"]);
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
      Function(MessageItem data) onData) async {
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

  Future<void> dismissOverlay() async {
    var context = Get.overlayContext;
    if (context != null) {
      Navigator.of(context).pop();
    }
  }

  Future<void> showUriDialog(Uri uri) async {
    return await Get.defaultDialog(
        title: "Authentication required",
        barrierDismissible: false,
        content: UriAlertBox(uri, dismissOverlay));
  }
}

class MessagesController extends GetxController {
  newMessage() {
    update(); // Tell every listener that we received a message
  }
}
