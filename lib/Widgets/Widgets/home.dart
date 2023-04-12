

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:periodico/services/dataHandler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:http/http.dart' as http;


import '../../providers/ThemeHandler.dart';
import '../Fwidgets.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  int _selectedIndex = 0;
  late final imageBytesThumbnail;
  final TextEditingController _textController = TextEditingController();
  
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initPlatFormState());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeHandler>(context);
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: appBarLogo(context),
          drawer: drawerMenu(context),
          body: TabBarView(
            children: [
              pageNews(theme),
              pageHeadline(),
              lastNews(),
              corresponsalPage(),
            ],
          ),
          bottomNavigationBar: const navBar(
            selectedIndex: 0,
            key: Key("0"),
          ),
        ));
  }

  Drawer drawerMenu(BuildContext context) {
    return Drawer(
      // Aquí puedes agregar los elementos que quieras mostrar en el menú
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: 35,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "TEMAS",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    )
                  ],
                ),
                Container(
                  height: 60,
                  child: Image.asset(
                    "assets/logo_blanco.png",
                    fit: BoxFit.contain,
                    height: 30, // ajusta la altura de la imagen
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).drawerTheme.shadowColor,
            ),
          ),
          ListTile(
            title: Text('Deportes'),
            onTap: () {
              Navigator.pushNamed(context, "/genreSelected",
                  arguments: {"genre": "Deportes", "title": "Deportes"});
            },
            trailing: Icon(
              Icons.add,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          ListTile(
            title: Text('Economia'),
            onTap: () {
              Navigator.pushNamed(context, "/genreSelected",
                  arguments: {"genre": "Economia", "title": "Economia"});
            },
            trailing: Icon(
              Icons.add,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          ListTile(
            title: Text('Salud'),
            onTap: () {
              Navigator.pushNamed(context, "/genreSelected",
                  arguments: {"genre": "Salud", "title": "Salud"});
            },
            trailing: Icon(
              Icons.add,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          ListTile(
            title: Text('Tecnologia'),
            onTap: () {
              Navigator.pushNamed(context, "/genreSelected",
                  arguments: {"genre": "Tecnologia", "title": "Tecnologia"});
            },
            trailing: Icon(
              Icons.add,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          ListTile(
            title: Text('Policia'),
            onTap: () {
              Navigator.pushNamed(context, "/genreSelected",
                  arguments: {"genre": "Policia", "title": "Policia"});
            },
            trailing: Icon(
              Icons.add,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          ListTile(
            title: Text('Politica'),
            onTap: () {
              Navigator.pushNamed(context, "/genreSelected",
                  arguments: {"genre": "Politica", "title": "Politica"});
            },
            trailing: Icon(
              Icons.add,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBarLogo(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
          size: 40.0, color: Theme.of(context).colorScheme.onPrimary),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Image.asset(
              "assets/logo_blanco.png",
              fit: BoxFit.contain,
              height: 50, // ajusta la altura de la imagen
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: 15), // Ajusta el padding superior del texto
            child: Text(
              "INICIO",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
      bottom: TabBar(
        isScrollable: true,
        indicatorColor: Theme.of(context).primaryColorDark,
        onTap: (value) => setState(() {
          _selectedIndex = value;
        }),
        tabs: const [
          Tab(text: 'NOTICIAS'),
          Tab(text: 'EDICIÓN IMPRESA'),
          Tab(text: 'LO ÚLTIMO'),
          Tab(text: 'SE NUESTRO CORRESPONSAL'),
        ],
      ),
    );
  }

  Container pageHeadline() {
    return Container(
      child: const Center(
        child: Text('Contenido para "EDICIÓN IMPRESA"'),
      ),
    );
  }

  void _enviarMensajeWhatsApp() async {
    final String telefono = '51961811703'; // Número de teléfono de destino
    final String mensaje = _textController.text; // Mensaje a enviar

    // El enlace de WhatsApp debe comenzar con "whatsapp://send?phone="
    final String url =
        'whatsapp://send?phone=$telefono&text=${Uri.encodeFull(mensaje)}';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'No se pudo lanzar $url';
    }
  }

  SingleChildScrollView corresponsalPage() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Center(
          child: Column(
            children: [
              Text(
                "Sé un Corresponsal",
                style: TextStyle(
                  fontSize: 35,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Comparte información valiosa con otros miembros de la comunidad para hacerla más segura.",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 25,
              ),
              SingleChildScrollView(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Theme.of(context).iconTheme.color ?? Colors.black,
                      width: 2),
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                width: MediaQuery.of(context).size.width - 80,
                height: MediaQuery.of(context).size.height * 0.3,
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  maxLines: null,
                ),
              )),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_textController.text.trim().isNotEmpty) {
                        _enviarMensajeWhatsApp();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Escribe algo'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Enviar",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                    ),
                  ),
                  Flexible(
                      child: Image.asset(
                    "assets/sello.png",
                    fit: BoxFit.cover,
                    height: 80,
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container lastNews() {
    return Container(
        child: FutureBuilder(
            future: UserServices().getTitles(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        child: Column(children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print(index);
                              Navigator.pushNamed(
                                context,
                                "/details",
                                arguments: {
                                  "index": index,
                                  "url": snapshot.data![index]["url"]
                                },
                              );
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                width: MediaQuery.of(context).size.width - 20,
                                child: ListTile(
                                    title: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        snapshot.data![index]["title"],
                                        style: TextStyle(
                                            fontFamily: "Georgia",
                                            fontSize: 20),
                                      ),
                                    ),
                                    leading: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: snapshot.data![index]["image"] !=
                                              null
                                          ? Image.network(
                                              snapshot.data![index]["image"],
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(
                                              Icons.image,
                                              size: 50,
                                            ),
                                    ),
                                    subtitle: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: snapshot.data![index]["autor"] !=
                                              null
                                          ? Text(snapshot.data![index]["autor"])
                                          : Text(""),
                                    ))),
                          ),
                        ]),
                      );
                    }));
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
  Container pageNews(ThemeHandler theme) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: UserServices().getTitles(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: ((context, index) {
                        if (index == 0) {
                          return GestureDetector(
                            onTap: (() {
                              DefaultTabController.of(context).index = 1;
                              setState(() {
                                _selectedIndex = 1;
                              });
                            }),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 100),
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                border: Border(
                                  top: BorderSide(
                                    width: 1.0,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  //Image.memory(snapshot.data![0]["bytes"]),
                                  Text(
                                    "TITULAR",
                                    style: TextStyle(fontSize: 40),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        return Container(
                          child: Column(children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 20,
                              child: Divider(
                                thickness: 1,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print(index);
                                Navigator.pushNamed(
                                  context,
                                  "/details",
                                  arguments: {
                                    "index": index,
                                    "url": snapshot.data![index]["url"]
                                  },
                                );
                              },
                              child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  width: MediaQuery.of(context).size.width - 20,
                                  child: ListTile(
                                      title: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          snapshot.data![index]["title"],
                                          style: TextStyle(
                                              fontFamily: "Georgia",
                                              fontSize: 20),
                                        ),
                                      ),
                                      leading: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: snapshot.data![index]
                                                    ["image"] !=
                                                null
                                            ? Image.network(
                                                snapshot.data![index]
                                                    ["image"],
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(
                                                Icons.image,
                                                size: 50,
                                              ),
                                      ),
                                      subtitle: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: snapshot.data![index]
                                                    ["autor"] !=
                                                null
                                            ? Text(snapshot.data![index]
                                                ["autor"])
                                            : Text(""),
                                      ))),
                            ),
                          ]),
                        );
                      }),
                    );
                  } else {
                    return Center(child: const CircularProgressIndicator());
                  }
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> initPlatFormState() async {
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      try {
        Map valoresNotifiacion = result.notification.additionalData!;
        String postId = valoresNotifiacion["post_id"].toString();
        Navigator.pushNamed(context, "/notification",
            arguments: {"postId": "$postId"});
        print("++++++++++++${result.notification.additionalData}");
      } catch (e) {
        print("Error en la notificación: $e");
      }
    });
  }
}
