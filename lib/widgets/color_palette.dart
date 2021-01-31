import 'package:flutter/material.dart';

class ColorPalette extends StatelessWidget {
  final Function onTap;
  final Color color;

  const ColorPalette({Key key, this.onTap, @required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: new Container(
        margin: EdgeInsets.all(8.0),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: this.color,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.black26)),
      ),
      onTap: onTap,
    );
  }
}
