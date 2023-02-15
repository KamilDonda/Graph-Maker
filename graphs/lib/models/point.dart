import 'package:flutter/material.dart';
import 'package:graphs/constants/sizes.dart';
import 'package:graphs/models/sprite.dart';

class Point extends Sprite {
  late String name;
  late int x;
  late int y;
  late Color color;
  late double size;
  late List<int> neighbors_ids = <int>[];

  Point({
    required this.name,
    required this.x,
    required this.y,
    required this.color,
    this.size = DEFAULT_POINT_SIZE,
  }) : super(x: x, y: y);
}
