import 'package:flutter/cupertino.dart';
import 'package:unbounded/src/components/play_button.dart';

class MenuCarousel extends StatefulWidget {
  const MenuCarousel({Key? key}) : super(key: key);

  @override
  _MenuCarouselState createState() => _MenuCarouselState();
}

class _MenuCarouselState extends State<MenuCarousel> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: const [
          Center(child: PlayButton()),
          Center(child: PlayButton()),
          Center(child: PlayButton()),
          Center(child: PlayButton()),
          Center(child: PlayButton()),
        ]
            .map(
              (child) => SizedBox(
                width: MediaQuery.of(context).size.width,
                child: child,
              ),
            )
            .toList(),
      ),
    );
  }
}
