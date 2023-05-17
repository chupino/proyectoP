
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:periodico/Widgets/Widgets/account.dart';
import 'package:periodico/Widgets/Widgets/bannerLoading.dart';
import 'package:periodico/Widgets/Widgets/details.dart';
import 'package:periodico/Widgets/Widgets/downloads.dart';
import 'package:periodico/Widgets/Widgets/errorScreen.dart';
import 'package:periodico/Widgets/Widgets/favouriteTags.dart';
import 'package:periodico/Widgets/Widgets/genreSelected.dart';
import 'package:periodico/Widgets/Widgets/home.dart';
import 'package:periodico/Widgets/Widgets/login.dart';
import 'package:periodico/Widgets/Widgets/loginSkip.dart';
import 'package:periodico/Widgets/Widgets/logoCargando.dart';
import 'package:periodico/Widgets/Widgets/pdfViewer.dart';
import 'package:periodico/Widgets/Widgets/search.dart';
import 'package:periodico/Widgets/Widgets/searchResult.dart';
import 'package:periodico/Widgets/Widgets/settings.dart';
import 'package:periodico/Widgets/Widgets/test.dart';
import 'package:periodico/Widgets/Widgets/themeChooser.dart';
import 'package:periodico/providers/ThemeHandler.dart';
import 'package:periodico/services/dataHandler.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';





void main() async {

  await initializeDateFormatting();
  runApp(MyApp());

  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("63a4b7f3-9919-4a50-96de-d60ac7fcc95a");

  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  UserServices().initKeys();
}

class MyApp extends StatefulWidget {
  static final GlobalKey<_MyAppState> myAppKey = GlobalKey<_MyAppState>();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  ThemeMode _themeMode = ThemeMode.light;
  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
          
    });
  }

  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";

  Future<Map?> getLogin() async{
    try{
          final prefs=await SharedPreferences.getInstance();
    Map<String,dynamic> values={};
    values["login"]=prefs.getBool("login");
    values["darkMode"]=prefs.getBool("darkMode");
    return values;
    }catch(e){
      throw "error";
    }

  }
  FutureBuilder preApp() {

    return FutureBuilder(
      future: getLogin(),
      builder: (context,snapshot){
        if(snapshot.data?["login"]==null || snapshot.data!["login"]==true){
          
          return ChangeNotifierProvider(
            create: (context) => ThemeHandler(),
            builder: (context,child){
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: Provider.of<ThemeHandler>(context).theme,
              home: LoginSkipPage()
            );
            }

          );
        }else{
          return bannerLoading();
        }
      });
  }


  @override
  Widget build(BuildContext context) {
    return preApp();
  }

}
