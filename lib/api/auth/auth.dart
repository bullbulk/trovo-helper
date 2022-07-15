import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dog/dog.dart';
import 'package:get/get.dart' as getx;
import 'package:trovo_helper/api/auth/server.dart';
import 'package:trovo_helper/api/utils/options.dart';
import 'package:trovo_helper/api/utils/utils.dart';
import 'package:trovo_helper/utils/getx.dart';
import 'package:trovo_helper/utils/storage.dart';

class AuthController {
  static final CustomOptions _clientOptions =
  CustomOptions(baseUrl: "https://open-api.trovo.live/openplatform");
  static final Dio _client = Dio(_clientOptions);

  final UserData _userData = UserData();

  AuthController() {
    _client.interceptors.add(InterceptorsWrapper(onError: onErrorMiddleware));
  }

  onErrorMiddleware(DioError e, ErrorInterceptorHandler handler) {
    dog.e("""
          SENT ${e.response?.requestOptions.uri}\n
          Data: ${const JsonEncoder.withIndent('  ').convert(
        e.response?.requestOptions.data)}\n
          Headers: ${const JsonEncoder.withIndent('  ').convert(
        e.response?.requestOptions.headers)}\n
          RECEIVED ${e.response?.data}
          """);
    return handler.next(e);
  }

  Future<Tokens?> refresh() async {
    var refreshToken = await _userData.refreshToken;
    var clientSecret = await _userData.clientSecret;

    if (refreshToken == null) {
      var tokens = await runOauth();
      if (tokens != null) {
        await saveTokens(tokens);
      }
      return tokens;
    }

    late Response response;
    try {
      response = await _client.post(
        '/refreshtoken',
        data: {
          "client_secret": clientSecret,
          "grant_type": "refresh_token",
          "refresh_token": refreshToken,
        },
      );
    } on DioError {
      var tokens = await runOauth();
      if (tokens != null) {
        await saveTokens(tokens);
      }
      return tokens;
    }

    var tokens = Tokens.fromMap(response.data);
    await saveTokens(tokens);
    return tokens;
  }

  Future<void> saveTokens(Tokens tokens) async {
    _clientOptions.setAccessToken(tokens.accessToken);
    _userData.refreshToken = tokens.refreshToken;
  }

  Future<Tokens?> runOauth() async {
    int port = await getUnusedPort();

    var serverUri = Uri(
      scheme: "http",
      host: "localhost",
      port: port,
    );

    Uri authUri = Uri(
      scheme: "https",
      host: "open.trovo.live",
      path: "page/login.html",
      queryParameters: {
        "client_id": await _userData.clientId,
        "response_type": "code",
        "scope": scopes.join("+"),
        "redirect_uri": serverUri.toString()
      },
    );

    var globalController = getx.Get.find<GlobalController>();
    globalController.showUriDialog(authUri);

    String? oauthResult = await OauthServer().runOauth(port);

    if (oauthResult == null) {
      return null;
    }

    await globalController.dismissOverlay();

    String code = oauthResult;
    return await exchangeToken(code, serverUri.toString());
  }

  Future<Tokens> exchangeToken(String oauthToken, String redirectUri) async {
    var body = {
      "client_secret": await _userData.clientSecret,
      "grant_type": "authorization_code",
      "code": oauthToken,
      "redirect_uri": redirectUri
    };

    var response = await _client.post(
        "https://open-api.trovo.live/openplatform/exchangetoken",
        data: body);

    return Tokens.fromMap(response.data);
  }
}

class Tokens {
  late String accessToken;
  late String refreshToken;

  Tokens(this.accessToken, this.refreshToken);

  factory Tokens.fromMap(Map data) {
    return Tokens(data["access_token"], data["refresh_token"]);
  }

  @override
  String toString() {
    return "Tokens { accessToken: $accessToken, refreshToken: $refreshToken }";
  }
}
