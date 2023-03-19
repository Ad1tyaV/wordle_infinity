import 'package:flutter/material.dart';

const margin_10 = EdgeInsets.only(top: 10);
const margin_35 = EdgeInsets.all(35.0);

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

const keyboard = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['🠔', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '⏎']
];

const backspace_key = Icon(Icons.backspace_outlined, color: Colors.blueGrey);

const return_key = Icon(Icons.keyboard_return, color: Colors.blueGrey);

Widget getKeyboard() {
  return Column(
    children: keyboard
        .map(
          (row) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row
                .map(
                  (key) => Flexible(
                    child: key == '🠔'
                        ? Container(
                            margin: const EdgeInsets.only(right: 8.0),
                            height: 44,
                            child: backspace_key)
                        : key == '⏎'
                            ? Container(
                                margin: const EdgeInsets.only(right: 8.0),
                                height: 44,
                                child: return_key)
                            : Container(
                                height: 44,
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // handle key press
                                  },
                                  child: Text(
                                    key,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                  ),
                )
                .toList(),
          ),
        )
        .toList(),
  );
}

const topPadding = EdgeInsets.all(30.5);

double getBlockSize(double currentSize) {
  if (currentSize <= 337) {
    return 40.4;
  } else {
    return 50.3;
  }
}

List<List<Text>> grid = List.generate(
    6, (rowIndex) => List.generate(5, (columnIndex) => const Text("")));

Widget getGridWidget() {
  return Expanded(
      child: Column(
    children: getGrid(),
  ));
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
                (columnIndex) => tempCell(),
              ),
            ))),
  );
}

const correctColor = Colors.lightGreen;
const wrongColor = Colors.blueGrey;
const defaultColor = Colors.amber;

Widget tempCell({String placeHolder = ''}) {
  return Flexible(
    child: Container(
      height: 44,
      width: 44,
      margin: const EdgeInsets.only(right: 8.0),
      color: Colors.blueGrey,
      child: Center(
        child: Text(
          placeHolder,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    ),
  );
}
