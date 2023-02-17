import 'package:flutter/material.dart';
import 'package:graphs/models/sprite.dart';

class Edge extends Sprite {
  late Color color;
  late double width;
  late double weight;

  Edge() : super(x: 0, y: 0);
}
