import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  final Widget? child;

  const Background({Key? key, this.child}) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: widget.child,
    );
  }
}
