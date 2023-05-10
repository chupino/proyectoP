import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:periodico/Widgets/Widgets/bannerLoading.dart';
import 'package:periodico/Widgets/Widgets/search.dart';
import 'package:periodico/main.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}
class _ErrorScreenState extends State<ErrorScreen> with TickerProviderStateMixin{
@override
  Widget build(BuildContext context) {
    var route = MaterialPageRoute(builder: (context) => bannerLoading());
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
