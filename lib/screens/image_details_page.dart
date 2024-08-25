import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:pokemon/screens/set_view.dart';

class ImageDetailsPage extends StatefulWidget {
  final String url;
  const ImageDetailsPage({super.key, required this.url});

  @override
  State<ImageDetailsPage> createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {
  List<dynamic> items = [];
  List<dynamic>? pokemons;
  List<dynamic>? sets;
  List<dynamic>? rarityItems;
  Map<String, dynamic>? details;

  @override
  void initState() {
    super.initState();
    loadCardData();
  }

  Future<void> loadCardData() async {
    String jsonString = await rootBundle.loadString('assets/details.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    String jsonString2 = await rootBundle.loadString('assets/pokemon.json');
    final jsonResponse2 = json.decode(jsonString2);
    String jsonString3 = await rootBundle.loadString('assets/images3.json');
    final jsonResponse3 = json.decode(jsonString3);
    String rarityJson = await rootBundle.loadString('assets/rarity_links.json');
    final rarityResponse = json.decode(rarityJson);
    setState(() {
      items = jsonResponse;
      details = searchUrl(widget.url);
      pokemons = jsonResponse2;
      sets = jsonResponse3;
      rarityItems = rarityResponse;
    });
  }

  List<dynamic> getPokemonList(List<dynamic> items, String name) {
    for (var item in items) {
      if (item['name'] == name) {
        return item['urls'] ?? [];
      }
    }
    return [];
  }

  List<dynamic> getRarityList(List<dynamic> items, String name) {
    for (var item in items) {
      if (item['rarity'] == name) {
        return item['urls'] ?? [];
      }
    }
    return [];
  }

  List<dynamic> getSetList(List<dynamic> items, String name) {
    for (var item in items) {
      if (item['setName'] == name) {
        return item['cards'] ?? [];
      }
    }
    return [];
  }

  Map<String, dynamic>? searchUrl(String url) {
    for (var item in items) {
      if (item['ImageJPG'] == url) {
        return item['details'] as Map<String, dynamic>;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    //List<dynamic> imageList = pokemonList(items, details!['Pokemon']);
    return (details != null &&
            pokemons != null &&
            sets != null &&
            rarityItems != null)
        ? buildContent()
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget buildContent() {
    const style = TextStyle(fontSize: 20);

    // Build the actual content of your page here, using the 'details' data.
    return Scaffold(
      appBar: AppBar(
        title: Text(details!['Name']),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            },
            icon: const Icon(Icons.home),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
        child: ListView(
          children: [
            Row(
              children: [
                if (details!['type'] == "Pokemon")
                  const Text("Pokemon: ", style: style),
                if (details!['type'] != "Pokemon")
                  const Text(
                    'Trainer Card',
                    style: style,
                  ),
                if (details!['type'] == "Pokemon")
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SetView(
                              imageList: getPokemonList(
                                  pokemons!, details!['Pokemon']),
                              setName: details!['Pokemon'],
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "${details!['Pokemon']}",
                      style: style,
                    ),
                  ),
              ],
            ),
            if (details!['type'] == "Pokemon")
              Text("Color: ${details!['Color']}", style: style),
            Row(
              children: [
                const Text("Set: ", style: style),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SetView(
                            imageList: getSetList(sets!, details!['Set']),
                            setName: details!['Set'],
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    "${details!['Set']}",
                    style: style,
                  ),
                ),
              ],
            ),
            if (details!['type'] == "Pokemon")
              Text(details!['HP'], style: style),
            if (details!['type'] == "Pokemon") const SizedBox(height: 8.0),
            Text("Card Serial: ${details!['serial']}", style: style),
            if (details!['type'] == "Pokemon") const SizedBox(height: 8),
            if (details!['type'] == "Pokemon")
              Text("Stage: ${details!['Stage']}", style: style),
            Row(
              children: [
                const Text("Rarity: ", style: style),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SetView(
                            imageList:
                                getRarityList(rarityItems!, details!['Rarity']),
                            setName: details!['Rarity'],
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    "${details!['Rarity']}",
                    style: style,
                  ),
                ),
              ],
            ),
            Text("Date Released: ${details!['Date']}", style: style),
            const SizedBox(height: 8.0),
            if (details!['type'] == "Pokemon")
              const Text(
                "Evolutions:",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            const SizedBox(height: 8),
            if (details!['type'] == "Pokemon")
              ...(details!['Evolution'] as List<dynamic>).isNotEmpty
                  ? (details!['Evolution'] as List<dynamic>)
                      .map((evolution) => Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SetView(
                                        imageList: getPokemonList(
                                          pokemons!,
                                          evolution,
                                        ),
                                        setName: evolution,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  evolution,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList()
                  : [
                      const Center(
                        child: Text(
                          "None",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
          ],
        ),
      ),
    );
  }
}
