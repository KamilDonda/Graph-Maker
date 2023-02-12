import 'package:flutter/material.dart';
import 'package:graphs/models/sprite.dart';

class Point extends Sprite {
  late String name;
  late double x;
  late double y;
  late Color color;
  late double size;

  Point({
    required this.name,
    required this.x,
    required this.y,
    required this.color,
    this.size = 120,
  }) : super(x: x, y: y);
}
