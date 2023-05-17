import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/dataHandler.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _showPassword = false;
  final miControladorName = TextEditingController();
    final miControladorLastName = TextEditingController();
    final miControladorEmail = TextEditingController();
    final miControladorPass = TextEditingController();
    final miControladorPremium=TextEditingController();
  
  Future<Map> getUsuario() async{
    final prefs=await SharedPreferences.getInstance();
    String usuarioAlmacenado=prefs.getString("user")!;
    return jsonDecode(usuarioAlmacenado);
  }
  @override
  void initState() {
    // TODO: implement initState


    super.initState();
    UserServices().initKeys();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUsuario(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          miControladorName.text=snapshot.data!["nombre"];
    miControladorLastName.text=snapshot.data!["apellido"];
    miControladorEmail.text=snapshot.data!["correo"];
    miControladorPass.text=snapshot.data!["contraseña"];
    miControladorPremium.text=snapshot.data!["isPremium"].toString();
          
          return Scaffold(
      appBar: AppBar(
        title: Text("Cuenta"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edita tus datos",
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                
                controller: miControladorName,
                decoration: InputDecoration(
                  label: Text(
                    "Nombre",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: miControladorLastName,
                decoration: InputDecoration(
                  label: Text(
                    "Apellido",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: miControladorEmail,
                decoration: InputDecoration(
                  label: Text(
                    "Email",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: miControladorPass,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                    label: Text(
                      "Contraseña",
                      style: TextStyle(fontSize: 20),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                          print(_showPassword);
                        });
                      },
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: miControladorPremium,
                decoration: InputDecoration(
                    label: Text(
                      "Cuenta Premium",
                      style: TextStyle(fontSize: 20),
                    ),
                    ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Guardar"),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              )
            ]),
      ),
    );
        }else{
          return CircularProgressIndicator();
        }
      }
    );
    /* return Scaffold(
      appBar: AppBar(
        title: Text("Cuenta"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edita tus datos",
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                
                controller: miControladorName,
                decoration: InputDecoration(
                  label: Text(
                    "Nombre",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: miControladorLastName,
                decoration: InputDecoration(
                  label: Text(
                    "Apellido",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: miControladorEmail,
                decoration: InputDecoration(
                  label: Text(
                    "Email",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: miControladorPass,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                    label: Text(
                      "Contraseña",
                      style: TextStyle(fontSize: 20),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                          print(_showPassword);
                        });
                      },
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: miControladorPremium,
                decoration: InputDecoration(
                    label: Text(
                      "Cuenta Premium",
                      style: TextStyle(fontSize: 20),
                    ),
                    ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Guardar"),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              )
            ]),
      ),
    ); */
  }
}
