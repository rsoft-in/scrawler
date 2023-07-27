import 'package:flutter/material.dart';

class MobileTasksPage extends StatefulWidget {
  const MobileTasksPage({Key? key}) : super(key: key);

  @override
  State<MobileTasksPage> createState() => _MobileTasksPageState();
}

class _MobileTasksPageState extends State<MobileTasksPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
