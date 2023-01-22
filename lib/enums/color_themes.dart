import 'package:flutter/material.dart';

enum ColorTheme { darkBlue, darkTeal, darkOrange, darkRed, light }

extension ColorText on ColorTheme {
  String toText() {
    switch (this) {
      case ColorTheme.darkBlue:
        return 'Dark blue';
      case ColorTheme.darkTeal:
        return 'Dark teal';
      case ColorTheme.darkOrange:
        return 'Dark orange';
      case ColorTheme.light:
        return 'Light';
      case ColorTheme.darkRed:
        return 'Dark red';

    }
  }
}

extension ToColor on ColorTheme {
  Color toColor() {
    switch (this) {
      case ColorTheme.darkBlue:
        return Colors.blueAccent;
      case ColorTheme.darkTeal:
        return Colors.teal;
      case ColorTheme.darkOrange:
        return Colors.deepOrangeAccent;
      case ColorTheme.light:
        return Colors.white;
      case ColorTheme.darkRed:
        return Colors.redAccent;

    }
  }
}
