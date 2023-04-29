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

  
  Future<List> getTitles() async {
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
    print(titles);
    
    //print(titles[2]);
      return titles;
    } else {
      print("error");
      return [];
    }
  }
  Future<String> checkThumbnail() async{
    final responseFecha=await http.get(Uri.parse("http://worldtimeapi.org/api/timezone/America/Lima"));
    final data=jsonDecode(responseFecha.body);
    DateTime fechaAhora=DateTime.parse(data["datetime"]);
    DateFormat format=DateFormat("dd-MM-yyyy");
    String fechaFormateada=format.format(fechaAhora);
    String mes="";
    String anio="";
    String fechaReal="";
    final directory=await getApplicationDocumentsDirectory();
    if(fechaAhora.hour>6 || fechaAhora.hour==6 && fechaAhora.minute>=0){
      fechaReal=fechaFormateada;
      mes=fechaAhora.month.toString().padLeft(2, '0');
      anio=fechaAhora.day.toString();
    }else{
      DateTime fechaPasada=fechaAhora.subtract(Duration(days: 1));
      String fechaFormateadaPasada=format.format(fechaPasada);
      mes=fechaPasada.month.toString().padLeft(2, '0');;
      anio=fechaPasada.day.toString();
      fechaReal=fechaFormateadaPasada;
    }
    File thumbnailImage=File("${directory.path}/$fechaReal.png");
    print(thumbnailImage.path);
    bool exists=await thumbnailImage.exists();
    print(exists);
    if(exists){
      return thumbnailImage.path;
    }else{
      /*
      final files = directory.listSync();
      for (final filePng in files) {
        if (filePng is File && filePng.path.endsWith('.png')) {
            await filePng.delete();
        }
  }*/
  thumbnailImage.writeAsBytes(await justGetThumbnail(mes, anio, fechaReal));
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("thumbnail", thumbnailImage.path);
  return thumbnailImage.path;

    }
  }
  Future<Uint8List> getThumbnail2()async{
    final response2=await http.get(Uri.parse("https://diarioelpueblo.com.pe/wp-content/uploads/2023/04/28-04-2023.pdf"));
    final Uint8List bytes=response2.bodyBytes;
    PdfDocument document=await PdfDocument.openData(bytes);
    final page=await document.getPage(1);
      final image=await page.render();
      final img=await image.createImageDetached();
      final bytesImg=await img.toByteData(format: ImageByteFormat.png);
      final bytesPng=bytesImg!.buffer.asUint8List(bytesImg.offsetInBytes,bytesImg.lengthInBytes);
      return bytesPng;
  }
  Future<Uint8List> justGetThumbnail(String month,String year,String date) async{
    final response2=await http.get(Uri.parse("https://diarioelpueblo.com.pe/wp-content/uploads/$year/$month/$date.pdf"));
    final Uint8List bytes=response2.bodyBytes;
    PdfDocument document=await PdfDocument.openData(bytes);
    final page=await document.getPage(1);
      final image=await page.render();
      final img=await image.createImageDetached();
      final bytesImg=await img.toByteData(format: ImageByteFormat.png);
      final bytesPng=bytesImg!.buffer.asUint8List(bytesImg.offsetInBytes,bytesImg.lengthInBytes);
      return bytesPng;
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
    String fechaFormateadaPasada=format.format(fechaPasada);
    String mesPasado=fechaPasada.month.toString().padLeft(2, '0');;
    String anioPasado=fechaPasada.year.toString();
    String fechaGuardada=prefs.getString("thumbnail")??"";
    DateTime fechaGuardadaDate=DateTime.parse(fechaGuardada);
    if(now.hour>6 || now.hour==6 && now.minute>=0){
      //si es que son mas de las 6
      final response2=await http.get(Uri.parse("https://diarioelpueblo.com.pe/wp-content/uploads/$anio/$mes/$fechaFormateada.pdf"));
      if(response2.headers['content-type']=="application/pdf"){
        //Si es que el pdf se actualizo correctamente a las 6

        if(fechaGuardadaDate!=now){
          //Descargar nuevo pdf
          return true;
        }else{
          //quedarse (no hacer nada)
          return false;
        }
      }else{
        //Si es que son las 6 y no hay pdf 
        final response3=await http.get(Uri.parse("https://diarioelpueblo.com.pe/wp-content/uploads/$anioPasado/$mesPasado/$fechaFormateadaPasada.pdf"));
        if(fechaGuardadaDate!=fechaPasada){
          //descargar nuevo pdf
          return true;
        }else{
          //no hacer nada
          return false;
        }
      }
    }else{
      //si es que no son mas de las 6
      final response4=await http.get(Uri.parse("https://diarioelpueblo.com.pe/wp-content/uploads/$anioPasado/$mesPasado/$fechaFormateadaPasada.pdf"));
      if(fechaGuardadaDate!=fechaPasada){
        //descargar nuevo pdf
        return true;
      }else{
        //no hacer nada
        return false;
      }
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
        await prefs.setString("thumbnail", fechaFormateada);
        return bytesPng;
      }else{
        print("no era");
        DateTime fechaPasada=now.subtract(Duration(days: 1));
      String fechaFormateadaPasada=format.format(fechaPasada);
      print(fechaFormateadaPasada);
      String mesPasado=fechaPasada.month.toString().padLeft(2, '0');;
      String anioPasado=fechaPasada.year.toString();

      final response2=await http.get(Uri.parse("https://diarioelpueblo.com.pe/wp-content/uploads/$anioPasado/$mesPasado/$fechaFormateadaPasada.pdf"));
      final Uint8List bytes=response2.bodyBytes;
      
      PdfDocument document=await PdfDocument.openData(bytes);
      
      final page=await document.getPage(1);
      final image=await page.render();
      final img=await image.createImageDetached();
      final bytesImg=await img.toByteData(format: ImageByteFormat.png);
      final bytesPng=bytesImg!.buffer.asUint8List(bytesImg.offsetInBytes,bytesImg.lengthInBytes);
      await prefs.setString("thumbnail", fechaFormateadaPasada);
      return bytesPng;
      }
      
    }else{
      print("nos quedamos con el que tenemos");
      DateTime fechaPasada=now.subtract(Duration(days: 1));
      String fechaFormateadaPasada=format.format(fechaPasada);
      String mesPasado=fechaPasada.month.toString().padLeft(2, '0');;
      String anioPasado=fechaPasada.year.toString();

      final response2=await http.get(Uri.parse("https://diarioelpueblo.com.pe/wp-content/uploads/$anioPasado/$mesPasado/$fechaFormateadaPasada.pdf"));
      final Uint8List bytes=response2.bodyBytes;

      PdfDocument document=await PdfDocument.openData(bytes);
      
      final page=await document.getPage(1);
      final image=await page.render();
      final img=await image.createImageDetached();
      final bytesImg=await img.toByteData(format: ImageByteFormat.png);
      final bytesPng=bytesImg!.buffer.asUint8List(bytesImg.offsetInBytes,bytesImg.lengthInBytes);
      await prefs.setString("thumbnail", fechaFormateadaPasada);
      return bytesPng;
    }

  }
/*
  Future<Map> getNew(int index) async {
    final url =
        "https://newsapi.org/v2/everything?q=tesla&from=2023-03-28&sortBy=publishedAt&apiKey=5025449ded9546259210dcca8c7a5531";
    Uri urlUri = Uri.parse(url);
    final response = await http.get(urlUri);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var articles = data["articles"] as List;
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
  }*/
/*
  Future<List> searchTitle(String title) async {
    final url =
        "https://newsapi.org/v2/everything?qInTitle='{$title}'&language=es&from=2023-03-28&sortBy=publishedAt&apiKey=5025449ded9546259210dcca8c7a5531";
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
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final switchStates = <String, dynamic>{};
    for (final key in keys) {
      switchStates[key] = prefs.getBool(key) ?? false;
    }
    return switchStates;
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
