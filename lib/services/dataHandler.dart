import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  Future<List> getTitles() async {
    //final url =
    "https://newsapi.org/v2/top-headlines?country=ar&category=business&apiKey=0d27d591742945da896d34927af6a3b0";
    final url =
        "https://newsapi.org/v2/everything?q=tesla&language=es&from=2023-01-22&sortBy=publishedAt&apiKey=0d27d591742945da896d34927af6a3b0";
    Uri urlUri = Uri.parse(url);
    final response = await http.get(urlUri);
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
      print(titles);
      return titles;
    } else {
      print("error");
      return [];
    }
  }

  Future<Map> getNew(int index) async {
    final url =
        "https://newsapi.org/v2/everything?q=tesla&from=2023-02-22&sortBy=publishedAt&apiKey=0d27d591742945da896d34927af6a3b0";
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
        "https://newsapi.org/v2/everything?qInTitle='{$title}'&language=es&from=2023-01-22&sortBy=publishedAt&apiKey=0d27d591742945da896d34927af6a3b0";
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
        "https://newsapi.org/v2/everything?q=$genre&language=es&from=2023-01-22&sortBy=publishedAt&apiKey=0d27d591742945da896d34927af6a3b0";
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
      final titles = data.map((e) => {
            "id": e["id"],
            "title": e["title"],
            "content": e["content"],
          }) as Map;
      return titles;
    } else {
      print("error");
      return {};
    }
  }
}
