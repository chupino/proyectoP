import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:periodico/main.dart';
import 'package:periodico/providers/ThemeHandler.dart';
import 'package:periodico/services/dataHandler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChooser extends StatefulWidget {
  const ThemeChooser({super.key});

  @override
  State<ThemeChooser> createState() => _ThemeChooserState();
}

class _ThemeChooserState extends State<ThemeChooser> {
  bool isDarkModeEnabled = false;
  void initTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkModeEnabled = prefs.getBool("darkMode") ?? false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tema"),
      ),
      body: Container(
        child: Column(children: [
          SizedBox(
            height: 25,
          ),
          Text(
            "Selecciona un Tema",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 25,
          ),
          FutureBuilder(
              future: UserServices().getAllSwitchStates(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            UserServices().saveSwitchState("darkMode", false);
                            Provider.of<ThemeHandler>(context, listen: false)
                                .updateTheme(ThemeHandler().myThemeLight);
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              child: snapshot.data!["darkMode"] == false
                                  ? Image.asset(
                                      "assets/light_mode_active.png",
                                    )
                                  : Image.asset("assets/light_mode.png"),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.light_mode_outlined,
                                      color: snapshot.data!["darkMode"] == false
                                          ? Color(0xFFdd3333)
                                          : Colors.white),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Modo Claro",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight:
                                            snapshot.data!["darkMode"] == false
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                  ),
                                ])
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            UserServices().saveSwitchState("darkMode", true);
                            Provider.of<ThemeHandler>(context, listen: false)
                                .updateTheme(ThemeHandler().myThemeDark);
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              child: snapshot.data!["darkMode"] == true
                                  ? Image.asset(
                                      "assets/dark_mode_active.png",
                                    )
                                  : Image.asset("assets/dark_mode.png"),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.light_mode_outlined,
                                      color: snapshot.data!["darkMode"] == true
                                          ? Color(0xFFdd3333)
                                          : Colors.black),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Modo Oscuro",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight:
                                            snapshot.data!["darkMode"] == true
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                  ),
                                ])
                          ],
                        ),
                      ),
                    ],
                    /*children: [
                      Expanded(
                        
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            UserServices().saveSwitchState("darkMode", false);
                            Provider.of<ThemeHandler>(context, listen: false)
                                .updateTheme(ThemeHandler().myThemeLight);
                          });
                        },
                        child: Column(
                          children: [
                            snapshot.data!["darkMode"] == false
                                ? Image.asset(
                                    "assets/light_mode_active.png",
                                    
                                  )
                                : Image.asset("assets/light_mode.png"),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.light_mode_outlined,
                                    color: snapshot.data!["darkMode"] == false
                                        ? Color(0xFFdd3333)
                                        : Colors.black),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Modo Claro",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight:
                                          snapshot.data!["darkMode"] == false
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            UserServices().saveSwitchState("darkMode", true);
                            Provider.of<ThemeHandler>(context, listen: false)
                                .updateTheme(ThemeHandler().myThemeDark);
                            ;
                          });
                        },
                        child: Column(children: [
                          snapshot.data!["darkMode"] == true
                              ? Image.asset(
                                  "assets/dark_mode_active.png",
                                )
                              : Image.asset("assets/dark_mode.png"),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Icon(Icons.dark_mode_outlined,
                                  color: snapshot.data!["darkMode"] == true
                                      ? Color(0xFFdd3333)
                                      : Colors.black),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Modo Oscuro",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight:
                                        snapshot.data!["darkMode"] == true
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                              ),
                            ],
                          )
                        ]),
                      )),
                    ],*/
                  );
                } else {
                  return CircularProgressIndicator();
                }
              })
        ]),
      ),
    );
  }
}
