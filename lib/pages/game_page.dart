import 'package:flutter/material.dart';
import 'package:wordle_infinity/constants/allWords.dart';
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
  List<String> pressedKeys = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(game_title),
          centerTitle: true,
        ),
        body: Container(
          color: const Color.fromARGB(255, 0, 30, 60),
          child: Column(children: [getGridWidget(), getKeyboard()]),
        ));
  }

  Widget getKeyboard() {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: allKeys.map((row) => getKeyboardRow(row)).toList(),
      ),
    );
  }

  Widget getKeyboardRow(List<String> row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row.map((key) => getKeyboardKey(key)).toList(),
    );
  }

  Widget getKeyboardKey(String key) {
    Widget child;
    if (key == '🠔') {
      child = backspace_key;
    } else if (key == '⏎') {
      child = return_key;
    } else {
      child = Text(
        key,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: Colors.white,
        ),
      );
    }

    return Flexible(
      child: Container(
        height: 44,
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color:
              key == '🠔' || key == '⏎' ? Colors.transparent : Colors.blueGrey,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              switch (key) {
                case '🠔':
                  pressedKeys.isNotEmpty ? pressedKeys.removeLast() : null;
                  break;
                case '⏎':
                  {
                    if ((pressedKeys.length) % 5 != 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(NOT_ENOUGH_WORDS),
                      ));
                    } else {
                      if (!isValidWord(pressedKeys.join())) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(INVALID_WORD),
                        ));
                      }
                    }
                  }
                  break;
                default:
                  pressedKeys.add(key);
                  break;
              }
            });
          },
          child: child,
        ),
      ),
    );
  }

  Widget cell({String placeHolder = ''}) {
    return Flexible(
      child: Container(
        height: 44,
        width: 44,
        margin: const EdgeInsets.only(right: 8.0),
        color: Colors.blueGrey,
        child: Center(
          child: Text(
            pressedKeys.contains(placeHolder) ? placeHolder : "",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }

  Widget getGridWidget() {
    return Flexible(
      child: Column(
        children: getGrid(),
      ),
    );
  }

  List<Widget> getGrid() {
    return List.generate(
      6,
      (rowIndex) => Flexible(
        child: Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (columnIndex) {
                final index = rowIndex * 5 + columnIndex;
                final placeHolder =
                    index < pressedKeys.length ? pressedKeys[index] : "";
                return cell(placeHolder: placeHolder);
              },
            ),
          ),
        ),
      ),
    );
  }
}
