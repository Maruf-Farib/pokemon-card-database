import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:pokemon/screens/set_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with WidgetsBindingObserver {
  List<dynamic> items = [];
  List<dynamic> rarityItems = [];
  List<String> rarity = [];
  List<String> names = [];
  List<dynamic> filteredNames = [];
  Set<int> selectedSegment = {0};
  int _selectedIndex = 0;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadJsonData();
    loadRarity();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Close the keyboard when the app is resumed
      _focusNode.unfocus();
    }
  }

  Future<void> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/pokemon.json');
    final jsonResponse = json.decode(jsonString);
    setState(() {
      items = jsonResponse;
      names = items.map<String>((item) => item['name'] as String).toList();
    });
  }

  Future<void> loadRarity() async {
    String rarityJson = await rootBundle.loadString('assets/rarity_links.json');
    final rarityResponse = json.decode(rarityJson);
    setState(() {
      rarityItems = rarityResponse;
      rarity =
          rarityItems.map<String>((item) => item['rarity'] as String).toList();
    });
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      filteredNames = names
          .where((name) => name.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    } else {
      filteredNames = [];
    }
    setState(() {});
  }

  void showUrlsForItem(String name) {
    final item = items.firstWhere((element) => element['name'] == name);
    final urls = item['urls'] as List<dynamic>;

    // Replace this with your component or logic to handle the URLs
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetView(imageList: urls, setName: name),
      ),
    );
  }

  void showUrlsForRarity(String name) {
    final item = rarityItems.firstWhere((element) => element['rarity'] == name);
    final urls = item['urls'] as List<dynamic>;

    // Replace this with your component or logic to handle the URLs
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetView(imageList: urls, setName: name),
      ),
    );
  }

  Widget _buildSearch() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            focusNode: _focusNode,
            onChanged: (value) {
              filterSearchResults(value);
            },
            decoration: const InputDecoration(
              labelText: "Search by name",
              hintText: "charizard",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredNames.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredNames[index]),
                onTap: () {
                  _focusNode.unfocus();
                  showUrlsForItem(filteredNames[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRarityChips() {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 4,
      runSpacing: 3,
      children: rarity.map((label) {
        return InkWell(
          child: Chip(
            label: Text(label),
          ),
          onTap: () {
            showUrlsForRarity(label);
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildSearch(),
                Column(
                  children: [
                    const Text(
                      'Select Rarity',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildRarityChips(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: SegmentedButton(
              segments: const [
                ButtonSegment(
                  label: Text('Name'),
                  icon: Icon(Icons.search_sharp),
                  value: 0,
                ),
                ButtonSegment(
                  label: Text('Rarity'),
                  icon: Icon(Icons.cabin),
                  value: 1,
                ),
              ],
              selected: selectedSegment,
              showSelectedIcon: false,
              onSelectionChanged: (Set<int> segmentIIndex) {
                setState(() {
                  selectedSegment = segmentIIndex;
                  _selectedIndex = segmentIIndex.first;
                  _focusNode.unfocus();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
