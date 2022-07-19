import 'dart:io';

import 'package:dog/dog.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trovo_helper/api/utils/options.dart';
import 'package:trovo_helper/const.dart';
import 'package:trovo_helper/utils/getx.dart';
import 'package:trovo_helper/utils/images.dart';
import 'package:trovo_helper/utils/storage.dart';

Future<void> init() async {
  await CustomOptions.init();
  await Config.init();
  await initLogger();
  await initImages();

  if (!Get.isRegistered<BotController>()) {
    Get.put(MessagesController());
    Get.put(BotController());
    Get.put(GlobalController());

    if ((await Config().read(targetChannelNameKey) ?? "") != "") {
      Get.find<BotController>().startBot();
    }
  }
}

Future<void> initLogger() async {
  var docsPath = (await getApplicationDocumentsDirectory()).path;
  await Directory("$docsPath/logs").create();
  var file = File("$docsPath/logs/trovo_helper.txt");
  dog.registerHandler(Handler(
    formatter: PrettyFormatter(),
    emitter: FileEmitter(file: file),
  ));
}
