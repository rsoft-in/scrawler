import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyWidget extends StatelessWidget {
  final String text;
  final double width;
  const EmptyWidget(
      {super.key, required this.text, required this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'images/undraw_random-thoughts_goca.svg',
            width: width,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
