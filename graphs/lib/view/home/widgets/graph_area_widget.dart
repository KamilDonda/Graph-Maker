import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/view/home/cubit/points_cubit.dart';
import 'package:graphs/view/home/widgets/point_widget.dart';

class GraphAreaWidget extends StatelessWidget {
  const GraphAreaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PointsCubit, List<Point>>(
      builder: (_, points) {
        return Stack(
          children: points
              .mapIndexed(
                  (index, point) => PointWidget(point: point, index: index))
              .toList(),
        );
      },
    );
  }
}
