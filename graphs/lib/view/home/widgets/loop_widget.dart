import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/models/loop.dart';
import 'package:graphs/view/home/cubit/points_cubit.dart';
import 'package:graphs/view/home/widgets/sprite_widget.dart';

class LoopWidget extends SpriteWidget {
  const LoopWidget({super.key, required this.loop}) : super();

  final Loop loop;

  BorderRadiusGeometry _borderRadius(double radius) {
    switch (loop.counter) {
      case 0:
        return _radius(loop.point.size, radius);
      case 1:
        return _radius(radius, loop.point.size);
      case 2:
        return _radius(loop.point.size, radius);
      case 3:
        return _radius(radius, loop.point.size);
    }
    return BorderRadius.zero;
  }

  BorderRadiusGeometry _radius(double tlbr, double trbl) {
    return BorderRadius.only(
      topLeft: Radius.circular(tlbr),
      topRight: Radius.circular(trbl),
      bottomLeft: Radius.circular(trbl),
      bottomRight: Radius.circular(tlbr),
    );
  }

  int leftPosition(int displacement) {
    switch (loop.counter) {
      case 0:
        return loop.point.x - displacement;
      case 1:
        return loop.point.x;
      case 2:
        return loop.point.x + displacement ~/ 2;
      case 3:
        return loop.point.x - displacement;
    }
    return 0;
  }

  int topPosition(int displacement) {
    switch (loop.counter) {
      case 0:
        return loop.point.y - displacement;
      case 1:
        return loop.point.y - displacement;
      case 2:
        return loop.point.y;
      case 3:
        return loop.point.y;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final displacement = (loop.point.size * 0.75).toInt();
    final size = loop.point.size * 1.5;
    final radius = loop.point.size * 1.25;
    var background = BlocProvider.of<PointsCubit>(context).background;
    return Positioned(
      top: background.y + topPosition(displacement).toDouble(),
      left: background.x + leftPosition(displacement).toDouble(),
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
    );
  }
}
