import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:periodico/Widgets/Widgets/bannerLoading.dart';
import 'package:periodico/Widgets/Widgets/search.dart';
import 'package:periodico/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}
class _ErrorScreenState extends State<ErrorScreen> with TickerProviderStateMixin{
  Map usuario={};
  void getUsuario() async{
    final prefs=await SharedPreferences.getInstance();
    String usuarioAlmacenado=await prefs.getString("user")!;
    usuario=jsonDecode(usuarioAlmacenado);
  }
  @override
  void initState() {
    // TODO: implement initState
    getUsuario();
    super.initState();
  }
@override
  Widget build(BuildContext context) {
    var route = MaterialPageRoute(builder: (context) => bannerLoading(user: usuario,));
    return Scaffold(
              backgroundColor: Color(0xFF5CCB5F),
              body: Center(
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error),
                        Text("Lo sentimos, ocurrio un error en la carga"),
                        CupertinoButton(
                          onPressed: (){
                            Navigator.pushReplacement(context, route);
                          },
                          child: Text("Volver a Intentar"))
                      ],
                    )
              ),
            );
  }
}
