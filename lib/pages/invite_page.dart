import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordle_infinity/constants/all_words.dart';
import 'package:wordle_infinity/pages/game_page.dart';

import '../constants/constants.dart';
import '../constants/game_meta.dart';

class InvitePage extends StatefulWidget {
  static const routeName = "/invite-page";
  const InvitePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InvitePage();
  }
}

class _InvitePage extends State<InvitePage> {
  bool showError = false;
  static String hashValue = "";
  String urlProtocol = "http://";
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!Uri.base.toString().contains("localhost")) {
      urlProtocol = "https://";
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(gameTitle),
          centerTitle: true,
        ),
        body: Container(
            color: backgroundColor,
            child: Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _textEditingController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]+')),
                        LengthLimitingTextInputFormatter(5),
                      ],
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: WRD_PROMPT,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 16.0),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                bool _showError =
                                    !isValidWord(_textEditingController.text);
                                if (!_showError) {
                                  hashValue = encryptInviteCode(
                                      _textEditingController.text,
                                      DateTime.now());
                                }
                                showError = _showError;
                              });
                            },
                            child: const Text(INVITE_BTN))),
                    showError
                        ? Container(
                            margin: const EdgeInsets.only(top: 16.0),
                            child: const Text(
                              INVALID_WORD,
                              style: TextStyle(color: Colors.white),
                            ))
                        : hashValue != ""
                            ? Container(
                                margin: const EdgeInsets.only(top: 16.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text:
                                              "$urlProtocol${Uri.base.host}${GamePage.routeName}?inviteHash=$hashValue"));
                                    },
                                    child: const Text(COPY_LINK_BTN,
                                        style: TextStyle(color: Colors.white))))
                            : Container(),
                  ],
                ))));
  }
}
