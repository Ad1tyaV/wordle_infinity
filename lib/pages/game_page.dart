import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordle_infinity/constants/all_words.dart';
import 'package:wordle_infinity/constants/constants.dart';

import '../constants/game_meta.dart';
import '../models/invite_code.dart';

class GamePage extends StatefulWidget {
  static const routeName = "/game-page";
  final String inviteCode;

  const GamePage({super.key, required this.inviteCode});

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
  final FocusNode _focusNode = FocusNode();
  String wordSolution = getTodaysWord().toUpperCase();
  String gameMode = DAILY_MODE;

  @override
  void initState() {
    super.initState();
    if (widget.inviteCode != "" || widget.inviteCode.isNotEmpty) {
      InviteCode decryptedCode = decryptInvite(widget.inviteCode);
      String inviteeWord = decryptedCode.word;
      bool isInviteActive = !isInviteExpired(decryptedCode.dateTime);
      if (isInviteActive) {
        gameMode = INVITE_MODE;
      } else {
        gameMode = INVITE_EXPIRED;
      }
      if (inviteeWord != "" && isValidWord(inviteeWord) && isInviteActive) {
        wordSolution = inviteeWord.toUpperCase();
      }
    }

    _focusNode.requestFocus();
  }

  int preventBackspace = 0;
  final int lastIndex = 25;

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyUpEvent) {
          setState(() {
            if ((event.logicalKey.keyId >= 97 &&
                    event.logicalKey.keyId <= 122) ||
                (event.logicalKey.keyId >= 65 &&
                    event.logicalKey.keyId <= 90)) {
              // Handle alphabet
              String letter = String.fromCharCode(event.logicalKey.keyId);
              if (!isGameOver &&
                  (pressedKeys.length % 5 != 0 ||
                      pressedKeys.isEmpty ||
                      pressedKeys.length == preventBackspace)) {
                pressedKeys.add(letter.toUpperCase());
              }
            } else if (event.logicalKey.keyId == 4294967309) {
              // Handle enter
              if (isGameOver) {
                return;
              }
              if (pressedKeys.isEmpty || (pressedKeys.length) % 5 != 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(NOT_ENOUGH_WORDS),
                ));
              } else {
                String pressedWord = pressedKeys
                    .sublist(pressedKeys.length - 5, pressedKeys.length)
                    .join();
                if (!isValidWord(pressedWord)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(INVALID_WORD),
                  ));
                } else {
                  // The entered word is valid
                  preventBackspace = pressedKeys.length;
                  int startIndex = preventBackspace - 5;
                  isGameOver = checkSolution(wordSolution, pressedWord, gridMap,
                      startIndex, solutionMapForKeyboard);
                  didWin = isGameOver;
                  if (startIndex == lastIndex) {
                    if (!isGameOver) {
                      isGameOver = true;
                    }
                  }
                }
              }
            } else if (event.logicalKey.keyId == 4294967304) {
              // Handle backspace
              pressedKeys.isNotEmpty
                  ? preventBackspace < pressedKeys.length
                      ? pressedKeys.removeLast()
                      : null
                  : null;
            }
          });
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(gameTitle),
            centerTitle: true,
          ),
          body: Container(
            color: backgroundColor,
            child: Column(children: [
              gameTypeMessage(),
              getGridWidget(),
              displayMessage(),
              getKeyboard()
            ]),
          )),
    );
  }

  Widget gameTypeMessage() {
    return Flexible(
        flex: 0,
        child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  gameMode,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ],
            )));
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
                    ? const Icon(Icons.favorite, color: purpleColor)
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
                    if (pressedKeys.isEmpty || (pressedKeys.length) % 5 != 0) {
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
