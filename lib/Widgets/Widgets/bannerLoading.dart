import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:periodico/Widgets/Widgets/account.dart';
import 'package:periodico/Widgets/Widgets/details.dart';
import 'package:periodico/Widgets/Widgets/downloads.dart';
import 'package:periodico/Widgets/Widgets/errorScreen.dart';
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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../providers/ThemeHandler.dart';
import '../../services/dataHandler.dart';

class bannerLoading extends StatefulWidget {
  Map user;
  bannerLoading(
    {
      required this.user,
      super.key
    }
  );

  @override
  State<bannerLoading> createState() => _bannerLoadingState();
}

class _bannerLoadingState extends State<bannerLoading> {
    List datos1=[];
  bool errorFatal=false;
  String fechaGuardada="";
  late Uint8List datos2;
    Future<void> cargarDatos() async {
  final prefs=await SharedPreferences.getInstance();
   try {
    datos1 = await UserServices().getTitles();  
    bool testBool = await UserServices().checkDate();
    print("---------------------$testBool");
    if(testBool){
      datos2 = await UserServices().getThumbnail();
    }else{
      final data=await prefs.getString("datosThumbnail")!;
      final Map<String,dynamic> datos=json.decode(data);
      String mapaBytes=datos["bytes"];
      Uint8List bitesparaPasar=base64Decode(mapaBytes);
      print("++++++++++++++++${mapaBytes.runtimeType}");
      datos2=bitesparaPasar;
      fechaGuardada=datos["bytes"];
    }
    print(datos2);
  } catch (e) {
    errorFatal=true;
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
                  child:Shimmer(
                    period: Duration(milliseconds: 1500),
                    direction: ShimmerDirection.ltr,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.black,
                        Colors.white,
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                    child: Image.asset("assets/logo.png",height: 200,width: 250,),
                    )
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
            '/home': (context) => Home(notas: datos1!,imagenPDF: datos2,fecha: fechaGuardada,isPremium: widget.user["isPremium"],),
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
            '/error':(context)=> ErrorScreen()
          },
          initialRoute: errorFatal?'/error':'/home',
          debugShowCheckedModeBanner: false,
        );
      },
    );
      }
    },
  );
  }
}