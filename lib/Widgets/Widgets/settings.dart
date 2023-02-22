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
  bool _economia = false;
  bool _policiaco = false;
  Map<String, bool> _tags = {};
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

    /*
    setState(() {
      _economia = value;
      if (value) {
        OneSignal.shared.sendTags({"economia": "true"});
      } else {
        OneSignal.shared.deleteTags(["economia"]);
      }
    });*/
  }

  void _onPoliciacoChanged(bool value) {
    UserServices().saveSwitchState("policia", value);
    /*
    setState(() {
      _policiaco = value;
      if (value) {
        OneSignal.shared.sendTags({"policiaco": "true"});
      } else {
        OneSignal.shared.deleteTags(["policiaco"]);
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeHandler>(context);
    return Scaffold(
      appBar: const appBar(
        tittle: "AJUSTES",
      ),
      body: FutureBuilder(
        future: UserServices().getAllSwitchStates(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                                      fontSize: 20, color: Colors.grey[600])),
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
                                    value: theme.theme == ThemeData.dark(),
                                    onChanged: (value) {
                                      theme.toggleTheme();
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
                                      fontSize: 20, color: Colors.grey[600])),
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
