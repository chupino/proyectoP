import 'package:flutter/material.dart';
import 'package:periodico/Widgets/Fwidgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/ThemeHandler.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
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

    void _enviarPortalBusqueda() async {
    final search=_searchController.text;
    final url = 'https://diarioelpueblo.com.pe/?s=$search';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        );
    } else {
      throw 'No se pudo abrir $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeHandler>(context);
    return Scaffold(
      appBar: const appBar(
        tittle: "SECCIONES",
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                width: MediaQuery.of(context).size.width - 20,
                child: TextField(
                  focusNode: _searchFocusNode,
                  onSubmitted: (value) {
                    _enviarPortalBusqueda();
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    hintText: 'Buscar...',
                    
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        //_searchFocusNode.unfocus();
                        _enviarPortalBusqueda();
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ...[
                ArticlesGens(),
                // aquí muestras los géneros disponibles
              ]
            ],
          ),
        ),
      ),
      bottomNavigationBar: const navBar(
        selectedIndex: 1,
      ),
    );
  }

  Container ArticlesGens() {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            for (var i = 0; i < tags.length; i++)
              CustomCardTags(
                  title: tags[i]["titulo"],
                  image: tags[i]["imagenURL"],
                  url: tags[i]["goTo"])
          ],
        ),
      ),
    );
  }
}
