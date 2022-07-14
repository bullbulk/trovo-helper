import '../../utils/models.dart';
import '../backend.dart';

class CommandsHandler {
  BotBackend bot;

  String prefix = "!";

  late Map<String, Function(ChatMessage)> commands;

  CommandsHandler(this.bot) {
    commands = {
      'echo': echo,
    };
  }

  void handle(ChatMessage message) {
    if (!message.content.startsWith(prefix)) {
      return;
    }

    var content = message.content.substring(1, message.content.length);
    var splitted = content.split(" ");

    var command = commands[splitted[0]];
    if (command != null) {
      command(message);
    }
  }

  void echo(ChatMessage message) {
    var content = message.content.split(" ");
    var arguments = content.sublist(1, content.length);
    bot.api.send(arguments.toString());
  }
}
