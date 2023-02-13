import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/models/line.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/models/sprite.dart';
import 'package:graphs/view/home/cubit/points_cubit.dart';
import 'package:graphs/view/home/widgets/line_widget.dart';
import 'package:graphs/view/home/widgets/point_widget.dart';
import 'package:graphs/view/home/widgets/sprite_widget.dart';

class GraphAreaWidget extends StatelessWidget {
  const GraphAreaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff1f1f1),
      child: BlocBuilder<PointsCubit, List<Sprite>>(
        builder: (_, sprites) {
          return Stack(
            children: sprites
                .mapIndexed(
                  (index, sprite) => index == 0
                      ? SpriteWidget(sprite: sprite)
                      : sprite is Point
                          ? PointWidget(point: sprite, index: index)
                          : LineWidget(line: sprite as Line),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
