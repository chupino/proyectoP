import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:periodico/services/dataHandler.dart';
import 'package:provider/provider.dart';

import '../../providers/ThemeHandler.dart';

class GenreSelected extends StatefulWidget {
  const GenreSelected({super.key});

  @override
  State<GenreSelected> createState() => _GenreSelectedState();
}

class _GenreSelectedState extends State<GenreSelected> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeHandler>(context);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final genre = args['genre'] as String;
    final title = args["title"] as String;
    print(genre);
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: articlesForGenre(genre, theme));
  }

  FutureBuilder articlesForGenre(String genre, ThemeHandler theme) {
    return FutureBuilder(
      future: UserServices().getArticlesforGenre(genre),
      builder: ((context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  //print(_searchResults[index]["url"]);
                  print(index);
                  Navigator.pushNamed(
                    context,
                    "/details",
                    arguments: {
                      "index": index,
                      "url": snapshot.data![index]["url"]
                    },
                  );
                  print(snapshot.data![index].runtimeType);
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
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(children: [
                    snapshot.data![index]["image"] != null
                        ? Image.network(snapshot.data![index]["image"])
                        : Container(),
                    Text(
                      snapshot.data![index]["title"],
                      style: GoogleFonts.notoSans(
                          textStyle: TextStyle(fontSize: 25)),
                    )
                  ]),
                ),
              );
            },
            itemCount: snapshot.data!.length,
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No se pudo cargar los resultados. Revisa tu conexion",
                  style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 25)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15,
                ),
                Icon(
                  Icons.wifi_off,
                  size: 50,
                )
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}
