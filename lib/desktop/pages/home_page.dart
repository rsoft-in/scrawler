import 'package:flutter/material.dart';

class DHomePage extends StatefulWidget {
  const DHomePage({Key? key}) : super(key: key);

  @override
  _DHomePageState createState() => _DHomePageState();
}

class _DHomePageState extends State<DHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Notes'),
      ),
    );
  }
}
