import '../../utils/models.dart';
import '../backend.dart';

class CommandsHandler {
  BotBackend bot;

  String prefix = "!";

  late Map<String, Function(MessageItem)> commands;

  CommandsHandler(this.bot) {
    commands = {
      'echo': echo,
    };
  }

  void handle(MessageItem message) {
    var content = message.content.trim();
    if (!content.startsWith(prefix)) {
      return;
    }

    var pureContent = content.substring(prefix.length, message.content.length);
    var contentParts = pureContent.split(" ");

    var command = commands[contentParts[0]];
    if (command != null) {
      command(message);
    }
  }

  void echo(MessageItem message) {
    var content = message.content.split(" ");
    var arguments = content.sublist(1, content.length);
    bot.api.send(arguments.toString());
  }
}
