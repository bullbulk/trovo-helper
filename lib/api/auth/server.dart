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

      request.response.headers.contentType = ContentType.html;
      request.response.write("""
          <!doctype html>
          <html lang="en">
          <head>
            <meta charset="utf-8">
            <title>Success</title>
          </head>
          <body>
            <div>$code</div>
            <script type="text/javascript">
              window.open("","_parent","");
              setTimeout(window.close, 2000);
            </script>
          </body>
          </html>
          """);
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
