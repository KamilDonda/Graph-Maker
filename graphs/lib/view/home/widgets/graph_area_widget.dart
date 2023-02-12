import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/models/sprite.dart';
import 'package:graphs/view/home/cubit/points_cubit.dart';
import 'package:graphs/view/home/widgets/point_widget.dart';
import 'package:graphs/view/home/widgets/sprite_widget.dart';

class GraphAreaWidget extends StatelessWidget {
  const GraphAreaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff1f1f1),
      child: BlocBuilder<PointsCubit, List<Sprite>>(
        builder: (_, points) {
          return Stack(
            children: points
                .mapIndexed((index, point) => index == 0
                    ? SpriteWidget(sprite: point)
                    : PointWidget(point: point as Point, index: index))
                .toList(),
          );
        },
      ),
    );
  }
}
