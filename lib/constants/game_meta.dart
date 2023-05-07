import 'package:flutter/material.dart';
import 'package:wordle_infinity/pages/game_page.dart';
import 'package:wordle_infinity/pages/invite_page.dart';
import 'package:wordle_infinity/pages/under_development.dart';

String gameTitle = "WORDLE INFINITY";
List<String> menuItems = ["PLAY", "INVITE", "OPTIONS", "DevNotes"];

Map<String, Widget> routeResolver = {
  "PLAY": const GamePage(inviteCode: ''),
  "INVITE": const InvitePage(),
  "OPTIONS": const UnderDevelopment(),
  "DevNotes": const UnderDevelopment(),
};

const keyboard = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['🠔', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '⏎']
];
