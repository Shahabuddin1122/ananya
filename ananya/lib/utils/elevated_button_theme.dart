import 'package:flutter/material.dart';
import 'constants.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: SECONDARY_COLOR,
      disabledForegroundColor: Colors.white38,
      disabledBackgroundColor: DISABLE,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      textStyle: const TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: SECONDARY_COLOR,
      disabledForegroundColor: DISABLE,
      disabledBackgroundColor: DISABLE,
      side: const BorderSide(color: SECONDARY_COLOR),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
