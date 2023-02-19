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

  Positioned _drawArrow(
    Position bg,
    double bx,
    double by,
  ) {
    var px = bg.x + line.p2.x + line.p2.size / 2;
    var py = bg.y + line.p2.y + line.p2.size / 2;

    var a = py - by;
    var b = px - bx;

    var radians = math.atan(a / b);
    var dist = math.sqrt(a * a + b * b) - DEFAULT_POINT_SIZE;
    var n = 1;

    if (bx <= px) {
      n = -1;
    }

    var xx = bx - (dist * math.cos(radians)) * n;
    var yy = by - (dist * math.sin(radians)) * n;

    return Positioned(
      top: yy - ARROW_SIZE / 2,
      left: xx - ARROW_SIZE / 2,
      child: const CircleAvatar(
        radius: ARROW_SIZE / 2,
        backgroundColor: Colors.black,
      ),
    );
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    BlocProvider.of<SpritesCubit>(context).focusSprite(id: line.id);

    if (currentTime - line.timestamp < 300) {
      BlocProvider.of<SpritesCubit>(context).resetBullet(line);
    }
    line.timestamp = currentTime;
  }

  @override
  Widget build(BuildContext context) {
    var background = BlocProvider.of<SpritesCubit>(context).background;
    var areVisible = BlocProvider.of<SpritesCubit>(context).areWeightsVisible();

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

    bool isFocused =
        BlocProvider.of<SpritesCubit>(context).getFocusedID() == line.id;

    return Stack(
      children: [
        _drawLine(background, p1x, p1y, c, d),
        _drawLine(background, p2x, p2y, e, f),
        _drawArrow(background, bx, by),
        if (areVisible)
          Positioned(
            top: by - DEFAULT_WEIGHT_SIZE / 2,
            left: bx - DEFAULT_WEIGHT_SIZE / 2,
            child: GestureDetector(
              onTapDown: (details) {
                onTapDown(context, details);
              },
              onPanStart: (details) {
                BlocProvider.of<SpritesCubit>(context).focusSprite(id: line.id);
              },
              onSecondaryTap: () {
                BlocProvider.of<SpritesCubit>(context).removeEdge(line);
              },
              onPanUpdate: (position) {
                BlocProvider.of<SpritesCubit>(context).updateBullet(
                    line, position.delta.dx.toInt(), position.delta.dy.toInt());
              },
              child: CircleAvatar(
                radius: DEFAULT_WEIGHT_SIZE / 2,
                backgroundColor: Colors.black,
                child: CircleAvatar(
                  radius: isFocused
                      ? DEFAULT_WEIGHT_SIZE / 2 - 4
                      : DEFAULT_WEIGHT_SIZE / 2 - 2,
                  backgroundColor: isFocused
                      ? backgroundColor.withAlpha(230)
                      : backgroundColor,
                  child: Text(
                    line.weight.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: isFocused ? FontWeight.w900 : FontWeight.w600,
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
