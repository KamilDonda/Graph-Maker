import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/view/home/cubit/points_cubit.dart';
import 'package:graphs/view/home/widgets/sprite_widget.dart';

class PointWidget extends SpriteWidget {
  const PointWidget({super.key, required this.point}) : super();

  final Point point;

  void onLeftClick(BuildContext context) {
    BlocProvider.of<PointsCubit>(context).focusSprite(id: point.id);
  }

  void onRightClick(BuildContext context) {
    BlocProvider.of<PointsCubit>(context).addLine(point.id);
  }

  void onMove(BuildContext context, DragUpdateDetails position) {
    BlocProvider.of<PointsCubit>(context).updatePoint(
        position.delta.dx.toInt(), position.delta.dy.toInt(), point.id);
  }

  @override
  Widget build(BuildContext context) {
    bool isFocused =
        BlocProvider.of<PointsCubit>(context).getFocusedID() == point.id;
    var background = BlocProvider.of<PointsCubit>(context).background;
    return Positioned(
      top: background.y + point.y.toDouble(),
      left: background.x + point.x.toDouble(),
      child: GestureDetector(
        onTapDown: (details) {
          if (BlocProvider.of<PointsCubit>(context).getFocusedID() ==
              point.id) {
            BlocProvider.of<PointsCubit>(context).rotateLoop(point);
          }
          onLeftClick(context);
        },
        onPanStart: (details) {
          onLeftClick(context);
        },
        onPanUpdate: (position) {
          onMove(context, position);
        },
        onSecondaryTap: () {
          onRightClick(context);
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
