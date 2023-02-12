import 'package:flutter/material.dart';
import 'package:graphs/models/point.dart';

class PointWidget extends StatelessWidget {
  PointWidget({super.key, required this.point});

  final Point point;
  late double size = 120;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: point.y,
      left: point.x,
      child: GestureDetector(
        onPanUpdate: (position) {
          point.x += position.delta.dx;
          point.y += position.delta.dy;
        },
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: point.color,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
              width: 5,
            ),
          ),
          child: Text(point.name, style: const TextStyle(fontSize: 50)),
        ),
      ),
    );
  }
}
