import 'package:flutter/material.dart';
import '../Fwidgets.dart';

class Ajustes extends StatefulWidget {
  const Ajustes({super.key});

  @override
  State<Ajustes> createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: appBar(),
      body: Center(
        child: Text(
          "AJUSTES",
          style: TextStyle(fontSize: 25),
        ),
      ),
      bottomNavigationBar: navBar(
        selectedIndex: 3,
        key: Key("3"),
      ),
    );
  }
}