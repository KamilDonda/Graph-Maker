import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/view/home/cubit/sprites_cubit.dart';
import 'package:graphs/view/home/widgets/sprite_widget.dart';

class PointWidget extends SpriteWidget {
  const PointWidget({super.key, required this.point}) : super();

  final Point point;

  void onLeftClick(BuildContext context) {
    BlocProvider.of<SpritesCubit>(context).focusSprite(id: point.id);
  }

  void onRightClick(BuildContext context) {
    BlocProvider.of<SpritesCubit>(context).addLine(point.id);
  }

  void onMove(BuildContext context, DragUpdateDetails position) {
    BlocProvider.of<SpritesCubit>(context).updatePoint(
        position.delta.dx.toInt(), position.delta.dy.toInt(), point.id);
  }

  @override
  Widget build(BuildContext context) {
    bool isFocused =
        BlocProvider.of<SpritesCubit>(context).getFocusedID() == point.id;
    var background = BlocProvider.of<SpritesCubit>(context).background;
    return Positioned(
      top: background.y + point.y.toDouble(),
      left: background.x + point.x.toDouble(),
      child: GestureDetector(
        onTapDown: (details) {
          if (BlocProvider.of<SpritesCubit>(context).getFocusedID() ==
              point.id) {
            BlocProvider.of<SpritesCubit>(context).rotateLoop(point);
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
        child: Material(
          elevation: 4,
          shape: const CircleBorder(),
          child: CircleAvatar(
            radius: point.size / 2,
            backgroundColor: isFocused ? Colors.black : const Color(0xFF282828),
            child: CircleAvatar(
              radius: isFocused ? point.size / 2 - 6 : point.size / 2 - 3,
              backgroundColor:
                  isFocused ? point.color.withAlpha(220) : point.color,
              child: Text(
                point.name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontWeight:
                        isFocused ? FontWeight.bold : FontWeight.normal),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
