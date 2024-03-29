// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

import '../models/invite_code.dart';

const String APP_NAME = "wordle-infinity";

const margin_10 = EdgeInsets.only(top: 10);
const margin_35 = EdgeInsets.all(35.0);
const String title = "WORDLE INFINITY";

const NOT_ENOUGH_WORDS = "Not Enough letters!";
const INVALID_WORD = "Not a valid word!";
const WRD_PROMPT = "Enter a 5-letter word";

const SRY_MESSAGE = "SORRY YOU LOST ";
const WIN_MSG = "YOU WIN ";
const INVITE_BTN = "GENERATE LINK";
const COPY_LINK_BTN = "COPY LINK";
final RegExp WRD_VALIDATOR = RegExp(r'^[a-zA-Z]{5}$');
const SECRET_KEY_B64 = "6tQhkEy60WYg5WV/O7gXxokR3FkEtAZlNOUhfaVRmuw=";
const INVITE_MODE = "INVITE MODE";
const INVITE_EXPIRED = "Invite Expired!";
const DAILY_MODE = "DAILY Mode";
const INFINITE_MODE = "INFINITE Mode";

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
  return isSolved(userWord, solution);
}

bool isSolved(String userWord, String solution) {
  for (int index = 0; index < 5; index++) {
    if (userWord[index] != solution[index]) {
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

bool isInviteExpired(DateTime inviteDateTime) {
  return DateTime.now().difference(inviteDateTime).inMinutes > 180;
}

InviteCode decryptInvite(String encryptedText) {
  final key = encrypt.Key.fromBase64(SECRET_KEY_B64);
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  String decrypted =
      encrypter.decrypt(encrypt.Encrypted.fromBase16(encryptedText), iv: iv);
  InviteCode decryptedCode = InviteCode.fromJson(json.decode(decrypted));
  return decryptedCode;
}

String encryptInviteCode(String word, DateTime createDateTime) {
  final jsonString =
      json.encode({'word': word, 'dateTime': createDateTime.toString()});

  final key = encrypt.Key.fromBase64(SECRET_KEY_B64);
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  final encrypted = encrypter.encrypt(jsonString, iv: iv);
  return encrypted.base16;
}

const correctColor = Colors.lightGreen;
const purpleColor = Colors.purple;
const defaultColor = Colors.blueGrey;
const wrongColor = Color.fromARGB(255, 43, 43, 43);
const partiallyCorrectColor = Colors.amber;
const redColor = Colors.redAccent;
const backgroundColor = Color.fromARGB(255, 0, 30, 60);
