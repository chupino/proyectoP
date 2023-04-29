import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:periodico/Widgets/Fwidgets.dart';
import 'package:periodico/services/dataHandler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/ThemeHandler.dart';

class searchResult extends StatefulWidget {
  const searchResult({super.key});

  @override
  State<searchResult> createState() => _searchResultState();
}

class _searchResultState extends State<searchResult> {
  TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeHandler>(context);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String search = args['search'] as String;
    _searchController.text = search;
    void updateSearchValue(String value) {
      setState(() {
        Map args = ModalRoute.of(context)?.settings.arguments as Map;
        args['search'] = '$value';
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            BackButton(),
            SizedBox(width: 10),
            SearchBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onSubmitted: (value) {
                  updateSearchValue(value);
                })
          ],
        ),
      ),
      body: Container()
      //searchArticlesResult(theme),
    );
  }
/*
  FutureBuilder<List<dynamic>> searchArticlesResult(ThemeHandler theme) {
    return FutureBuilder(
      future: UserServices().searchTitle(_searchController.text),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Muestra un mensaje de error si la petición falla
          return resultError();
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // Muestra los datos si se reciben correctamente
          return resultSuccess(snapshot, theme);
        } else if (snapshot.connectionState == ConnectionState.done) {
          return ResultNoData();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }*/

  Center ResultNoData() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "No hay resultados para '${_searchController.text}'",
            style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 25)),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15,
          ),
          Icon(
            Icons.search_off,
            size: 50,
          )
        ],
      ),
    );
  }

  ListView resultSuccess(
      AsyncSnapshot<List<dynamic>> snapshot, ThemeHandler theme) {
    return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
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
                  color: Theme.of(context).canvasColor,
                  border: Border(
                    top: BorderSide(
                      width: 1.0,
                    ),
                    bottom: BorderSide(
                      width: 1.0,
                    ),
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
            ),
          );
        });
  }

  Center resultError() {
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
  }
}
