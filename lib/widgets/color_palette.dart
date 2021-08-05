import 'package:flutter/material.dart';

class ColorPalette extends StatelessWidget {
  final Function onTap;
  final Color color;
  final bool isSelected;

  const ColorPalette({Key? key, required this.onTap, required this.color, required this.isSelected})
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
            child: isSelected ? Icon(Icons.check) : Container(),
      ),
      onTap: () => onTap(),
    );
  }
}
