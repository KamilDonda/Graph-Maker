import 'package:flutter/material.dart';
import 'package:graphs/models/sprite.dart';

class Line extends Sprite {
  late double x1;
  late double y1;
  late double x2;
  late double y2;
  late Color color;
  late double width;

  Line({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    this.color = Colors.black,
    this.width = 2,
  }) : super(x: 0.0, y: 0.0);
}
