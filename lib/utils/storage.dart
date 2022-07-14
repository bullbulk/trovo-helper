import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:trovo_helper/const.dart';

class Config {
  static final _storage = LocalStorage(configFilename);

  Config._singletonConstructor();

  static final Config _instance = Config._singletonConstructor();

  factory Config() {
    return _instance;
  }

  static Future<void> init() async {
    await _storage.ready;
  }

  Future<dynamic> read(String key) async {
    return await _storage.getItem(key);
  }

  Future<void> write(String key, dynamic value) async {
    await _storage.setItem(key, value);
  }
}

class UserData {
  static const _storage = FlutterSecureStorage();

  UserData._singleton();

  static final UserData _instance = UserData._singleton();

  factory UserData() {
    return _instance;
  }

  Future<String?> get refreshToken async =>
      await _storage.read(key: refreshTokenKey);

  set refreshToken(value) => _storage.write(key: refreshTokenKey, value: value);

  Future<String?> get clientId async => await _storage.read(key: clientIdKey);

  set clientId(value) => _storage.write(key: clientIdKey, value: value);

  Future<String?> get clientSecret async =>
      await _storage.read(key: clientSecretKey);

  set clientSecret(value) => _storage.write(key: clientSecretKey, value: value);
}
