import 'package:flutter/material.dart';

import '../Fwidgets.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: appBar(),
      body: Center(
        child: Text(
          "INICIO",
          style: TextStyle(fontSize: 25),
        ),
      ),
      bottomNavigationBar:
          navBar(selectedIndex:0, key: Key("0"),),
    );
  }
}
