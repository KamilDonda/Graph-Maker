import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graphs/models/line.dart';
import 'package:graphs/view/home/widgets/sprite_widget.dart';

class LineWidget extends SpriteWidget {
  const LineWidget({super.key, required this.line}) : super(sprite: line);

  final Line line;

  @override
  Widget build(BuildContext context) {
    var a = line.y2 - line.y1;
    var b = line.x2 - line.x1;
    var tan = a / b;
    var degrees = math.atan(tan);

    return Positioned(
      top: line.y1,
      left: line.x1,
      child: Transform.rotate(
        angle: degrees,
        alignment: Alignment.topLeft,
        child: Container(
          width: math.sqrt(b * b + a * a),
          height: line.width,
          color: line.color,
        ),
      ),
    );
  }
}
