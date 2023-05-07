import 'package:flutter/material.dart';
import 'package:wordle_infinity/pages/game_page.dart';
import 'package:wordle_infinity/pages/invite_page.dart';
import 'package:wordle_infinity/pages/main_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'constants/constants.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      initialRoute: '/',
      onGenerateRoute: (_) {
        Uri currentUrl = Uri.base;
        if (currentUrl.toString().contains(GamePage.routeName)) {
          String inviteCode;
          try {
            inviteCode = currentUrl.queryParameters["inviteHash"].toString();
          } catch (e) {
            inviteCode = "";
          }
          return MaterialPageRoute(builder: (context) {
            return GamePage(inviteCode: inviteCode);
          });
        } else if (currentUrl.toString().contains(InvitePage.routeName)) {
          return MaterialPageRoute(builder: (context) {
            return const InvitePage();
          });
        } else {
          return MaterialPageRoute(builder: (context) {
            return const MainPage();
          });
        }
      },
    );
  }
}
