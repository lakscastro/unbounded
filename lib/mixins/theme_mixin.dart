import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

mixin ThemeMixin<T extends StatefulWidget> on State<T> {
  Color get scaffoldBackgroundColor =>
      Theme.of(context).scaffoldBackgroundColor;
}
