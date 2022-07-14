import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trovo_helper/screens/bot.dart';
import 'package:trovo_helper/screens/chat.dart';
import 'package:trovo_helper/screens/home.dart';
import 'package:trovo_helper/screens/settings.dart';
import 'package:trovo_helper/utils/getx.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  final chatScreen = const ChatScreen();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: GetBuilder<GlobalController>(builder: (controller) {
                      if (controller.avatar == null) {
                        return Icon(
                          Icons.account_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 40,
                        );
                      } else {
                        return CachedNetworkImage(
                          imageUrl: controller.avatar.toString(),
                          fit: BoxFit.fitHeight,
                          width: 48,
                          height: 48,
                        );
                      }
                    }),
                    flex: 2,
                  ),
                  Expanded(
                    flex: 6,
                    child: GetBuilder<GlobalController>(
                      builder: (controller) {
                        return Text(
                          controller.nickname.value,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text("Home"),
            leading: Icon(
              Icons.home,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const MyHomePage()),
              );
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text("Chat"),
            leading: Icon(
              Icons.message,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              Get.to(chatScreen);
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text("Bot"),
            leading: Icon(
              Icons.code,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const BotScreen()));
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text("Settings"),
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsScreen()));
            },
          )
        ],
      ),
    );
  }
}
