import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/constants/sizes.dart';
import 'package:graphs/models/sprite.dart';
import 'package:graphs/view/home/cubit/points_cubit.dart';

class SpriteWidget extends StatelessWidget {
  const SpriteWidget({Key? key, required this.sprite}) : super(key: key);

  final Sprite sprite;

  void click(BuildContext context) {
    BlocProvider.of<PointsCubit>(context).focusSprite(0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: sprite.y,
      left: sprite.x,
      child: GestureDetector(
        onTapDown: (details) {
          click(context);
        },
        onPanUpdate: (position) {
          click(context);
          BlocProvider.of<PointsCubit>(context)
              .updateSprite(position.delta.dx, position.delta.dy);
        },
        child: Container(
          width: AREA_SIZE_X,
          height: AREA_SIZE_Y,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 2,
                color: const Color(0xffdddddd),
              )),
        ),
      ),
    );
  }
}
