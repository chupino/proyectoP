
import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';





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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeHandler(),
      builder: (context, child) {
        //final theme = Provider.of<ThemeHandler>(context);
        return MaterialApp(
          theme: Provider.of<ThemeHandler>(context).theme,
          routes: {
            '/home': (context) => Home(),
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
}
