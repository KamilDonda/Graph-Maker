import 'package:flutter/material.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/models/sprite.dart';

class Line extends Sprite {
  late Point p1;
  late Point p2;
  late Color color;
  late double width;

  Line({
    required this.p1,
    required this.p2,
    this.color = Colors.black,
    this.width = 2,
  }) : super(x: 0.0, y: 0.0);
}
