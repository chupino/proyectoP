import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:periodico/Widgets/Fwidgets.dart';
import 'package:periodico/services/dataHandler.dart';
import 'package:provider/provider.dart';

import '../../providers/ThemeHandler.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeHandler>(context);
    return Scaffold(
      appBar: const appBar(
        tittle: "EXPLORAR",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            TextField(
              focusNode: _searchFocusNode,
              onSubmitted: (value) {
                Navigator.pushNamed(context, "/searchResult",
                    arguments: {"search": value});
              },
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintText: 'Buscar...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.theme == ThemeData.dark()
                    ? Colors.grey[900]
                    : Colors.grey[300],
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    //_searchFocusNode.unfocus();
                    Navigator.pushNamed(context, "/searchResult",
                        arguments: {"search": _searchController.text});
                    _searchFocusNode.unfocus();
                  },
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
      bottomNavigationBar: const navBar(
        selectedIndex: 1,
      ),
    );
  }

  SingleChildScrollView ArticlesGens() {
    return SingleChildScrollView(
      child: Wrap(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/genreSelected",
                  arguments: {"genre": "Deportes", "title": "Deportes"});
            },
            child: Card(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 10,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/futbolCard.jpeg',
                      fit: BoxFit.cover,
                    ),
                    Text('Deporte', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/genreSelected",
                  arguments: {"genre": "Delincuencia", "title": "Policiacos"});
            },
            child: Card(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 10,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/policiaCard.jpeg',
                      fit: BoxFit.cover,
                    ),
                    Text('Policia', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/genreSelected",
                  arguments: {"genre": "Politica", "title": "Politica"});
            },
            child: Card(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 10,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/politicaCard.jpeg',
                      fit: BoxFit.cover,
                    ),
                    Text('Politica', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/genreSelected",
                  arguments: {"genre": "Economia", "title": "Economia"});
            },
            child: Card(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 10,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/economiaCard.jpeg',
                      fit: BoxFit.cover,
                    ),
                    Text('Economia', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/genreSelected",
                  arguments: {"genre": "Salud", "title": "Salud"});
            },
            child: Card(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 10,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/saludCard.jpeg',
                      fit: BoxFit.cover,
                    ),
                    Text('Salud', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/genreSelected",
                  arguments: {"genre": "Tecnologia", "title": "Tecnologia"});
            },
            child: Card(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 10,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/tecnologiaCard.jpeg',
                      fit: BoxFit.cover,
                    ),
                    Text('Tecnologia', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
