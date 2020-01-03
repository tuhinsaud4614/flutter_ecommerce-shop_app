import 'package:flutter/material.dart';

class CustomTheme with ChangeNotifier {
  Brightness _brightness = Brightness.light;

  Brightness get brightness {
    final Brightness newBrightness = _brightness;
    return newBrightness;
  }

  set setDark(bool shouldChange) {
    if (shouldChange) {
      _brightness = Brightness.dark;
    } else {
      _brightness = Brightness.light;
    }
    notifyListeners();
  }
}
