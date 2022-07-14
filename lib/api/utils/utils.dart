import 'dart:io';

import 'package:random_string_generator/random_string_generator.dart';

String randomString({int length = 32}) {
  return RandomStringGenerator(fixedLength: length, hasSymbols: false)
      .generate();
}

Future<int> getUnusedPort() {
  return ServerSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
    var port = socket.port;
    socket.close();
    return port;
  });
}
