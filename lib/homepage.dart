import 'package:flutter/material.dart';
import 'package:pokemon/components/color_button.dart';
import 'package:pokemon/components/theme_button.dart';
import 'package:pokemon/constraints.dart';
import 'package:pokemon/home.dart';
import 'package:pokemon/screens/pokemon_view.dart';

class Homepage extends StatefulWidget {
  const Homepage(
      {super.key,
      required this.changeTheme,
      required this.changeColor,
      required this.colorSelected});
  final void Function(bool useLightMode) changeTheme;
  final void Function(int value) changeColor;
  final ColorSelection colorSelected;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int tab = 0;

  List<NavigationDestination> appBarDestinations = [
    const NavigationDestination(
      icon: Icon(Icons.list_outlined),
      label: 'Sets',
      selectedIcon: Icon(Icons.list),
    ),
    const NavigationDestination(
      icon: Icon(Icons.abc_outlined),
      label: 'Pokemons',
      selectedIcon: Icon(Icons.abc),
    ),
    const NavigationDestination(
      icon: Icon(Icons.collections_outlined),
      label: 'Collection',
      selectedIcon: Icon(Icons.collections),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Pokemon Cards'),
        elevation: 4.0,
        actions: [
          ThemeButton(
            changeThemeMode: widget.changeTheme,
          ),
          ColorButton(
            changeColor: widget.changeColor,
            colorSelected: widget.colorSelected,
          ),
        ],
      ),
      body: IndexedStack(
        index: tab,
        children: const [
          Home(),
          PokemonView(),
          Center(
            child: Text('Collections will be added later.'),
          )
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        destinations: appBarDestinations,
        onDestinationSelected: (value) {
          setState(() {
            tab = value;
          });
        },
      ),
    );
  }
}
