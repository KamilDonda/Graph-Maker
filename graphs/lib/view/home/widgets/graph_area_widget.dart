import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/constants/colors.dart';
import 'package:graphs/models/line.dart';
import 'package:graphs/models/loop.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/models/sprite.dart';
import 'package:graphs/view/home/cubit/sprites_cubit.dart';
import 'package:graphs/view/home/widgets/line_widget.dart';
import 'package:graphs/view/home/widgets/loop_widget.dart';
import 'package:graphs/view/home/widgets/point_widget.dart';
import 'package:graphs/view/home/widgets/sprite_widget.dart';
import 'package:screenshot/screenshot.dart';

class GraphAreaWidget extends StatelessWidget {
  const GraphAreaWidget({
    Key? key,
    required this.screenshotController,
  }) : super(key: key);

  final ScreenshotController screenshotController;

  SpriteWidget spriteWidget(int index, Sprite sprite) {
    if (sprite is Point) {
      return PointWidget(point: sprite);
    } else if (sprite is Line) {
      return LineWidget(line: sprite);
    } else {
      return LoopWidget(loop: sprite as Loop);
    }
  }

  void click(BuildContext context) {
    BlocProvider.of<SpritesCubit>(context).focusSprite();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        click(context);
      },
      onSecondaryTap: () {
        click(context);
      },
      onTertiaryTapDown: (details) {
        click(context);
      },
      onPanUpdate: (position) {
        BlocProvider.of<SpritesCubit>(context)
            .updateSprite(position.delta.dx.toInt(), position.delta.dy.toInt());
      },
      child: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: const EdgeInsets.all(2),
          color: backgroundColor,
          child: BlocBuilder<SpritesCubit, List<Sprite>>(
            builder: (_, sprites) {
              return Stack(
                children: sprites
                    .mapIndexed((index, sprite) => spriteWidget(index, sprite))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
