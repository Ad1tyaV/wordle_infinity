import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:wordle_infinity/pages/game_page.dart';

String game_title = "WORDLE INFINITY";
List<String> menu_items = ["PLAY", "STATS", "OPTIONS", "DevNotes"];

Map<String, Widget> routeResolver = {
  "PLAY": const GamePage(),
  "STATS": const GamePage(),
  "OPTIONS": const GamePage(),
  "DevNotes": const GamePage(),
};

const keyboard = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['🠔', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '⏎']
];
