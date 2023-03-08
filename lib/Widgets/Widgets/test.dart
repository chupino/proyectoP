import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:periodico/services/dataHandler.dart';

class testScreen extends StatefulWidget {
  const testScreen({super.key});

  @override
  State<testScreen> createState() => _testScreenState();
}

class _testScreenState extends State<testScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String postId = args['postId']! as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("Push Notification"),
      ),
      body: FutureBuilder(
        future: UserServices().getContentNotification(postId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            String htmlContent = snapshot.data!["content"];
            return Center(
              child: Container(
                child: Column(children: [
                  Text(snapshot.data!["id"].toString()),
                  Text(snapshot.data!["title"]),
                  //Text(snapshot.data!["content"]),
                  HtmlWidget(htmlContent),
                ]),
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No se pudo cargar los resultados. Revisa tu conexion",
                    style:
                        GoogleFonts.roboto(textStyle: TextStyle(fontSize: 25)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Icon(
                    Icons.wifi_off,
                    size: 50,
                  )
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
