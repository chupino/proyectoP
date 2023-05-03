import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart';

class UserServices {

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
  
  Future<List> getNoticias() async {
    final url =
        "https://diarioelpueblo.com.pe/wp-json/wp/v2/posts/";
    Uri urlUri = Uri.parse(url);
    final response = await http.get(urlUri).timeout(Duration(minutes: 5));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var articles = data as List;
      var titles = articles
          .map((e) => {
                "title": e["title"],
                "image": e["urlToImage"],
                "autor": e["author"],
              })
          .toList();    
      return titles;
    } else {
      throw "Error en la petición http";
    }
  }
 

  Future<bool> checkDate() async{
    final prefs = await SharedPreferences.getInstance();
    tz.initializeTimeZones();
    var lima=getLocation("America/Lima");
    var now=TZDateTime.now(lima);
    DateFormat format=DateFormat("dd-MM-yyyy");
    String fechaFormateada=format.format(now);
    String mes=now.month.toString().padLeft(2, '0');
    String anio=now.year.toString();
    DateTime fechaPasada=now.subtract(Duration(days: 1));
    String fechaBeta=format.format(fechaPasada);
    DateTime fechaPasadaFormateadaDate=DateFormat("dd-MM-yyyy").parse(fechaBeta);
    String fechaFormateadaPasada=format.format(fechaPasada);
    String mesPasado=fechaPasada.month.toString().padLeft(2, '0');;
    String anioPasado=fechaPasada.year.toString();
    DateTime fechaAhoraDate=DateFormat("dd-MM-yyyy").parse(fechaFormateada);

   

    String datosGuardados=await prefs.getString("datosThumbnail")??"";

    if(datosGuardados!=null && datosGuardados.isNotEmpty){
      Map<String,dynamic> datos=json.decode(datosGuardados);
      String fechaGuardada=datos["fecha"]??"";
      print("------------------------$fechaGuardada");
      DateTime fechaGuardadaDate=DateFormat('dd-MM-yyyy').parse(fechaGuardada);
      if(now.hour>6 || now.hour==6 && now.minute>=0){
      //si es que son mas de las 6
      final response2=await http.get(Uri.parse("https://diarioelpueblo.com.pe/wp-content/uploads/$anio/$mes/$fechaFormateada.pdf"));
      if(response2.headers['content-type']=="application/pdf"){
        //Si es que el pdf se actualizo correctamente a las 6

        if(fechaGuardadaDate!=fechaAhoraDate){
          //Descargar nuevo pdf
          print("$fechaGuardadaDate vs $fechaAhoraDate");
          print("1");
          return true;
        }else{
          //quedarse (no hacer nada)
          print("$fechaGuardadaDate vs $fechaAhoraDate");
          print("2");
          return false;
        }
      }else{
        //Si es que son las 6 y no hay pdf 
        if(fechaGuardadaDate!=fechaPasadaFormateadaDate){
          //descargar nuevo pdf
          
          print("$fechaGuardadaDate vs $fechaPasadaFormateadaDate");
          print("3");
          return true;
        }else{
          //no hacer nada
          print("$fechaGuardadaDate vs $fechaPasadaFormateadaDate");
          print("4");
          return false;
        }
      }
    }else{
      //si es que no son mas de las 6
      if(fechaGuardadaDate!=fechaPasadaFormateadaDate){
        //descargar nuevo pdf
        print("$fechaGuardadaDate vs $fechaPasadaFormateadaDate");
        print("5");
        return true;
      }else{
        //no hacer nada
        print("6");
        print("$fechaGuardadaDate vs $fechaPasadaFormateadaDate");
        return false;
      }
    }
    }else{
      print("++++++++++++++++++++++no hay datos en prefs");
      return true;
    }
    
  }
  Future<Uint8List> getThumbnail() async{
    final prefs = await SharedPreferences.getInstance();
    tz.initializeTimeZones();
    var lima=getLocation("America/Lima");
    var now=TZDateTime.now(lima);
    DateFormat format=DateFormat("dd-MM-yyyy");
    String fechaFormateada=format.format(now);
    String mes=now.month.toString().padLeft(2, '0');
    String anio=now.year.toString();
    print(now);
    print(fechaFormateada);
    if(now.hour>6 || now.hour==6 && now.minute>=0){
      print("nuevo diario ya!");
      final response2=await http.get(Uri.parse("https://diarioelpueblo.com.pe/wp-content/uploads/$anio/$mes/$fechaFormateada.pdf"));
      print("https://diarioelpueblo.com.pe/wp-content/uploads/$anio/$mes/$fechaFormateada.pdf");
      print(response2.headers['content-type']);
      if(response2.headers['content-type']=="application/pdf"){
        final Uint8List bytes=response2.bodyBytes;
        PdfDocument document=await PdfDocument.openData(bytes);
        final page=await document.getPage(1);
        final image=await page.render();
        final img=await image.createImageDetached();
        final bytesImg=await img.toByteData(format: ImageByteFormat.png);
        final bytesPng=bytesImg!.buffer.asUint8List(bytesImg.offsetInBytes,bytesImg.lengthInBytes);
        String encodedData = base64Encode(bytesPng);
        Map<String,dynamic> datos={
          "fecha":fechaFormateada,
          "bytes":encodedData
        };
        String datosString=json.encode(datos);
        await prefs.setString("datosThumbnail", datosString);
        return bytesPng;
      }else{
        print("no era");
        DateTime fechaPasada=now.subtract(Duration(days: 1));
      String fechaFormateadaPasada=format.format(fechaPasada);
      print(fechaFormateadaPasada);
      String mesPasado=fechaPasada.month.toString().padLeft(2, '0');
      String anioPasado=fechaPasada.year.toString();

      final response2=await http.get(Uri.parse("https://diarioelpueblo.com.pe/wp-content/uploads/$anioPasado/$mesPasado/$fechaFormateadaPasada.pdf"));
      final Uint8List bytes=response2.bodyBytes;
      
      PdfDocument document=await PdfDocument.openData(bytes);
      
      final page=await document.getPage(1);
      final image=await page.render();
      final img=await image.createImageDetached();
      final bytesImg=await img.toByteData(format: ImageByteFormat.png);
      final bytesPng=bytesImg!.buffer.asUint8List(bytesImg.offsetInBytes,bytesImg.lengthInBytes);

      String encodedData = base64Encode(bytesPng);
        Map<String,dynamic> datos={
          "fecha":fechaFormateadaPasada,
          "bytes":encodedData
        };
      String datosString=json.encode(datos);
      await prefs.setString("datosThumbnail", datosString);
      return bytesPng;
      }
      
    }else{
      print("nos quedamos con el que tenemos");
      DateTime fechaPasada=now.subtract(Duration(days: 1));
      String fechaFormateadaPasada=format.format(fechaPasada);
      String mesPasado=fechaPasada.month.toString().padLeft(2, '0');;
      String anioPasado=fechaPasada.year.toString();

      http.Response response2=await http.get(Uri.parse("https://diarioelpueblo.com.pe/wp-content/uploads/$anioPasado/$mesPasado/$fechaFormateadaPasada.pdf"));
      
      while(response2.headers['content-type']!="application/pdf"){
        fechaPasada=fechaPasada.subtract(Duration(days: 1));
        fechaFormateadaPasada=format.format(fechaPasada);
        mesPasado=fechaPasada.month.toString().padLeft(2, '0');;
        anioPasado=fechaPasada.year.toString();
        response2=await http.get(Uri.parse("https://diarioelpueblo.com.pe/wp-content/uploads/$anioPasado/$mesPasado/$fechaFormateadaPasada.pdf"));
        print(fechaPasada);
      }
      final Uint8List bytes=response2.bodyBytes;

      PdfDocument document=await PdfDocument.openData(bytes);
      
      final page=await document.getPage(1);
      final image=await page.render();
      final img=await image.createImageDetached();
      final bytesImg=await img.toByteData(format: ImageByteFormat.png);
      final bytesPng=bytesImg!.buffer.asUint8List(bytesImg.offsetInBytes,bytesImg.lengthInBytes);
       String encodedData = base64Encode(bytesPng);
        Map<String,dynamic> datos={
          "fecha":fechaFormateadaPasada,
          "bytes":encodedData
        };
      String datosString=json.encode(datos);
      await prefs.setString("datosThumbnail", datosString);
      return bytesPng;
    }

  }

  Future<Map> getArticle(int index) async {
    Uri urlUri = Uri.parse("https://diarioelpueblo.com.pe/wp-json/wp/v2/posts/");
    final response = await http.get(urlUri);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var articles = data as List;
      
      List article = articles
          .map((e) => {
                "title": e["title"],
                "image": e["urlToImage"],
                "autor": e["author"],
                "description": e["description"],
                "content": e["content"],
                "date": e["publishedAt"],
              })
          .toList();
      Map _article = article[index];
      print(_article["image"]);
      String dateString = _article["date"];
      DateTime date = DateTime.parse(dateString);
      String dayName = DateFormat.EEEE("es").format(date);
      String monthName = DateFormat.MMMM("es").format(date);
      String formattedDate =
          "$dayName ${date.day} de $monthName del ${date.year}";

      print("FECHA:$formattedDate");
      _article["date"] = formattedDate;
      return _article;
    } else {
      return {};
    }
  }

  Future<void> saveSwitchState(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool> getSwitchState(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  Future<Map<String, dynamic>> getAllSwitchStates() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final switchStates = <String, dynamic>{};
      
      for (final key in keys) {
        print(key);
        final value=await prefs.get(key);
        print(value);
        if(value.toString()=="true" || value.toString()=="false"){
          switchStates[key] = prefs.getBool(key) ?? false;

        }

      }
      
      print(switchStates);
      return switchStates;
    }catch(e){
      print("Error: $e");
      return {};
    }

  }

  Future<void> initKeys() async {
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
  }

/*
  Future<List> getArticlesforGenre(String genre) async {
    final url =
        "https://newsapi.org/v2/everything?q=$genre&language=es&from=2023-03-28&sortBy=publishedAt&apiKey=5025449ded9546259210dcca8c7a5531";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var articles = data["articles"] as List;
      var titles = articles
          .map((e) => {
                "title": e["title"],
                "image": e["urlToImage"],
                "autor": e["author"],
                "url": url
              })
          .toList();

      return titles;
    } else {
      print("error");
      return [];
    }
  }*/
/*
  Future<Map> getContentNotification(String id) async {
    final url =
        "https://testperiodico777.000webhostapp.com/wp-json/custom/posts?id=$id";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      final titles = data
          .map((e) => {
                "id": e["id"],
                "title": e["title"],
                "content": e["content"],
              })
          .toList();
      return titles[0];
    } else {
      print("errorR");
      return {};
    }
  }*/
}
