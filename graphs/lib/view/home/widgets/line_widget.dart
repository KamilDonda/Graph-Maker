import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graphs/models/line.dart';
import 'package:graphs/view/home/widgets/sprite_widget.dart';

class LineWidget extends SpriteWidget {
  const LineWidget({super.key, required this.line}) : super(sprite: line);

  final Line line;

  @override
  Widget build(BuildContext context) {
    var x1 = line.p1.x + line.p1.size / 2;
    var x2 = line.p2.x + line.p2.size / 2;
    var y1 = line.p1.y + line.p1.size / 2;
    var y2 = line.p2.y + line.p2.size / 2;

    if (x2 < x1) {
      var xt = x1;
      x1 = x2;
      x2 = xt;

      var yt = y1;
      y1 = y2;
      y2 = yt;
    }

    var a = y2 - y1;
    var b = x2 - x1;
    var tan = a / b;
    var degrees = math.atan(tan);

    return Positioned(
      top: y1,
      left: x1,
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
