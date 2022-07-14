import 'dart:async';

import 'package:get/get.dart';
import 'package:retry/retry.dart';
import 'package:trovo_helper/api/api.dart';
import 'package:trovo_helper/api/stream/stream.dart';
import 'package:trovo_helper/const.dart';
import 'package:trovo_helper/utils/exceptions.dart';
import 'package:trovo_helper/utils/getx.dart';
import 'package:trovo_helper/utils/storage.dart';

import '../utils/models.dart';

class BotBackend {
  ChatStream? _chat;
  late String targetChannelName;
  late int channelId;

  final api = Api();

  bool ready = false;

  bool get running {
    if (_chat == null) return false;
    return _chat!.listening;
  }

  Future<void> init() async {
    if (ready) return;

    await api.init();
    ready = true;
  }

  Future<void> start() async {
    targetChannelName = await Config().read(targetChannelNameKey) ?? "";

    if (targetChannelName == "") {
      throw InvalidStorageValue("Empty targetChannelName");
    }

    var users = await api.getUsers([targetChannelName]);
    var user = (users.data as Map)["users"][0];
    print(user);
    channelId = int.parse(user["channel_id"]);

    _chat = await retry(
      () async {
        return await ChatStream(channelId: channelId).connect();
      },
      maxDelay: const Duration(seconds: 5),
    );

    api.setChannelId(channelId);

    var userData = await api.getChannelInfo(username: targetChannelName);
    Get.find<GlobalController>()
      ..setNickname(user["nickname"])
      ..setAvatar(Uri.parse((userData.data as Map)["profile_pic"]));
  }

  Future<StreamSubscription> subscribe(
      Function(ChatMessage data) onData) async {
    var sub = _chat!.subscribe((data) => onData(ChatMessage.fromMap(data)));
    return sub;
  }

  Stream<Map<String, dynamic>> getBroadcast() {
    return _chat!.getBroadcast();
  }

  Future<void> stop() async {
    if (!running) return;
    _chat!.cancel();
  }
}
