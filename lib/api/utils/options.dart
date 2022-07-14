import 'dart:async';

import 'package:dio/dio.dart';
import 'package:trovo_helper/utils/storage.dart';

const scopes = [
  "user_details_self",
  "channel_details_self",
  "channel_update_self",
  "channel_subscriptions",
  "chat_send_self",
  "send_to_my_channel",
  "manage_messages"
];

class CustomOptions extends BaseOptions {
  static late String? clientId;
  String accessToken = "xxxxxxxxxxxxxxxxxxx";

  CustomOptions._singleton({String baseUrl = ""}) {
    super.baseUrl = baseUrl;
  }

  static CustomOptions? _instance;

  factory CustomOptions({String baseUrl = ""}) {
    _instance ??= CustomOptions._singleton(baseUrl: baseUrl);
    return _instance ?? CustomOptions();
  }

  static Future<void> init() async {
    clientId = await UserData().clientId;
  }

  @override
  Map<String, dynamic> get headers => {
        "Accept": "application/json",
        "Client-ID": clientId,
        "Content-Type": "application/json",
        "Authorization": "OAuth $accessToken",
      };

  void setAccessToken(String token) {
    accessToken = token;
  }
}
