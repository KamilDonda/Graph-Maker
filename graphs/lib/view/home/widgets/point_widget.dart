import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/view/home/cubit/points_cubit.dart';
import 'package:graphs/view/home/widgets/sprite_widget.dart';

class PointWidget extends SpriteWidget {
  const PointWidget({super.key, required this.point, required this.index})
      : super(sprite: point);

  final Point point;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: point.y,
      left: point.x,
      child: GestureDetector(
        onPanUpdate: (position) {
          BlocProvider.of<PointsCubit>(context)
              .updatePoint(position.delta.dx, position.delta.dy, index);
        },
        child: Container(
          width: point.size,
          height: point.size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: point.color,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
              width: 5,
            ),
          ),
          child: Text(point.name, style: const TextStyle(fontSize: 50)),
        ),
      ),
    );
  }
}
