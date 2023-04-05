import 'package:flutter/material.dart';
import 'package:periodico/providers/ThemeHandler.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INICIAR SESIÓN'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
                Provider.of<ThemeHandler>(context, listen: false).theme ==
                        ThemeHandler().myThemeDark
                    ? "assets/logo_blanco.png"
                    : "assets/logo.png"),
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
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Send the username and password to your backend for authentication
                          bool isAuthenticated =
                              await Future.delayed(Duration(seconds: 2), () {
                            return _username == 'mauricio' &&
                                _password == '123';
                          });
                          
                          if (isAuthenticated) {
                            showDialog(
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
                            );
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
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
