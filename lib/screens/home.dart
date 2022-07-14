import 'package:flutter/material.dart';
import 'package:trovo_helper/elements/drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: const Center(child: Center(child: Text("This is Home page"))),
      drawer: const NavDrawer(),
    );
  }
}
