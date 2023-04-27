// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const margin_10 = EdgeInsets.only(top: 10);
const margin_35 = EdgeInsets.all(35.0);
const BACKSPACE_KEY = 4294967304;
const ENTER_KEY = 4294967309;
const String title = "WORDLE INFINITY";

const NOT_ENOUGH_WORDS = "Not Enough letters!";
const INVALID_WORD = "Not a valid word!";

const SRY_MESSAGE = "SORRY YOU LOST ";
const WIN_MSG = "YOU WON ";

EdgeInsets edgeInsetsAll(double edgeInsetValue) {
  return EdgeInsets.all(edgeInsetValue);
}

Size getKeyboardSize(double width, double height) {
  if (width >= 541) {
    return const Size(44, 44);
  } else if (width >= 373 && width < 541) {
    return const Size(35, 57);
  } else {
    return const Size(30, 30);
  }
}

Container seperator(double height) {
  return Container(
    margin: EdgeInsets.all(height >= 541.0 ? 27.6 : 16.1),
  );
}

const allKeys = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['🠔', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '⏎']
];

const backspaceKey = Icon(Icons.backspace_outlined, color: Colors.blueGrey);

const returnKey = Icon(Icons.keyboard_return, color: Colors.blueGrey);

const topPadding = EdgeInsets.all(30.5);

const gridPadding = EdgeInsets.only(top: 18.8);

double getBlockSize(double currentSize) {
  if (currentSize <= 337) {
    return 40.4;
  } else {
    return 50.3;
  }
}

Map<String, int> getDictionary(String word) {
  Map<String, int> dictionary = {};
  for (int i = 0; i < word.length; i++) {
    String letter = word[i];
    dictionary[letter] ??= 0;
    dictionary[letter] = dictionary[letter]! + 1;
  }
  return dictionary;
}

bool checkSolution(String solution, String userWord, List<Color> solutionMap,
    int startIndex, Map<String, Color> solutionMapForKeyboard) {
  Map<String, int> solutionDictionary = getDictionary(solution);
  Map<String, int> userDictionary = getDictionary(userWord);

  for (int index = 0; index < 5; index++) {
    // Only check for equals and paint board green
    if (userWord[index] == solution[index]) {
      String solutionLetter = userWord[index];
      solutionMap[startIndex + index] = correctColor;
      solutionDictionary[solutionLetter] =
          solutionDictionary[solutionLetter]! - 1;
      userDictionary[solutionLetter] = userDictionary[solutionLetter]! - 1;
    }
  }

  for (int index = 0; index < 5; index++) {
    String userLetter = userWord[index];
    if (userWord[index] != solution[index]) {
      if (solutionDictionary.containsKey(userLetter)) {
        if (solutionDictionary[userLetter]! > 0) {
          solutionMap[startIndex + index] = partiallyCorrectColor;
          solutionDictionary[userLetter] = solutionDictionary[userLetter]! - 1;

          solutionMapForKeyboard[userLetter] =
              (solutionMapForKeyboard[userLetter] == partiallyCorrectColor ||
                      solutionMapForKeyboard[userLetter] == correctColor)
                  ? solutionMapForKeyboard[userLetter]!
                  : partiallyCorrectColor;
        } else {
          solutionMap[startIndex + index] = wrongColor;
          solutionMapForKeyboard[userLetter] =
              (solutionMapForKeyboard[userLetter] == partiallyCorrectColor ||
                      solutionMapForKeyboard[userLetter] == correctColor)
                  ? solutionMapForKeyboard[userLetter]!
                  : wrongColor;
        }
      } else {
        solutionMap[startIndex + index] = wrongColor;
        solutionMapForKeyboard[userLetter] =
            (solutionMapForKeyboard[userLetter] == partiallyCorrectColor ||
                    solutionMapForKeyboard[userLetter] == correctColor)
                ? solutionMapForKeyboard[userLetter]!
                : wrongColor;
      }
    } else {
      solutionMapForKeyboard[userLetter] = correctColor;
    }
  }

  return isSolved(userWord, solutionMapForKeyboard);
}

bool isSolved(String userWord, Map<String, Color> solutionMapForKeyboard) {
  for (int index = 0; index < 5; index++) {
    if (solutionMapForKeyboard[userWord[index]] != correctColor) {
      return false;
    }
  }
  return true;
}

List<List<Text>> grid = List.generate(
    6, (rowIndex) => List.generate(5, (columnIndex) => const Text("")));

List<Color> initGridMap() {
  return List.generate(30, (index) => defaultColor);
}

const correctColor = Colors.lightGreen;
const defaultColor = Colors.blueGrey;
const wrongColor = Color.fromARGB(255, 43, 43, 43);
const partiallyCorrectColor = Colors.amber;
const redColor = Colors.redAccent;
const backgroundColor = Color.fromARGB(255, 0, 30, 60);
