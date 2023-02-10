import 'package:flutter/material.dart';

class appBar extends StatelessWidget implements PreferredSizeWidget {
  const appBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("PERIODICO"),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class navBar extends StatefulWidget {
  final int selectedIndex;
  const navBar({required Key key, required this.selectedIndex})
      : super(key: key);

  @override
  State<navBar> createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  late int _selectedIndex;
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  void _setIndex(int value) {
    setState(() {
      _selectedIndex = value;
    });
    switch (value) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');

        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/search');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/downloads');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 30,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "INICIO",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "BUSCAR"),
        BottomNavigationBarItem(icon: Icon(Icons.download), label: "DESCARGAS"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "AJUSTES")
      ],
      currentIndex: _selectedIndex,
      onTap: _setIndex,
    );
  }
}
