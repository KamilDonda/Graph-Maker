import 'package:flutter/material.dart';
import 'package:graphs/models/loop.dart';
import 'package:graphs/view/home/widgets/sprite_widget.dart';

class LoopWidget extends SpriteWidget {
  const LoopWidget({super.key, required this.loop}) : super(sprite: loop);

  final Loop loop;

  @override
  Widget build(BuildContext context) {
    final displacement = loop.point.size * 0.75;
    final size = loop.point.size * 1.75;
    final radius = loop.point.size * 1.5;
    return Positioned(
      top: loop.point.y - displacement,
      left: loop.point.x - displacement,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(loop.point.size),
            bottomLeft: Radius.circular(loop.point.size),
            bottomRight: Radius.circular(radius),
          ),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
    );
  }
}
