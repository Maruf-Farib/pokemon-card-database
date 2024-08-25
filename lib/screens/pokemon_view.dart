import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pokemon/screens/search_page.dart';
import 'dart:convert';

import 'package:pokemon/screens/set_view.dart';

class PokemonView extends StatefulWidget {
  const PokemonView({super.key});

  @override
  State<PokemonView> createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  List<dynamic> items = [];

  Future<void> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/pokemon.json');
    final jsonResponse = json.decode(jsonString);

    setState(() {
      items = jsonResponse;
    });
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('Pokemons'),
      ),*/
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3 / 1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SetView(
                      imageList: items[index]['urls'],
                      setName: items[index]['name'],
                    );
                  },
                ),
              );
            },
            child: Card(
              //color: Colors.lightBlue.shade100,
              //color: Theme.of(context).colorScheme.surface,
              color: const Color(0xFFE3F2FD),
              child: Center(
                child: Text(
                  items[index]["name"],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const SearchPage();
              },
            ),
          );
        },
        label: const Text('Search'),
        icon: const Icon(Icons.search),
      ),
    );
  }
}
