import 'package:flutter/material.dart';
import 'color_constants.dart';

class ThemeConstants {
  static final ThemeData themeData = ThemeData(
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ColorConstants.primaryColor,
      selectionHandleColor: ColorConstants.primaryColor,
      selectionColor: ColorConstants.accentColor,
    ),
  );
}
