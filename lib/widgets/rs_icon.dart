import 'package:flutter/material.dart';

class RSIcon extends StatelessWidget {
  final IconData icon;
  const RSIcon({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      weight: 300,
    );
  }
}
