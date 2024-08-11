import 'package:flutter/material.dart';

extension CustomThemeData on ThemeData {
  EdgeInsets get defaultPadding => const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 5,
      );
  EdgeInsets get largemainPadding => const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 5.0,
      );
  EdgeInsets get largeHorizontalAndVerticalPadding =>
      const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 25.0,
      );
  EdgeInsets get sectionDividerPadding => const EdgeInsets.symmetric(
        vertical: 15.0,
      );
  EdgeInsets get subSectionDividerPadding => const EdgeInsets.symmetric(
        vertical: 10.0,
      );
  EdgeInsets get insideCardPadding => const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      );
  double get buttonTextSize => 18.0;
}
