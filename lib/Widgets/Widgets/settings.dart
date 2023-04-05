import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:periodico/services/dataHandler.dart';
import 'package:provider/provider.dart';
import '../../providers/ThemeHandler.dart';
import '../Fwidgets.dart';

class Ajustes extends StatefulWidget {
  const Ajustes({super.key});

  @override
  State<Ajustes> createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*
    OneSignal.shared.getTags().then((tags) {
      // Actualizar el estado del widget con los tags del usuario
      setState(() {
        _tags = tags.map((key, value) => MapEntry(key, value == "true"));
      });
    });*/
    UserServices().initKeys();
  }

  void _onThemeChange(String tag, bool value) {
    setState(() {
      UserServices().saveSwitchState(tag, value);
      Provider.of<ThemeHandler>(context, listen: false).toggleTheme();
    });
  }

  void _onSwitchChange(String tag, bool value) {
    setState(() {
      UserServices().saveSwitchState(tag, value);
    });
    if (value) {
      OneSignal.shared.sendTags({tag: "true"}).catchError((e) {
        print("error al añadir user tag ${e}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No tienes conexion'),
          ),
        );
        setState(() {
          UserServices().saveSwitchState(tag, false);
        });
      });
    } else {
      OneSignal.shared.deleteTags([tag]).catchError((e) {
        print("error al quitar user tag $e");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No tienes conexion'),
          ),
        );
        setState(() {
          UserServices().saveSwitchState(tag, true);
        });
      });
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeHandler>(context);
    final isLogged = false;
    return Scaffold(
      appBar: const appBar(
        tittle: "AJUSTES",
      ),
      body: FutureBuilder(
        future: UserServices().getAllSwitchStates(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text("Mi Cuenta"),
                  subtitle: Text("Cambiar datos personales"),
                  leading: Icon(
                    Icons.account_circle_outlined,
                    size: 30,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  trailing: Icon(Icons.arrow_right_rounded,
                      size: 30, color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    Navigator.pushNamed(context, "/account");
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 25,
                  child: Divider(
                    thickness:
                        1, //opcional, para especificar el grosor de la línea
                  ),
                ),
                ListTile(
                  title: Text("Contenido Favorito"),
                  subtitle: Text("Escoga sus noticias"),
                  leading: Icon(Icons.favorite_outline_rounded,
                      size: 30, color: Theme.of(context).iconTheme.color),
                  trailing: Icon(
                    Icons.arrow_right_rounded,
                    size: 30,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/favourites");
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 25,
                  child: Divider(
                    thickness:
                        1, //opcional, para especificar el grosor de la línea
                  ),
                ),
                ListTile(
                  title: Text("Apariencia"),
                  subtitle: Text("Seleccione el tema"),
                  leading: Icon(Icons.mode_night_outlined,
                      size: 30, color: Theme.of(context).iconTheme.color),
                  trailing: Icon(Icons.arrow_right_rounded,
                      size: 30, color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    Navigator.pushNamed(context, "/themeChooser");
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                isLogged != false
                    ? Container()
                    : Center(
                        child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "No haz iniciado sesión? ",
                            style: TextStyle(fontSize: 15),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/login");
                              },
                              child: Text(
                                "Hazlo ahora!",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).iconTheme.color,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2),
                              ))
                        ],
                      )),
              ],
            );

            return ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 15),
                itemCount: 2, // número de secciones
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                            child: Text(
                              "Apariencia",
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      color: theme.theme == ThemeData.dark()
                                          ? Colors.grey[300]
                                          : Colors.grey[600])),
                            ),
                            alignment: Alignment.centerLeft),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              border: Border.symmetric(
                                  horizontal: BorderSide(color: Colors.grey))),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("Modo Oscuro"),
                                trailing: Switch(
                                    value: snapshot.data!["darkMode"],
                                    onChanged: (value) {
                                      _onThemeChange("darkMode", value);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (index == 1) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Align(
                            child: Text(
                              "Preferencias",
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      color: theme.theme == ThemeData.dark()
                                          ? Colors.grey[300]
                                          : Colors.grey[600])),
                            ),
                            alignment: Alignment.centerLeft),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              border: Border.symmetric(
                                  horizontal: BorderSide(color: Colors.grey))),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("Politica"),
                                trailing: Switch(
                                    value: snapshot.data!["politica"],
                                    onChanged: (value) {
                                      //theme.toggleTheme();
                                      _onSwitchChange("politica", value);
                                    }),
                              ),
                              ListTile(
                                title: Text("Economia"),
                                trailing: Switch(
                                    value: snapshot.data!["economia"],
                                    onChanged: (value) {
                                      //theme.toggleTheme();
                                      _onSwitchChange("economia", value);
                                    }),
                              ),
                              ListTile(
                                title: Text("Salud"),
                                trailing: Switch(
                                    value: snapshot.data!["salud"],
                                    onChanged: (value) {
                                      //theme.toggleTheme();
                                      _onSwitchChange("salud", value);
                                    }),
                              ),
                              ListTile(
                                title: Text("Tecnologia"),
                                trailing: Switch(
                                    value: snapshot.data!["tecnologia"],
                                    onChanged: (value) {
                                      //theme.toggleTheme();
                                      _onSwitchChange("tecnologia", value);
                                    }),
                              ),
                              ListTile(
                                title: Text("Deporte"),
                                trailing: Switch(
                                    value: snapshot.data!["deporte"],
                                    onChanged: (value) {
                                      //theme.toggleTheme();
                                      _onSwitchChange("deporte", value);
                                    }),
                              ),
                              ListTile(
                                title: Text("Policia"),
                                trailing: Switch(
                                    value: snapshot.data!["policia"],
                                    onChanged: (value) {
                                      //theme.toggleTheme();
                                      _onSwitchChange("policia", value);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                });
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      bottomNavigationBar: const navBar(
        selectedIndex: 3,
        key: Key("3"),
      ),
    );
  }
}
