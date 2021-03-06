import 'package:flutter/material.dart';
import 'package:trovo_helper/api/utils/options.dart';
import 'package:trovo_helper/const.dart';
import 'package:trovo_helper/elements/drawer.dart';
import 'package:trovo_helper/elements/obscured_field.dart';
import 'package:trovo_helper/utils/storage.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  SettingsScreen({Key? key}) : super(key: key);

  final _userData = UserData();
  final _config = Config();

  final targetChannelNameController = TextEditingController();
  final clientIdController = TextEditingController();
  final clientSecretController = TextEditingController();
  final roleManaAmountController = TextEditingController();
  final roleNameController = TextEditingController();

  Future<void> saveSettings() async {
    _userData.clientId = clientIdController.text;
    _userData.clientSecret = clientSecretController.text;
    await _config.write(targetChannelNameKey, targetChannelNameController.text);
    await _config.write(roleManaAmountKey, roleManaAmountController.text);
    await _config.write(roleNameKey, roleNameController.text);

    CustomOptions.refresh();
  }

  void readValues() {
    _config.read(targetChannelNameKey).then((value) {
      targetChannelNameController.text = value ?? "";
    });
    _userData.clientId.then((value) => clientIdController.text = value ?? "");
    _userData.clientSecret
        .then((value) => clientSecretController.text = value ?? "");
    _config.read(roleManaAmountKey).then((value) {
      roleManaAmountController.text = value ?? "";
    });
    _config.read(roleNameKey).then((value) {
      roleNameController.text = value ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    readValues();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        drawer: const NavDrawer(),
        body: Center(
          child: SizedBox(
            width: 600,
            child: Center(
              child: ListView(
                children: <Widget>[
                  TextField(
                    controller: targetChannelNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Target channel name',
                    ),
                  ),
                  ObscuredTextField(
                    controller: clientIdController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Client ID',
                    ),
                  ),
                  ObscuredTextField(
                    controller: clientSecretController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Client secret',
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: roleManaAmountController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Mana role starting amount',
                    ),
                  ),
                  TextField(
                    controller: roleNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Mana role name',
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await saveSettings();
                      },
                      child: const Text("Save"))
                ],
              ),
            ),
          ),
        ),
    );
  }
}
