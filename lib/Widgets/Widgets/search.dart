import 'package:flutter/material.dart';
import 'package:periodico/Widgets/Fwidgets.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: appBar(),
      body: Center(
        child: Text(
          "BUSCAR",
          style: TextStyle(fontSize: 25),
        ),
      ),
      bottomNavigationBar: navBar(
        selectedIndex: 1,
        key: Key("1"),
      ),
    );
  }
}
