import 'package:flutter/material.dart';

class DSearchPage extends StatefulWidget {
  const DSearchPage({Key? key}) : super(key: key);

  @override
  _DSearchPageState createState() => _DSearchPageState();
}

class _DSearchPageState extends State<DSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Search'),
      ),
    );
  }
}
