import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:periodico/Widgets/Widgets/details.dart';
import 'package:periodico/Widgets/Widgets/downloads.dart';
import 'package:periodico/Widgets/Widgets/genreSelected.dart';
import 'package:periodico/Widgets/Widgets/home.dart';
import 'package:periodico/Widgets/Widgets/pdfViewer.dart';
import 'package:periodico/Widgets/Widgets/search.dart';
import 'package:periodico/Widgets/Widgets/searchResult.dart';
import 'package:periodico/Widgets/Widgets/settings.dart';
import 'package:periodico/Widgets/Widgets/test.dart';
import 'package:periodico/providers/ThemeHandler.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  await initializeDateFormatting();
  runApp(MyApp());

  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("150b0b79-ffc3-4c2b-bce8-fa7ba19a9f4a");

  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeHandler(),
      builder: (context, child) {
        final theme = Provider.of<ThemeHandler>(context);
        return MaterialApp(
          theme: theme.theme,
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
          },
          initialRoute: '/home',
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
