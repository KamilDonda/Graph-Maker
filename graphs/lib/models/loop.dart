import 'package:flutter/material.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/models/sprite.dart';

class Loop extends Sprite {
  late Point point;
  late Color color;
  late double width;
  late int counter = 0;

  Loop({
    required this.point,
    this.color = Colors.black,
    this.width = 2,
  }) : super(x: 0.0, y: 0.0);

  void click() {
    counter++;
    if (counter == 4) counter = 0;
  }
}
