import 'package:flutter/material.dart';

import '../Fwidgets.dart';

class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: appBar(),
      body: Center(
        child: Text(
          "DESCARGAS",
          style: TextStyle(fontSize: 25),
        ),
      ),
      bottomNavigationBar: navBar(
        selectedIndex: 2,
        key: Key("2"),
      ),
    );
  }
}
