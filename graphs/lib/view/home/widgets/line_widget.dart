import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/constants/colors.dart';
import 'package:graphs/constants/sizes.dart';
import 'package:graphs/models/line.dart';
import 'package:graphs/models/position.dart';
import 'package:graphs/view/home/cubit/sprites_cubit.dart';
import 'package:graphs/view/home/widgets/sprite_widget.dart';

class LineWidget extends SpriteWidget {
  const LineWidget({super.key, required this.line}) : super();

  final Line line;

  final bulletSize = DEFAULT_BULLET_SIZE / 2;
  final innerBulletSize = DEFAULT_BULLET_SIZE / 2 - 2;

  Positioned _drawLine(
    Position bg,
    double px,
    double py,
    double a,
    double b,
  ) {
    return Positioned(
      top: py,
      left: px,
      child: Transform.rotate(
        angle: math.atan(a / b),
        alignment: Alignment.topLeft,
        child: Container(
          width: math.sqrt(a * a + b * b),
          height: line.width,
          color: line.color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var background = BlocProvider.of<SpritesCubit>(context).background;
    var areVisible = BlocProvider.of<SpritesCubit>(context).areBulletsVisible();

    var p1x = background.x + line.p1.x + line.p1.size / 2;
    var p1y = background.y + line.p1.y + line.p1.size / 2;
    var p2x = background.x + line.p2.x + line.p2.size / 2;
    var p2y = background.y + line.p2.y + line.p2.size / 2;

    var a = p2y - p1y;
    var b = p2x - p1x;

    var bx = p1x + (b) / 2 + line.p3.x;
    var by = p1y + (a) / 2 + line.p3.y;

    var c = (p1y - by);
    var d = (p1x - bx);
    var e = (p2y - by);
    var f = (p2x - bx);

    if (d >= 0) {
      p1x = bx;
      p1y = by;
    }
    if (bx <= p2x) {
      p2x = bx;
      p2y = by;
    }

    return Stack(
      children: [
        _drawLine(background, p1x, p1y, c, d),
        _drawLine(background, p2x, p2y, e, f),
        if (areVisible)
          Positioned(
            top: by - DEFAULT_BULLET_SIZE / 2,
            left: bx - DEFAULT_BULLET_SIZE / 2,
            child: GestureDetector(
              onSecondaryTap: () {
                BlocProvider.of<SpritesCubit>(context).removeLine(line);
              },
              onTap: () {
                BlocProvider.of<SpritesCubit>(context).resetBullet(line);
              },
              onPanUpdate: (position) {
                BlocProvider.of<SpritesCubit>(context).updateBullet(
                    line, position.delta.dx.toInt(), position.delta.dy.toInt());
              },
              child: CircleAvatar(
                radius: bulletSize,
                backgroundColor: Colors.black,
                child: CircleAvatar(
                  radius: innerBulletSize,
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
          ),
        Positioned(
          top: by - DEFAULT_BULLET_SIZE / 2 + WEIGHT_DISPLACEMENT,
          left: bx - DEFAULT_BULLET_SIZE / 2 + WEIGHT_DISPLACEMENT,
          child: GestureDetector(
            onTap: () {
              BlocProvider.of<SpritesCubit>(context).focusSprite(id: line.id);
            },
            child: CircleAvatar(
              radius: DEFAULT_WEIGHT_SIZE / 2,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: DEFAULT_WEIGHT_SIZE / 2 - 2,
                backgroundColor: backgroundColor,
                child: Text(
                  line.weight.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
