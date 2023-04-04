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
  Map<String, Color> solutionMap = {};
  Map<String, Color> solutionMapForKeyboard = {};
  List<Color> gridMap = initGridMap();
  bool isGameOver = false;
  bool didWin = false;

  // String wordSolution = getRandomWord().toUpperCase();
  String wordSolution = "FERRY";
  int preventBackspace = 0;
  final int lastIndex = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(gameTitle),
          centerTitle: true,
        ),
        body: Container(
          color: backgroundColor,
          child: Column(
              children: [getGridWidget(), displayMessage(), getKeyboard()]),
        ));
  }

  Widget displayMessage() {
    return Flexible(
        flex: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isGameOver ? (didWin ? WIN_MSG : SRY_MESSAGE) : "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            isGameOver
                ? (didWin
                    ? const Icon(Icons.favorite, color: correctColor)
                    : const Icon(Icons.heart_broken, color: redColor))
                : Container()
          ],
        ));
  }

  Widget getKeyboard() {
    return Flexible(
      flex: 1,
      child: Padding(
          padding: gridPadding,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: allKeys.map((row) => getKeyboardRow(row)).toList(),
          )),
    );
  }

  Widget getKeyboardRow(List<String> row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row.map((key) => getKeyboardKey(key)).toList(),
    );
  }

  Widget getKeyboardKey(String key) {
    const transparentColor = Colors.transparent;
    const defaultColor = Colors.blueGrey;

    Widget child;
    if (key == '🠔') {
      child = backspaceKey;
    } else if (key == '⏎') {
      child = returnKey;
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
          color: key == '🠔' || key == '⏎'
              ? transparentColor
              : solutionMapForKeyboard.containsKey(key)
                  ? solutionMapForKeyboard[key]
                  : defaultColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              switch (key) {
                case '🠔':
                  pressedKeys.isNotEmpty
                      ? preventBackspace < pressedKeys.length
                          ? pressedKeys.removeLast()
                          : null
                      : null;
                  break;
                case '⏎':
                  {
                    if (isGameOver) {
                      return;
                    }
                    if ((pressedKeys.length) % 5 != 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(NOT_ENOUGH_WORDS),
                      ));
                    } else {
                      String pressedWord = pressedKeys
                          .sublist(pressedKeys.length - 5, pressedKeys.length)
                          .join();
                      if (!isValidWord(pressedWord)) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(INVALID_WORD),
                        ));
                      } else {
                        // The entered word is valid
                        preventBackspace = pressedKeys.length;
                        int startIndex = preventBackspace - 5;
                        isGameOver = checkSolution(wordSolution, pressedWord,
                            gridMap, startIndex, solutionMapForKeyboard);
                        didWin = isGameOver;
                        if (startIndex == lastIndex) {
                          if (!isGameOver) {
                            isGameOver = true;
                          }
                        }
                      }
                    }
                  }
                  break;
                default:
                  if (!isGameOver &&
                      (pressedKeys.length % 5 != 0 ||
                          pressedKeys.isEmpty ||
                          pressedKeys.length == preventBackspace)) {
                    pressedKeys.add(key);
                  }
                  break;
              }
            });
          },
          child: child,
        ),
      ),
    );
  }

  Widget cell(int currentCellIndex, {String placeHolder = ''}) {
    return Flexible(
      child: Container(
        height: 44,
        width: 44,
        margin: const EdgeInsets.only(right: 8.0),
        color: gridMap[currentCellIndex],
        child: Center(
          child: Text(
            pressedKeys.contains(placeHolder) ? placeHolder : "",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget getGridWidget() {
    return Flexible(
      flex: 1,
      child: Padding(
          padding: gridPadding,
          child: Column(
            children: getGrid(),
          )),
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
                return cell(index, placeHolder: placeHolder);
              },
            ),
          ),
        ),
      ),
    );
  }
}
