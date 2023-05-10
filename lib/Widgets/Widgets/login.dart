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
    Color colorBoton=Theme.of(context).hoverColor;
    MaterialStateProperty<Color> materialColorBoton=MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if(states.contains(MaterialState.hovered)){
        return colorBoton.withOpacity(0.4);
      }
      if(states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)){
        return colorBoton.withOpacity(0.8);
      }
      return colorBoton;
    });
    MaterialStateProperty<TextStyle> materialColorTexto = MaterialStateProperty.resolveWith<TextStyle>(
  (Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return TextStyle(color: Colors.grey); // En caso de que el widget esté deshabilitado, se usará el color gris en vez de rojo
    }
    return TextStyle(color: Colors.black);
  },
);

    return Scaffold(
      appBar: AppBar(
        title: Text('INICIAR SESIÓN'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.greenAccent
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(alignment: Alignment.center, backgroundColor: materialColorBoton,textStyle: materialColorTexto),

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
                            child: Text('Iniciar Sesión'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40,),

            
            ],
          ),
        ),
      ),
    );
  }
}
