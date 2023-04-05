import 'package:flutter/material.dart';
import 'package:periodico/Widgets/Fwidgets.dart';
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
  final List<Map> tags = [
    {
      "titulo": "Deporte",
      "genre": "Deportes",
      "asset": "assets/futbolCard.jpeg"
    },
    {
      "titulo": "Policiacos",
      "genre": "Delincuencia",
      "asset": "assets/policiaCard.jpeg"
    },
    {
      "titulo": "Politica",
      "genre": "Politica",
      "asset": "assets/politicaCard.jpeg"
    },
    {
      "titulo": "Economia",
      "genre": "Economia",
      "asset": "assets/economiaCard.jpeg"
    },
    {"titulo": "Salud", "genre": "Salud", "asset": "assets/saludCard.jpeg"},
    {
      "titulo": "Tecnologia",
      "genre": "Tecnologia",
      "asset": "assets/tecnologiaCard.jpeg"
    },
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeHandler>(context);
    return Scaffold(
      appBar: const appBar(
        tittle: "EXPLORAR",
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 20,
                child: TextField(
                  focusNode: _searchFocusNode,
                  onSubmitted: (value) {
                    Navigator.pushNamed(context, "/searchResult",
                        arguments: {"search": value});
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    hintText: 'Buscar...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
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
                  image: tags[i]["asset"],
                  genre: tags[i]["genre"])
          ],
        ),
      ),
    );
  }
}
