import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/constants/sizes.dart';
import 'package:graphs/models/line.dart';
import 'package:graphs/view/home/cubit/points_cubit.dart';
import 'package:graphs/view/home/widgets/sprite_widget.dart';

class LineWidget extends SpriteWidget {
  const LineWidget({super.key, required this.line}) : super();

  final Line line;

  final bulletSize = DEFAULT_BULLET_SIZE / 2;
  final innerBulletSize = DEFAULT_BULLET_SIZE / 2 - 2;

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
    var background = BlocProvider.of<PointsCubit>(context).background;
    var areVisible = BlocProvider.of<PointsCubit>(context).areBulletsVisible();
    return Stack(
      children: [
        Positioned(
          top: background.y + y1,
          left: background.x + x1,
          child: Transform.rotate(
            angle: degrees,
            alignment: Alignment.topLeft,
            child: Container(
              width: math.sqrt(b * b + a * a),
              height: line.width,
              color: line.color,
            ),
          ),
        ),
        if (areVisible)
          Positioned(
            top: background.y + y1 + (a - DEFAULT_BULLET_SIZE) / 2 + line.p3.y,
            left: background.x + x1 + (b - DEFAULT_BULLET_SIZE) / 2 + line.p3.x,
            child: GestureDetector(
                onSecondaryTap: () {
                  BlocProvider.of<PointsCubit>(context).removeLine(line);
                },
                onTap: () {
                  print(
                      "x: ${background.x + x1 + (b - DEFAULT_BULLET_SIZE) / 2 + line.p3.x}, y: ${background.y + y1 + (a - DEFAULT_BULLET_SIZE) / 2 + line.p3.y}");
                },
                onPanUpdate: (position) {
                  BlocProvider.of<PointsCubit>(context).updateBullet(line,
                      position.delta.dx.toInt(), position.delta.dy.toInt());
                },
                child: CircleAvatar(
                  radius: bulletSize,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: innerBulletSize,
                    backgroundColor: Colors.grey,
                  ),
                )),
          ),
      ],
    );
  }
}
