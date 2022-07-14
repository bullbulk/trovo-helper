import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:trovo_helper/api/utils/options.dart';
import 'package:trovo_helper/api/utils/utils.dart';
import 'package:trovo_helper/utils/events.dart';

class ChatStream {
  Duration interval = const Duration(seconds: 30);

  int channelId;

  final Dio _client = Dio(CustomOptions());
  final EventBus _eventBus = EventBus();

  late WebSocket _socket;
  late Timer _timer;
  late int _startTimeSeconds;
  late Stream<Map<String, dynamic>> _broadcast;

  late String _lastNonce;

  bool get listening {
    if (_socket.closeCode != null) {
      return false;
    }
    return true;
  }

  ChatStream({required this.channelId}) {
    initEvents();
  }

  Future<String> _getChatToken() async {
    var resp = await _client.get(
        "https://open-api.trovo.live/openplatform/chat/channel-token/$channelId");
    var data = resp.data as Map;
    String token = data["token"];
    return token;
  }

  Future<WebSocket> _socketConnect() async {
    var socket = await WebSocket.connect("wss://open-chat.trovo.live/chat");

    await _auth(socket);
    log("Connected to chat");
    await startPinger();
    return socket;
  }

  Future<void> _auth(WebSocket socket) async {
    var token = await _getChatToken();
    var nonce = randomString();

    _lastNonce = nonce;
    socket.add(jsonEncode({
      "type": "AUTH",
      "nonce": nonce,
      "data": {"token": token}
    }));
  }

  void initEvents() {
    _eventBus.on<WebSocketClose>().listen((event) {
      _socket.close();
      _timer.cancel();
    });
  }

  Future<ChatStream> connect() async {
    _startTimeSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    _socket = await _socketConnect();
    _broadcast = listen().asBroadcastStream();
    return this;
  }

  Stream<Map<String, dynamic>> listen() async* {
    await for (var i in _socket) {
      var item = jsonDecode(i) as Map<String, dynamic>;
      print(item);
      if (item["type"] == "PONG" || item["type"] == "RESPONSE") {
        if (item["nonce"] != _lastNonce) {
          // throw InvalidNonce(
          //     "Last nonce: $_lastNonce. Obtained: ${item["nonce"]}",
          // );
        }
        continue;
      }
      if (item["data"] == null) continue;

      Map<String, dynamic> message = item["data"]["chats"][0];

      if (message["send_time"] < _startTimeSeconds) {
        continue;
      }

      yield message;
    }
  }

  StreamSubscription<Map<String, dynamic>> subscribe(
      Function(Map<String, dynamic> data) onData) {
    return _broadcast.listen(onData);
  }

  Stream<Map<String, dynamic>> getBroadcast() {
    return _broadcast;
  }

  void cancel() {
    _eventBus.fire(WebSocketClose());
  }

  Future<void> startPinger() async {
    _timer = Timer.periodic(interval, (timer) {
      var nonce = randomString();
      _lastNonce = nonce;
      _socket.add(jsonEncode({"type": "PING", "nonce": nonce}));
    });
  }
}
