import 'package:flutter/material.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/models/sprite.dart';

class Loop extends Sprite {
  late Point point;
  late Color color;
  late double width;
  late double weight;
  late int counter = 1;

  Loop({
    required this.point,
    this.color = Colors.black,
    this.width = 2,
    this.weight = 1,
  }) : super(x: 0, y: 0);

  void click() {
    counter++;
    if (counter == 5) counter = 1;
  }
}
