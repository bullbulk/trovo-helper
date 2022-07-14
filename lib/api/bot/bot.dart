import 'dart:convert';

import 'package:trovo_helper/api/bot/backend.dart';
import 'package:trovo_helper/const.dart';
import 'package:trovo_helper/utils/storage.dart';

import '../utils/models.dart';
import 'commands/handler.dart';

class Bot extends BotBackend {
  late int selfId;
  late CommandsHandler commands;

  @override
  Future<void> start() async {
    await super.start();
    selfId = int.parse((await api.getUserInfo()).data['userId']);
    await subscribe(onData);

    commands = CommandsHandler(this);
  }

  Future<void> onData(ChatMessage data) async {
    handleMessage(data);
  }

  Future<void> handleMessage(ChatMessage message) async {
    if (message.senderId == selfId) return;

    // Mana
    if (message.type == 5 || message.type == 5009) {
      var content = jsonDecode(message.content);
      handleMana(
        message,
        content["gift_value"],
        content["num"],
      );
    }

    if (message.content.startsWith(commands.prefix)) {
      commands.handle(message);
    }
  }

  Future<void> handleMana(ChatMessage message, int value, int num) async {
    var roleManaAmount = int.parse(await Config().read(roleManaAmountKey));

    if (value * num >= roleManaAmount) {
      await api.addrole(message.nickname, await Config().read(roleNameKey));
    }
  }
}
