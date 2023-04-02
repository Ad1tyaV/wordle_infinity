import 'package:flutter/material.dart';

const margin_10 = EdgeInsets.only(top: 10);
const margin_35 = EdgeInsets.all(35.0);

const NOT_ENOUGH_WORDS = "Not Enough letters!";
const INVALID_WORD = "Not a valid word!";

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

const backspace_key = Icon(Icons.backspace_outlined, color: Colors.blueGrey);

const return_key = Icon(Icons.keyboard_return, color: Colors.blueGrey);

const topPadding = EdgeInsets.all(30.5);

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

Map<String, Color> checkSolution(String solution, String userWord) {
  Map<String, Color> solutionMap = {};
  Map<String, int> solutionDictionary = getDictionary(solution);
  Map<String, int> userDictionary = getDictionary(userWord);

  for (int index = 0; index < 5; index++) {
    String solutionLetter = solution[index];
    String userLetter = userWord[index];
    if (solution[index] == userWord[index]) {
      solutionDictionary[solutionLetter] =
          solutionDictionary[solutionLetter]! - 1;
      userDictionary[solutionLetter] = userDictionary[solutionLetter]! - 1;
      solutionMap[userLetter] = correctColor;
    } else {
      solutionMap[userLetter] = wrongColor;
    }
  }

  for (int index = 0; index < 5; index++) {
    String currentLetter = userWord[index];
    if (solutionMap[currentLetter] != correctColor) {
      if (solutionDictionary.containsKey(currentLetter) &&
          solutionDictionary[currentLetter]! > 0) {
        solutionMap[currentLetter] = partiallyCorrectColor;
      }
    }
  }
  return solutionMap;
}

List<List<Text>> grid = List.generate(
    6, (rowIndex) => List.generate(5, (columnIndex) => const Text("")));

const correctColor = Colors.lightGreen;
const defaultColor = Colors.blueGrey;
const wrongColor = Color.fromARGB(255, 43, 43, 43);
const partiallyCorrectColor = Colors.amber;
