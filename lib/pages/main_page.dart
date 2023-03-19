import 'package:flutter/material.dart';
import 'package:wordle_infinity/constants/constants.dart';
import 'package:wordle_infinity/constants/game_meta.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPage();
  }
}

class _MainPage extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game_title),
        centerTitle: true,
      ),
      body: ListView(shrinkWrap: true, children: [
        Center(
            child: Column(
                children: menu_items
                    .map((menuItem) => TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      routeResolver[menuItem]!));
                        },
                        child: Container(
                            padding: edgeInsetsAll(35.0),
                            child: Text(menuItem,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'cursive',
                                    fontSize: 26.0)))))
                    .toList()))
      ]),
    );
  }
}
