import 'package:flutter/material.dart';

class TestHomePage extends StatefulWidget {

  const TestHomePage({super.key, required this.title});
  final String title;

  @override
  State<StatefulWidget> createState() => _TestHomePage();
}

class _TestHomePage extends State<TestHomePage> {

  late List<List<String>> grid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Grid Placeholder',
            ),
            Text(
              '| |',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      )
    );
  }

}