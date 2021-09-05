import 'package:flutter/material.dart';
import 'package:unbounded/screens/menu/menu_screen.dart';
import 'package:unbounded/setup.dart';
import 'package:unbounded/theme.dart';

Future<void> main() async {
  await setupApp();

  runApp(UnboundedApp());
}

class UnboundedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: kThemes[AppThemes.darkBlue],
      home: MenuScreen(),
    );
  }
}
