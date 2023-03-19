import 'package:flutter/material.dart';
import 'package:wordle_infinity/constants/constants.dart';

import '../constants/game_meta.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GamePage();
  }
}

class _GamePage extends State<GamePage> {
  int cursorX = 0;
  int cursorY = 0;

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    // Size keyboardSize = getKeyboardSize(size.width, size.height);
    // double blockSize = getBlockSize(size.width);
    // double keyboardWidth = keyboardSize.width;
    // double keyboardHeight = keyboardSize.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(game_title),
          centerTitle: true,
        ),
        body: Container(
          color: const Color.fromARGB(255, 0, 30, 60),
          child:
              // getGridWidget()
              Column(children: [getGridWidget(), getKeyboard()]),
        ));
  }
}
