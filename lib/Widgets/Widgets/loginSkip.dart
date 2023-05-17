import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:periodico/Widgets/Widgets/bannerLoading.dart';
import 'package:periodico/main.dart';
import 'package:periodico/providers/ThemeHandler.dart';
import 'package:periodico/services/dataHandler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSkipPage extends StatefulWidget {
  @override
  _LoginSkipPageState createState() => _LoginSkipPageState();
}

class _LoginSkipPageState extends State<LoginSkipPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    Map user = {
      "nombre": "sin nombre",
      "apellido": "sin apellido",
      "correo": "nosuscripto@gmail.com",
      "contraseña": "nopass",
      "isPremium": false
    };
    Color colorBoton = Theme.of(context).hoverColor;
    MaterialStateProperty<Color> materialColorBoton =
        MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered)) {
        return colorBoton.withOpacity(0.4);
      }
      if (states.contains(MaterialState.focused) ||
          states.contains(MaterialState.pressed)) {
        return colorBoton.withOpacity(0.8);
      }
      return colorBoton;
    });
    MaterialStateProperty<TextStyle> materialColorTexto =
        MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return TextStyle(
            color: Colors.grey,
          ); // En caso de que el widget esté deshabilitado, se usará el color gris en vez de rojo
        }
        return TextStyle(color: Colors.black);
      },
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(
                "assets/logo.png",
                height: 66,
                fit: BoxFit.cover, // ajusta la altura de la imagen
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.greenAccent),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/selloGuapo.png",
                height: 200,
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Introuce un nombre de usuario';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value!.trim();
                        },
                        decoration: InputDecoration(
                          labelText: 'Nombre de Usuario',
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Introduce una contraseña';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!.trim();
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                alignment: Alignment.center,
                                backgroundColor: materialColorBoton,
                                textStyle: materialColorTexto),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                // Send the username and password to your backend for authentication
                                bool isAuthenticated = false;
                                UserServices().users.forEach((usuario) {
                                  if (usuario["correo"] == _username &&
                                      usuario["contraseña"] == _password) {
                                    isAuthenticated = true;
                                    user = usuario;
                                  }
                                });

                                if (isAuthenticated) {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString("user", jsonEncode(user));
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => bannerLoading(
                                                user: user,
                                              )));
                                  /* showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Credenciales válidas',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Aceptar'),
                                          ),
                                        ],
                                      );
                                    },
                                  ); */
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Credenciales incorrectas',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Aceptar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Iniciar Sesión',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool("login", true);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => bannerLoading(
                                      user: user,
                                    )));
                      },
                      child: Text(
                        "Ahora no",
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).iconTheme.color,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2),
                      )),
                  TextButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool("login", false);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => bannerLoading(
                                      user: user,
                                    )));
                      },
                      child: Text(
                        "No volver a mostrar esto",
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).iconTheme.color,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
