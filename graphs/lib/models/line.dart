import 'package:flutter/material.dart';
import 'package:graphs/models/edge.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/models/position.dart';

class Line extends Edge {
  late Point p1;
  late Point p2;
  late Position p3 = Position();
  late Color color;
  late double width;
  late double weight;
  late int timestamp = 0;

  Line({
    required this.p1,
    required this.p2,
    this.color = Colors.black,
    this.width = 2,
    this.weight = 1,
  }) : super();
}
