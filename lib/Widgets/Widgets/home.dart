

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:periodico/Widgets/Widgets/pdfViewer.dart';
import 'package:periodico/services/dataHandler.dart';
import 'package:periodico/services/pdfViewers.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf_render/pdf_render.dart' as pr;
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as cy;


import '../../providers/ThemeHandler.dart';
import '../Fwidgets.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  int _selectedIndex = 0;
  late File documentPDF;
  final TextEditingController _textController = TextEditingController();
    final List<Map> tags = [
  {
    "titulo": "Cultura",
    "imagenURL": "https://portal.andina.pe/EDPfotografia3/Thumbnail/2017/01/25/000400475W.jpg",
    "goTo":"https://diarioelpueblo.com.pe/index.php/category/cultura/"
  },
  {
    "titulo": "Deporte",
    "imagenURL": "https://www.unsa.edu.pe/wp-content/uploads/2020/02/FOTO-FINAL-878x426.png",
    "goTo":"https://diarioelpueblo.com.pe/index.php/category/deporte/"
  },
  {
    "titulo": "Distritos",
    "imagenURL": "https://cdn.forbes.pe/2022/05/Arequipa-Agencia-Andina.jpg",
    "goTo":"https://diarioelpueblo.com.pe/index.php/category/distritos/"
  },
  {
    "titulo": "Economía",
    "imagenURL": "https://www.comexperu.org.pe/upload/images/sem-1129_economia-210722-075720.jpg",
    "goTo":"https://diarioelpueblo.com.pe/index.php/category/economia/"
  },
  {
    "titulo": "Editorial",
    "imagenURL": "https://tiojuan.files.wordpress.com/2020/10/canilla-arequipeno.jpg?w=287",
    "goTo":"https://diarioelpueblo.com.pe/index.php/category/editorial/"
  },
  {
    "titulo": "Educación",
    "imagenURL": "https://larepublica.cronosmedia.glr.pe/original/2019/10/12/62b918ffafced5708606eb96.jpg",
    "goTo":"https://diarioelpueblo.com.pe/index.php/category/educacion/"
  },
  {
    "titulo": "Entrevistas",
    "imagenURL": "https://soyliterauta.com/wp-content/uploads/2020/10/Entrevista-Periodistica.jpg",
    "goTo":"https://diarioelpueblo.com.pe/index.php/category/entrevistas/"
  },
  {
    "titulo": "Especiales",
    "imagenURL": "https://www.alwahotel.com/wp-content/uploads/2016/09/diablo-en-la-catedral-AQP-Diario-El-Pueblo.jpg",
    "goTo":"https://diarioelpueblo.com.pe/index.php/category/especiales/"
  },
  {
    "titulo": "Internacional",
    "imagenURL": "https://imagenes.expreso.ec/files/image_700_402/files/fp/uploads/2023/04/11/6435dd3ddd131.r_d.2283-3845-1563.jpeg",
    "goTo":"https://diarioelpueblo.com.pe/index.php/category/noticias/internacional/"
  },
  {
    "titulo": "Nacional",
    "imagenURL": "https://diarioelpueblo.com.pe/wp-content/uploads/2023/01/regiones_peru.jpg",
    "goTo":"https://diarioelpueblo.com.pe/index.php/category/noticias/nacional/"
  },
  {
    "titulo": "Local",
    "imagenURL": "https://1.bp.blogspot.com/-6wIuXpdp2TA/W4LYY1YtCLI/AAAAAAAATHg/STLxQ27ixoYYbSjv5dzAR8VVDVYIKSBvwCLcBGAs/s1600/IMG_0598.jpg",
    "goTo":"https://diarioelpueblo.com.pe/index.php/category/noticias/local/",
  },
  {
      "titulo": "Regional",
      "imagenURL": "https://media.tacdn.com/media/attractions-splice-spp-674x446/07/37/cc/cd.jpg",
      "goTo":"https://diarioelpueblo.com.pe/index.php/category/noticias/regional/"
    },
    {
      "titulo": "Opinión",
      "imagenURL": "https://definicion.de/wp-content/uploads/2009/11/opinion-1.jpg",
      "goTo":"https://diarioelpueblo.com.pe/index.php/category/opinion/"
    },
    {
      "titulo": "Foto Hoy",
      "imagenURL": "https://i0.wp.com/imgs.hipertextual.com/wp-content/uploads/2016/12/lente-fotografo.jpg",
      "goTo":"https://diarioelpueblo.com.pe/index.php/category/opinion/foto-hoy/"
    },
    {
      "titulo": "Policiales",
      "imagenURL": "https://siip3.institutopacifico.pe/assets/uploads/noticias/9FB0A40BE81390584FECE6DD1877D406_1665067495_original.png",
      "goTo":"https://diarioelpueblo.com.pe/index.php/category/policiales/"
    },
    {
      "titulo": "Política",
      "imagenURL": "https://live.staticflickr.com/7243/6884581202_2748cdbde7_b.jpg",
      "goTo":"https://diarioelpueblo.com.pe/index.php/category/politica/"
    },
    {
      "titulo": "Salud",
      "imagenURL": "https://www.esan.edu.pe/images/blog/2021/11/16/x1500x844-salud-peru-16-11.jpg.pagespeed.ic.2ctF5ObSmS.jpg",
      "goTo":"https://diarioelpueblo.com.pe/index.php/category/salud/"
    },
    {
      "titulo": "Turismo",
      "imagenURL": "https://denomades.s3.us-west-2.amazonaws.com/blog/wp-content/uploads/2016/07/04134751/can%CC%83oncolca.jpg",
      "goTo":"https://diarioelpueblo.com.pe/index.php/category/turismo/"
    },
  ];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initPlatFormState());
    UserServices().getTest();
    
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
            physics: NeverScrollableScrollPhysics(),
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
Container test(){
  return Container();
}
  Drawer drawerMenu(BuildContext context) {
    void _enviarPortal(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
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
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                  height: 35,
                  child: Image.asset(
                    "assets/logo_blanco.png",
                    fit: BoxFit.contain,
                    height: 50, // ajusta la altura de la imagen
                  ),
                ),
                  ],
                ),
                
                
              
            decoration: BoxDecoration(
              color: Theme.of(context).drawerTheme.shadowColor,
            ),
          ),
          
          for (var i = 0; i < tags.length; i++)
              ListTile(
                leading: Text(tags[i]["titulo"],style: TextStyle(fontSize: 20),),
                trailing: IconButton(icon: Icon(Icons.add),onPressed: (){_enviarPortal(tags[i]["goTo"]);}),
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
          _selectedIndex = value;
        }),
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
                                  "url": snapshot.data![index+1]["url"]
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
                                        snapshot.data![index+1]["title"],
                                        style: TextStyle(
                                            fontFamily: "Georgia",
                                            fontSize: 20),
                                      ),
                                    ),
                                    leading: Container(
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
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: 
                                  Image.memory(snapshot.data![0]["bytes"],fit: BoxFit.cover,)
                                ,
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
                                          snapshot.data![index]["title"]??Container(),
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
