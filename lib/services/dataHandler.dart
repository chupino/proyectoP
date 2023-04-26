import 'dart:typed_data';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {

  Future<void> getTest() async{
    final url="https://diarioelpueblo.com.pe/wp-json/wp/v2/posts/";
    Uri urlUri = Uri.parse(url);
    final response = await http.get(urlUri);
    if(response.statusCode==200){
      print("si");
      var data = jsonDecode(response.body);
      var articles = data as List;
      print(articles);
    }else{
      print("no");
    }
  }
  Future<List> getTitles() async {
    final url =
        "https://diarioelpueblo.com.pe/wp-json/wp/v2/posts/";
    Uri urlUri = Uri.parse(url);
    final response = await http.get(urlUri);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var articles = data as List;
      var titles = articles
          .map((e) => {
                "title": e["title"],
                "image": e["urlToImage"],
                "autor": e["author"],
                "url": url
              })
          .toList();
    /* final response2=await http.get(Uri.parse("https://ifj.org/fileadmin/user_upload/Fake_News_-_FIP_AmLat.pdf"));
    var data2=response.bodyBytes;

    titles.insert(0,{"bytes":data2});
    print(titles);
    print(titles.length); */
    print(titles);
    final response2=await http.get(Uri.parse("https://diarioelpueblo.com.pe/wp-content/uploads/2023/04/26-04-2023.pdf"));
    final Uint8List bytes=response2.bodyBytes;

    PdfDocument document=await PdfDocument.openData(bytes);
    
    final page=await document.getPage(1);
    final image=await page.render();
    final img=await image.createImageDetached();
    final bytesImg=await img.toByteData(format: ImageByteFormat.png);
    final bytesPng=bytesImg!.buffer.asUint8List(bytesImg.offsetInBytes,bytesImg.lengthInBytes);
    titles.insert(0, {"bytes":bytesPng as Uint8List});
    //print(titles[2]);
      return titles;
    } else {
      print("error");
      return [];
    }
  }

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
  }

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
  }

  Future<Map> getArticle(String url, int index) async {
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
  }

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
  }
}
