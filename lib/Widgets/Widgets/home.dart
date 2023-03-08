import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:periodico/Widgets/Widgets/test.dart';
import 'package:periodico/services/dataHandler.dart';
import 'package:provider/provider.dart';

import '../../providers/ThemeHandler.dart';
import '../Fwidgets.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  int _selectedIndex = 0;
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
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("INICIO"),
              ],
            ),
            bottom: TabBar(
              onTap: (value) => setState(() {
                _selectedIndex = value;
              }),
              tabs: const [
                Tab(text: 'NOTICIAS'),
                Tab(text: 'EDICIÓN IMPRESA'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              pageNews(theme),
              pageHeadline(),
            ],
          ),
          bottomNavigationBar: const navBar(
            selectedIndex: 0,
            key: Key("0"),
          ),
        ));
  }

  Container pageHeadline() {
    return Container(
      child: const Center(
        child: Text('Contenido para "EDICIÓN IMPRESA"'),
      ),
    );
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
                                color: theme.theme == ThemeData.dark()
                                    ? Colors.grey[800]
                                    : Colors.grey[300],
                                border: Border(
                                  top: BorderSide(
                                      width: 1.0,
                                      color: theme.theme == ThemeData.dark()
                                          ? Colors.grey
                                          : Colors.black),
                                  bottom: BorderSide(
                                      width: 1.0,
                                      color: theme.theme == ThemeData.dark()
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 100,
                                  ),
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
                          //color: Color.fromARGB(150, 12, 154, 96),
                          //height: 200,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                print(index - 1);
                                Navigator.pushNamed(
                                  context,
                                  "/details",
                                  arguments: {
                                    "index": index - 1,
                                    "url": snapshot.data![index]["url"]
                                  },
                                );
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.theme == ThemeData.dark()
                                        ? Colors.grey[800]
                                        : Colors.grey[300],
                                    border: Border(
                                      top: BorderSide(
                                          width: 1.0,
                                          color: theme.theme == ThemeData.dark()
                                              ? Colors.grey
                                              : Colors.black),
                                      bottom: BorderSide(
                                          width: 1.0,
                                          color: theme.theme == ThemeData.dark()
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  width: MediaQuery.of(context).size.width - 20,
                                  child: ListTile(
                                      title: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          snapshot.data![index - 1]["title"],
                                          style: TextStyle(
                                              fontFamily: "Georgia",
                                              fontSize: 20),
                                        ),
                                      ),
                                      leading: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: snapshot.data![index - 1]
                                                    ["image"] !=
                                                null
                                            ? Image.network(
                                                snapshot.data![index - 1]
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
                                        child: snapshot.data![index - 1]
                                                    ["autor"] !=
                                                null
                                            ? Text(snapshot.data![index - 1]
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
