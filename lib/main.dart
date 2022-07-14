import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trovo_helper/screens/home.dart';

import 'custom_theme.dart';
import 'utils/init.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      _isLoading = true;
    });
    await init();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trovo Helper',
      theme: customTheme(context),
      navigatorKey: Get.key,
      home: _isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : const MyHomePage(),
    );
  }
}
