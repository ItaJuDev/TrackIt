import 'package:flutter/material.dart';

Color getContrastingTextColor(Color backgroundColor) {
  final brightness = backgroundColor.computeLuminance();
  return brightness > 0.5 ? Colors.black : Colors.white;
}
