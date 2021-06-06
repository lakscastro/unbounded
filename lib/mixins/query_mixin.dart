import 'package:flutter/cupertino.dart';

mixin QueryMixin<T extends StatefulWidget> on State<T> {
  double get deviceWidth => MediaQuery.of(context).size.width;
  double get deviceHeight => MediaQuery.of(context).size.height;
}
