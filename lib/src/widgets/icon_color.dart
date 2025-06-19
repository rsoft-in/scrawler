import 'package:flutter/material.dart';

class IconColorBasedOnBackground extends StatelessWidget {
  final Color backgroundColor;
  final IconData iconData;

  const IconColorBasedOnBackground(
      {super.key, required this.backgroundColor, required this.iconData});

  // Function to determine whether the background color is light or dark
  bool isLightColor(Color color) {
    // Calculate the luminance of the color
    double luminance = color.computeLuminance();
    return luminance >
        0.5; // if luminance is greater than 0.5, it's a light color
  }

  @override
  Widget build(BuildContext context) {
    // Determine icon color based on background color brightness
    Color iconColor =
        isLightColor(backgroundColor) ? Colors.black : Colors.white;

    return Icon(
      iconData,
      color: iconColor,
    );
  }
}
