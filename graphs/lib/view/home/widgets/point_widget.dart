import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/view/home/cubit/points_cubit.dart';
import 'package:graphs/view/home/widgets/sprite_widget.dart';

class PointWidget extends SpriteWidget {
  const PointWidget({super.key, required this.point}) : super(sprite: point);

  final Point point;

  void clickPoint(BuildContext context) {
    BlocProvider.of<PointsCubit>(context).focusSprite(point.id);
  }

  @override
  Widget build(BuildContext context) {
    bool isFocused =
        BlocProvider.of<PointsCubit>(context).getFocusedID() == point.id;
    return Positioned(
      top: point.y,
      left: point.x,
      child: GestureDetector(
        onTapDown: (details) {
          clickPoint(context);
        },
        onPanStart: (details) {
          clickPoint(context);
        },
        onPanUpdate: (position) {
          BlocProvider.of<PointsCubit>(context)
              .updatePoint(position.delta.dx, position.delta.dy, point.id);
        },
        onLongPressStart: (details) {
          BlocProvider.of<PointsCubit>(context).startPoint(point.id);
        },
        child: Container(
          width: point.size,
          height: point.size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: point.color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isFocused ? Colors.black : const Color(0xFF282828),
              width: isFocused ? 5 : 3,
            ),
          ),
          child: Text(
            point.name,
            style: TextStyle(
                fontSize: 35,
                fontWeight: isFocused ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
