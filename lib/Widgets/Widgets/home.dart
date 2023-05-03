

import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:periodico/services/dataHandler.dart';
import 'package:periodico/services/pdfViewers.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../providers/ThemeHandler.dart';
import '../Fwidgets.dart';

class Home extends StatefulWidget {
  final List notas;
  final Uint8List imagenPDF;
  final String fecha;
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();

  const Home({super.key, 
    required this.notas,
    required this.imagenPDF,
    required this.fecha,
  });
}

class _HomePageState extends State<Home> with TickerProviderStateMixin{
  late TabController _tabController;
  late File documentPDF;
  
  final TextEditingController _textController = TextEditingController();
  final tags=UserServices().tags;
  bool imagenValida=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initPlatFormState());
    _tabController = TabController(length: 4, vsync: this);
    
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
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              pageNews(theme),
              pageHeadline(),
              lastNews(),
              corresponsalPage(),
            ],
          ),
          bottomNavigationBar:  const navBar(
            selectedIndex: 0,
            key: Key("0"),
          ),
        ));
  }
Container test(){
  return Container();
}
  Drawer drawerMenu(BuildContext context) {
    void _enviarPortal(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        
        Uri.parse(url),
        webViewConfiguration: WebViewConfiguration(enableJavaScript: true,enableDomStorage: true,headers: {"url":url}),
        mode: LaunchMode.externalApplication
        
        );
    } else {
      throw 'No se pudo abrir $url';
    }
  }
    return Drawer(
      // Aquí puedes agregar los elementos que quieras mostrar en el menú
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).drawerTheme.shadowColor,
            ),
            child: 
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
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                  height: 35,
                  child: Image.asset(
                    "assets/logo_blanco.png",
                    fit: BoxFit.contain,
                    height: 50, // ajusta la altura de la imagen
                  ),
                ),
                  ],
                ),
          ),
          
          for (var i = 0; i < tags.length; i++)
              ListTile(
                leading: Text(tags[i]["titulo"],style: const TextStyle(fontSize: 20),),
                trailing: IconButton(icon: const Icon(Icons.add),onPressed: (){_enviarPortal(tags[i]["goTo"]);}),
              )
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
          
        ],
      ),
      bottom: TabBar(
        isScrollable: true,
        indicatorColor: Theme.of(context).primaryColorDark,
        onTap: (value) => setState(() {
        }),
        controller: _tabController,
        tabs: const [
          Tab(text: 'NOTICIAS'),
          Tab(text: 'EDICIÓN DE HOY'),
          Tab(text: 'LO ÚLTIMO'),
          Tab(text: 'SE NUESTRO CORRESPONSAL'),
        ],
      ),
    );
  }

  Container pageHeadline() {
    return Container(
      child: Center(
        child: pdfViewers().pdfViewerBytes()
      ),
    );
  }

  void _enviarMensajeWhatsApp() async {
    const String telefono = '51961811703'; // Número de teléfono de destino
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
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Center(
          child: Column(
            children: [
              const Text(
                "Sé un Corresponsal",
                style: TextStyle(
                  fontSize: 35,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Comparte información valiosa con otros miembros de la comunidad para hacerla más segura.",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
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
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  maxLines: null,
                ),
              )),
              const SizedBox(
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
                          const SnackBar(
                            content: Text('Escribe algo'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: materialColorBoton,
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                    ),
                    child: const Text(
                      "Enviar",
                      style: TextStyle(fontSize: 20),
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

  FutureBuilder lastNews() {
    return FutureBuilder(
        future: UserServices().getNoticias(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  return Container(
                    child: Column(children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        child: const Divider(
                          thickness: 1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/details",
                            arguments: {
                              "index": index,
                            },
                          );
                        },
                        child: Container(
                            padding:
                                const EdgeInsets.symmetric(vertical: 5),
                            width: MediaQuery.of(context).size.width - 20,
                            child: ListTile(
                                title: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.7,
                                  child: Text(
                                    snapshot.data![index+1]["title"],
                                    style: const TextStyle(
                                        fontFamily: "Georgia",
                                        fontSize: 20),
                                  ),
                                ),
                                leading: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.3,
                                  child: snapshot.data![index+1]["image"] !=
                                          null
                                      ? Image.network(
                                          snapshot.data![index+1]["image"],
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
                                  child: snapshot.data![index+1]["autor"] !=
                                          null
                                      ? Text(snapshot.data![index+1]["autor"])
                                      : const Text(""),
                                ))),
                      ),
                    ]),
                  );
                }));
          } else {
            return Center(
              child: CircularProgressIndicator(color: Theme.of(context).hoverColor,),
            );
          }
        });
  }
Widget pageNews(ThemeHandler theme) {

    return SingleChildScrollView(
      child: Column(
        children: [
          miniatura(context),
          notas()
        ],
      
      
    ),
    );

}


Widget notas() {
  final List articulos=widget.notas;
  if(articulos.isNotEmpty){
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: articulos.length,
      itemBuilder: (context, index) {
        return Column(children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: const Divider(
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
                  "url": articulos[index]["url"]
                },
              );
            },
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5),
                width: MediaQuery.of(context).size.width - 20,
                child: ListTile(
                    title: SizedBox(
                      width:
                          MediaQuery.of(context).size.width *
                              0.7,
                      child: Text(
                        articulos[index]["title"]??Container(),
                        style: const TextStyle(
                            fontFamily: "Georgia",
                            fontSize: 20),
                      ),
                    ),
                    leading: SizedBox(
                      width:
                          MediaQuery.of(context).size.width *
                              0.3,
                      child: articulos[index]
                                  ["image"] !=
                              null && articulos[index]["image"] is String
                          ? CachedNetworkImage(
                            imageUrl: articulos[index]["image"],
                            fit: BoxFit.cover,
                            placeholder: (context,url)=>Container(color:Colors.black12),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.black12,
                              child: const Icon(Icons.error,color: Colors.red,),
                            ),
                            )
                          : const Icon(
                              Icons.image,
                              size: 50,
                            ),
                    ),
                    subtitle: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2),
                      child: articulos[index]
                                  ["autor"] !=
                              null
                          ? Text(articulos[index]
                              ["autor"])
                          : const Text(""),
                    ))),
          ),
        ]);
      },
    );
  }else{
    return const Text("No hay información");
  }
}
Widget articles() {
return FutureBuilder(
              future: UserServices().getNoticias(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snapshot.data!.length,
                    itemBuilder: ((context, index) {
                      return Column(children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 20,
                          child: const Divider(
                            thickness: 1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
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
                                  title: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                            0.7,
                                    child: Text(
                                      snapshot.data![index]["title"]??Container(),
                                      style: const TextStyle(
                                          fontFamily: "Georgia",
                                          fontSize: 20),
                                    ),
                                  ),
                                  leading: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                            0.3,
                                    child: snapshot.data![index]
                                                ["image"] !=
                                            null && snapshot.data![index]["image"] is String
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
                                        : const Text(""),
                                  ))),
                        ),
                      ]);
                    }),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator(color: Colors.blue,));
                }
              }),
            );
          
  }

  Widget miniatura(BuildContext context){
    final Uint8List imagen=widget.imagenPDF;

    if(imagen.isNotEmpty){
          return GestureDetector(
                            onTap: (() {
                              setState(() {
                                _tabController.animateTo(1);
                              });
                            }),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10),
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
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: 
                                  Image.memory(imagen)
                                ,
                              ),
                            ),
                          );
        
        
        
      

    }else{
      return const Text("No se pudo cargar el pdf");
    }
  }
  FutureBuilder thumbnail(BuildContext context) {
    return FutureBuilder(
      future: UserServices().getThumbnail(),
      builder: (context,snapshot){
        if(snapshot.hasData){
            return GestureDetector(
                            onTap: (() {
                              DefaultTabController.of(context).index = 1;
                              setState(() {
          
                              });
                            }),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10),
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
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: 
                                  Image.memory(snapshot.data!,fit: BoxFit.cover,)
                                ,
                              ),
                            ),
                          );
          
        }else{
          return const SizedBox(
            height: 300,
            width: 300,
            child: Center(
              child: CircularProgressIndicator(),
            ),
            );
        }
        
      },
      
    );
  }

  Future<void> initPlatFormState() async {
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      try {
        Map valoresNotifiacion = result.notification.additionalData!;
        String postId = valoresNotifiacion["post_id"].toString();
        Navigator.pushNamed(context, "/notification",
            arguments: {"postId": postId});
        print("++++++++++++${result.notification.additionalData}");
      } catch (e) {
        print("Error en la notificación: $e");
      }
    });
  }
}
