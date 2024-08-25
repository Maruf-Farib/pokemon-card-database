import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:pokemon/screens/set_view.dart';
import 'package:pokemon/update_checker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    checkForUpdates(context);
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/images3.json');
    final jsonResponse = json.decode(jsonString);
    setState(() {
      items = jsonResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        centerTitle: true,
        title: const Text('Pokemon Sets'),
      ),*/
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
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
                      imageList: items[index]['cards'],
                      setName: items[index]['setName'],
                    );
                  },
                ),
              );
            },
            // child: Card(
            //   child: Center(
            //     child: Text(
            //       textAlign: TextAlign.center,
            //       items[index]['setName'],
            //       style: const TextStyle(
            //         fontWeight: FontWeight.w600,
            //         fontSize: 17,
            //       ),
            //     ),
            //   ),
            // ),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.network(items[index]['image']),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      items[index]['setName'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
