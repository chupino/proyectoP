import 'package:flutter/material.dart';
import 'package:periodico/Widgets/Widgets/downloads.dart';
import 'package:periodico/Widgets/Widgets/home.dart';
import 'package:periodico/Widgets/Widgets/search.dart';
import 'package:periodico/Widgets/Widgets/settings.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/home': (context) => Home(),
      '/search': (context) => Search(),
      '/downloads': (context) => Downloads(),
      '/settings': (context) => Ajustes(),
    },
    initialRoute: '/home',
    debugShowCheckedModeBanner: false,
  ));
}
