import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/constants/colors.dart';
import 'package:graphs/constants/sizes.dart';
import 'package:graphs/models/loop.dart';
import 'package:graphs/view/home/cubit/sprites_cubit.dart';
import 'package:graphs/view/home/widgets/sprite_widget.dart';

class LoopWidget extends SpriteWidget {
  const LoopWidget({super.key, required this.loop}) : super();

  final Loop loop;

  BorderRadiusGeometry _borderRadius(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(
          loop.counter == 1 || loop.counter == 3 ? loop.point.size : radius),
      topRight: Radius.circular(
          loop.counter == 1 || loop.counter == 3 ? radius : loop.point.size),
      bottomLeft: Radius.circular(
          loop.counter == 1 || loop.counter == 3 ? radius : loop.point.size),
      bottomRight: Radius.circular(
          loop.counter == 1 || loop.counter == 3 ? loop.point.size : radius),
    );
  }

  double _top(double size) {
    return (loop.counter < 3) ? (-size / 2) : (loop.point.size / 3);
  }

  double _left(double size) {
    return (loop.counter == 1 || loop.counter == 4)
        ? (-size / 2)
        : (loop.point.size / 3);
  }

  double _weightTop(double size) {
    return (loop.counter < 3) ? 0 : size * 2 / 3;
  }

  double _weightLeft(double size) {
    return (loop.counter == 1 || loop.counter == 4) ? 0 : size * 2 / 3;
  }

  @override
  Widget build(BuildContext context) {
    final size = loop.point.size * 1.5;
    final radius = loop.point.size * 1.25;
    var background = BlocProvider.of<SpritesCubit>(context).background;
    var areVisible = BlocProvider.of<SpritesCubit>(context).areWeightsVisible();

    bool isFocused =
        BlocProvider.of<SpritesCubit>(context).getFocusedID() == loop.id;

    return Stack(children: [
      Positioned(
        top: background.y + loop.point.y.toDouble() + _top(size),
        left: background.x + loop.point.x.toDouble() + _left(size),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: _borderRadius(radius),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
        ),
      ),
      if (areVisible)
        Positioned(
            top: background.y +
                loop.point.y.toDouble() +
                _top(size) +
                _weightTop(size),
            left: background.x +
                loop.point.x.toDouble() +
                _left(size) +
                _weightLeft(size),
            child: GestureDetector(
              onTapDown: (details) {
                BlocProvider.of<SpritesCubit>(context).focusSprite(id: loop.id);
              },
              onSecondaryTap: () {
                BlocProvider.of<SpritesCubit>(context).removeLoop(loop);
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
                    loop.weight.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: isFocused ? FontWeight.w900 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )),
    ]);
  }
}
