import 'package:bnotes/helpers/constants.dart';
import 'package:flutter/material.dart';

class ScrawlButtonFilled extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const ScrawlButtonFilled(
      {Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: kPaddingLarge,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
