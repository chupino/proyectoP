
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:periodico/Widgets/Widgets/account.dart';
import 'package:periodico/Widgets/Widgets/details.dart';
import 'package:periodico/Widgets/Widgets/downloads.dart';
import 'package:periodico/Widgets/Widgets/favouriteTags.dart';
import 'package:periodico/Widgets/Widgets/genreSelected.dart';
import 'package:periodico/Widgets/Widgets/home.dart';
import 'package:periodico/Widgets/Widgets/login.dart';
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
  List datos1=[];
  late Uint8List datos2;
  Future<void> cargarDatos() async {
    final prefs=await SharedPreferences.getInstance();
   try {
    datos1 = await UserServices().getTitles();  
    bool testBool = await UserServices().checkDate().timeout(Duration(minutes: 2));
    if(testBool){
      datos2 = await UserServices().getThumbnail();
    }else{
      final data=await prefs.getString("datosThumbnail")!;
      final Map<String,dynamic> datos=json.decode(data);
      String mapaBytes=datos["bytes"];
      Uint8List bitesparaPasar=base64Decode(mapaBytes);
      print("++++++++++++++++${mapaBytes.runtimeType}");
      datos2=bitesparaPasar;
    }
    print(datos2);
  } catch (e) {
    print("Ha ocurrido un error: $e");
  }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cargarDatos(),
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Color(0xFF5CCB5F),
              body: Center(
                    child:SpinKitWave(
                      color: Colors.white,
                      size: 50.0,
                    ),
              ),
            ),
          );
        }else{
          return ChangeNotifierProvider(
        create: (context) => ThemeHandler(),
        builder: (context, child) {
          //final theme = Provider.of<ThemeHandler>(context);
          return MaterialApp(
            theme: Provider.of<ThemeHandler>(context).theme,
            routes: {
              '/home': (context) => Home(notas: datos1!,imagenPDF: datos2),
              '/search': (context) => Search(),
              '/downloads': (context) => Downloads(),
              '/settings': (context) => Ajustes(),
              '/details': (context) => Details(),
              '/pdfViewer': (context) => PdfViewerW(),
              '/searchResult': (context) => searchResult(),
              '/genreSelected': (context) => GenreSelected(),
              '/notification': (context) => testScreen(),
              '/account': (context) => Account(),
              '/favourites': (context) => Favourite(),
              '/themeChooser': (context) => ThemeChooser(),
              '/login': (context) => LoginPage(),
            },
            initialRoute: '/home',
            debugShowCheckedModeBanner: false,
          );
        },
      );
        }
      },
    );
  }
}
