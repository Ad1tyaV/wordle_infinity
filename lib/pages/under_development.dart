import 'package:flutter/material.dart';

class UnderDevelopment extends StatefulWidget {
  const UnderDevelopment({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UnderDevelopment();
  }
}

class _UnderDevelopment extends State<UnderDevelopment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Under development"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Expanded(child: BlueBox()), BlueBox(), BlueBox()],
        ),
      ),
    );
  }
}

class BlueBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(),
      ),
    );
  }
}
