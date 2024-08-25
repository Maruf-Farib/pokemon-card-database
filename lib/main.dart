import 'package:flutter/material.dart';
import 'package:pokemon/constraints.dart';
import 'package:pokemon/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelection = ColorSelection.teal;
  void changeThemeMode(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void changeColor(int value) {
    setState(() {
      colorSelection = ColorSelection.values[value];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokemon Cards',
      initialRoute: '/',
      routes: {
        '/': (context) => Homepage(
              colorSelected: colorSelection,
              changeTheme: changeThemeMode,
              changeColor: changeColor,
            ),
        // other routes
      },
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: colorSelection.color,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: colorSelection.color,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      // home: Homepage(
      //   colorSelected: colorSelection,
      //   changeTheme: changeThemeMode,
      //   changeColor: changeColor,
      // ),
    );
  }
}
