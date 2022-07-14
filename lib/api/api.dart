import "package:dio/dio.dart";
import 'package:dog/dog.dart';
import 'package:trovo_helper/api/auth/auth.dart';
import 'package:trovo_helper/api/utils/options.dart';

const authErrorCodes = [10703, 10710, 11704, 11714];

class Api {
  final AuthController authController = AuthController();

  static final Dio _client = Dio(_clientOptions);
  static final CustomOptions _clientOptions =
      CustomOptions(baseUrl: "https://open-api.trovo.live/openplatform");

  bool initialized = false;
  int? channelId;

  Future<void> init() async {
    _client.interceptors.add(InterceptorsWrapper(onError: onErrorMiddleware));
    await authController.refresh();
    initialized = true;
  }

  onErrorMiddleware(DioError e, ErrorInterceptorHandler handler) async {
    if (e.response != null) {
      dog.e(
        "${e.response!.requestOptions.data}\n"
        "${e.response!.data.toString()}\n",
      );
    }

    Map errorContent = e.response!.data;
    if (e.response?.statusCode == 401 &&
        authErrorCodes.contains(errorContent["status"])) {
      await authController.refresh();
      e.requestOptions.headers = _client.options.headers;
      return _retry(e.requestOptions);
    }

    return handler.next(e);
  }

  Future<void> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    _client.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  void setChannelId(int channelId) {
    this.channelId = channelId;
  }

  Future<Response> getUserInfo() async {
    return await _client.get("/getuserinfo");
  }

  Future<Response> getUsers(List<String> nicknames) async {
    Map<String, dynamic> body = {
      "user": nicknames,
    };
    return await _client.post("/getusers", data: body);
  }

  Future<Response> getChannelInfo({String? username, int? channelId}) async {
    Map<String, dynamic> body = {};

    if (username != null) {
      body["username"] = username;
    } else {
      if (channelId != null) {
        body["channel_id"] = channelId;
      } else {
        if (this.channelId != null) {
          body["channel_id"] = this.channelId;
        }
      }
    }
    if (body.isEmpty) {
      throw ArgumentError("You must provide at least 1 argument");
    }

    return await _client.post("/channels/id", data: body);
  }

  Future<Response> sendMy(String content) async {
    Map<String, dynamic> body = {
      "content": content,
    };
    return await _client.post("/chat/send", data: body);
  }

  Future<Response> send(String content, {int? channelId}) async {
    if (channelId == null) {
      if (this.channelId != null) {
        channelId = this.channelId;
      } else {
        throw ArgumentError.notNull("channelId");
      }
    }

    Map<String, dynamic> body = {
      "content": content,
      "channel_id": channelId,
    };
    return await _client.post("/chat/send", data: body);
  }

  Future<Response> delete(
    String messageId,
    int senderId, {
    int? channelId,
  }) async {
    if (channelId == null) {
      if (this.channelId != null) {
        channelId = this.channelId;
      } else {
        throw ArgumentError.notNull("channelId");
      }
    }

    return await _client
        .delete("/channels/$channelId/messages/$messageId/users/$senderId");
  }

  Future<Response> command(String command, {int? channelId}) async {
    if (channelId == null) {
      if (this.channelId != null) {
        channelId = this.channelId;
      } else {
        throw ArgumentError.notNull("channelId");
      }
    }

    Map<String, dynamic> body = {
      "command": command,
      "channel_id": channelId,
    };
    return await _client.post("/channels/command", data: body);
  }

  // Display a list of moderator of this channel.
  Future<Response> mods({int? channelId}) async {
    if (channelId == null) {
      if (this.channelId != null) {
        channelId = this.channelId;
      } else {
        throw ArgumentError.notNull("channelId");
      }
    }

    var command = "mods";
    return await this.command(command, channelId: channelId);
  }

  // Display a list of banned users for this channel.
  Future<Response> banned({int? channelId}) async {
    if (channelId == null) {
      if (this.channelId != null) {
        channelId = this.channelId;
      } else {
        throw ArgumentError.notNull("channelId");
      }
    }

    var command = "banned";
    return await this.command(command, channelId: channelId);
  }

  // Duration is zero: Ban a user from chat permanently.
  // Duration is not zero: Ban a user from chat for 'duration'.
  Future<Response> ban(String username, Duration duration,
      {int? channelId}) async {
    if (channelId == null) {
      if (this.channelId != null) {
        channelId = this.channelId;
      } else {
        throw ArgumentError.notNull("channelId");
      }
    }

    String command;
    if (duration == Duration.zero) {
      command = "ban $username";
    } else {
      command = "ban $username ${duration.inSeconds}s";
    }
    return await this.command(command, channelId: channelId);
  }

  // Remove ban on a user.
  Future<Response> unban(String username, {int? channelId}) async {
    if (channelId == null) {
      if (this.channelId != null) {
        channelId = this.channelId;
      } else {
        throw ArgumentError.notNull("channelId");
      }
    }

    var command = "unban $username";
    return await this.command(command, channelId: channelId);
  }

  // Grant moderator status to a user.
  Future<Response> mod(String username, {int? channelId}) async {
    var command = "mod $username";
    return await this.command(command, channelId: channelId);
  }

  // Revoke moderator status from a user.
  Future<Response> unmod(String username, {int? channelId}) async {
    var command = "unmod $username";
    return await this.command(command, channelId: channelId);
  }

  // Clear chat history for all viewers.
  Future<Response> clear({int? channelId}) async {
    var command = "clear";
    return await this.command(command, channelId: channelId);
  }

  // Limit how frequently users can send messages in chat.
  Future<Response> slow(Duration duration, {int? channelId}) async {
    var command = "slow ${duration.inSeconds}";
    return await this.command(command, channelId: channelId);
  }

  // Turn off slow mode.
  Future<Response> slowoff({int? channelId}) async {
    var command = "slowoff";
    return await this.command(command, channelId: channelId);
  }

  // Duration is zero: Restrict chat to followers based on their follow duration.
  // Duration is not zero: Restrict chat to followers only.
  Future<Response> followers(Duration duration, {int? channelId}) async {
    String command;
    if (duration == Duration.zero) {
      command = "followers";
    } else {
      command = "followers ${duration.inSeconds}s";
    }
    return await this.command(command, channelId: channelId);
  }

  // Turn off followers-only mode.
  Future<Response> followersoff({int? channelId}) async {
    var command = "followersoff";
    return await this.command(command, channelId: channelId);
  }

  // Stop live and hosting other channels.
  Future<Response> host(String username, {int? channelId}) async {
    var command = "host $username";
    return await this.command(command, channelId: channelId);
  }

  // Stop hosting channels.
  Future<Response> unhost({int? channelId}) async {
    var command = "unhost";
    return await this.command(command, channelId: channelId);
  }

  // Set title of your channel.
  Future<Response> settitle(String title, {int? channelId}) async {
    var command = "settitle $title";
    return await this.command(command, channelId: channelId);
  }

  // Set category of your channel.
  Future<Response> setcategory(String categoryName, {int? channelId}) async {
    var command = "setcategory $categoryName";
    return await this.command(command, channelId: channelId);
  }

  // Grant to user a custom role.
  Future<Response> addrole(String username, String roleName,
      {int? channelId}) async {
    var command = "addrole $roleName $username";
    return await this.command(command, channelId: channelId);
  }

  // Revoke from user a custom role.
  Future<Response> removerole(String username, String roleName,
      {int? channelId}) async {
    var command = "removerole $roleName $username";
    return await this.command(command, channelId: channelId);
  }

  // Fast clip the past 90-seconds stream in one channel.
  Future<Response> fastclip() async {
    var command = "fastclip";
    return await this.command(command, channelId: channelId);
  }
}
