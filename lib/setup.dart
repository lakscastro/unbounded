import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

Future<void> setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIOverlays([]);
}
