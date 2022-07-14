import 'dart:io';

class OauthServer {
  Future<String?> runOauth(int port) async {
    late String? code;

    var server = await createServer(port);

    await for (HttpRequest request in server) {
      code = request.uri.queryParameters["code"];

      if (request.method != "GET" || code == null) {
        await request.response.close();
        continue;
      }

      request.response.write("Success: $code");
      await request.response.close();
      break;
    }
    server.close();
    return code;
  }

  Future<HttpServer> createServer(int port) async {
    const address = "localhost";
    return await HttpServer.bind(address, port);
  }
}
