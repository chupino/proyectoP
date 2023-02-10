import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  int _selectedIndex = 0;

  void _setIndex(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PERIODICO"),
      ),
      body: Center(
        child: Text(
          "$_selectedIndex",
          style: TextStyle(fontSize: 25),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "INICIO",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "BUSCAR"),
          BottomNavigationBarItem(
              icon: Icon(Icons.download), label: "DESCARGAS"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "AJUSTES")
        ],
        currentIndex: _selectedIndex,
        onTap: _setIndex,
      ),
    );
  }
}
