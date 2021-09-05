import 'package:flutter/material.dart';

enum AppThemes {
  darkPurple,
  darkBlue,
  lightBlue,
  lightPurple,
}

final kThemes = <AppThemes, ThemeData>{
  AppThemes.darkBlue: ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Color(0xFF030303),
    colorScheme: ColorScheme(
      primary: Colors.blue.withOpacity(.3),
      primaryVariant: Colors.blue[200]!.withOpacity(.4),
      secondary: Colors.blue.withOpacity(.3),
      secondaryVariant: Colors.blueAccent.withOpacity(.3),
      surface: Colors.blue.withOpacity(.15),
      background: Colors.blue.withOpacity(.1),
      error: Colors.blue.withOpacity(.2).withRed(50),
      onPrimary: Colors.blue,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      brightness: Brightness.dark,
    ),
  ),
  AppThemes.darkPurple: ThemeData.dark(),
  AppThemes.lightBlue: ThemeData.light(),
  AppThemes.lightPurple: ThemeData.light(),
};
