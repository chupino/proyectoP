import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:periodico/Widgets/Fwidgets.dart';
import 'package:periodico/services/dataHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  bool _economia = false;
  bool _salud = false;
  bool _politica = false;
  bool _policia = false;
  bool _tecnologia = false;
  bool _deporte = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initKeys();
  }

  void initKeys() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("economia") == null) {
      prefs.setBool("economia", false);
    }
    if (prefs.getBool("darkMode") == null) {
      prefs.setBool("darkMode", false);
    }
    if (prefs.getBool("policia") == null) {
      prefs.setBool("policia", false);
    }
    if (prefs.getBool("politica") == null) {
      prefs.setBool("politica", false);
    }
    if (prefs.getBool("salud") == null) {
      prefs.setBool("salud", false);
    }
    if (prefs.getBool("tecnologia") == null) {
      prefs.setBool("tecnologia", false);
    }
    if (prefs.getBool("deporte") == null) {
      prefs.setBool("deporte", false);
    }
    _deporte = await prefs.getBool("deporte")!;
    _economia = await prefs.getBool("economia")!;
    _policia = await prefs.getBool("policia")!;
    _politica = await prefs.getBool("politica")!;
    _salud = await prefs.getBool("salud")!;
    _tecnologia = await prefs.getBool("tecnologia")!;
    print(prefs.getBool("deporte"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favoritos")),
      body: Container(
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Selecciona tus secciones favoritas!",
            style: TextStyle(fontSize: 35),
          ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("++++++++ ${snapshot.data!["economia"]}");
                return Container(
                  child: Column(children: [
                    CustomSwitch(
                        tag: "economia",
                        valueKey: snapshot.data!["economia"],
                        label: Text("Economia"),
                        onIcon: Icons.notifications_active,
                        offIcon: Icons.notifications_off,
                        initialValue: snapshot.data!["economia"],
                        onChanged: (value) {}),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 25,
                      child: Divider(
                        thickness:
                            1, //opcional, para especificar el grosor de la línea
                      ),
                    ),
                    CustomSwitch(
                        tag: "deporte",
                        valueKey: snapshot.data!["deporte"],
                        label: Text("Deporte"),
                        onIcon: Icons.notifications_active,
                        offIcon: Icons.notifications_off,
                        initialValue: snapshot.data!["deporte"],
                        onChanged: (value) {}),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 25,
                      child: Divider(
                        thickness:
                            1, //opcional, para especificar el grosor de la línea
                      ),
                    ),
                    CustomSwitch(
                        tag: "salud",
                        valueKey: snapshot.data!["salud"],
                        label: Text("Salud"),
                        onIcon: Icons.notifications_active,
                        offIcon: Icons.notifications_off,
                        initialValue: snapshot.data!["salud"],
                        onChanged: (value) {}),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 25,
                      child: Divider(
                        thickness:
                            1, //opcional, para especificar el grosor de la línea
                      ),
                    ),
                    CustomSwitch(
                        tag: "politica",
                        valueKey: snapshot.data!["politica"],
                        label: Text("Politica"),
                        onIcon: Icons.notifications_active,
                        offIcon: Icons.notifications_off,
                        initialValue: snapshot.data!["politica"],
                        onChanged: (value) {}),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 25,
                      child: Divider(
                        thickness:
                            1, //opcional, para especificar el grosor de la línea
                      ),
                    ),
                    CustomSwitch(
                        tag: "policia",
                        valueKey: snapshot.data!["policia"],
                        label: Text("Policia"),
                        onIcon: Icons.notifications_active,
                        offIcon: Icons.notifications_off,
                        initialValue: snapshot.data!["policia"],
                        onChanged: (value) {}),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 25,
                      child: Divider(
                        thickness:
                            1, //opcional, para especificar el grosor de la línea
                      ),
                    ),
                    CustomSwitch(
                        tag: "tecnologia",
                        valueKey: snapshot.data!["tecnologia"],
                        label: Text("Tecnologia"),
                        onIcon: Icons.notifications_active,
                        offIcon: Icons.notifications_off,
                        initialValue: snapshot.data!["tecnologia"],
                        onChanged: (value) {}),
                  ]),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
            future: UserServices().getAllSwitchStates(),
          )
        ]),
      ),
    );
  }
}
