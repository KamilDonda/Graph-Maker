import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/view/home/cubit/points_cubit.dart';
import 'package:graphs/view/home/widgets/form_widget.dart';
import 'package:graphs/view/home/widgets/graph_area_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: BlocProvider<PointsCubit>(
        create: (_) => PointsCubit()..getPoints(),
        child: Row(
          children: const [
            Expanded(child: GraphAreaWidget()),
            VerticalDivider(
              width: 1,
              thickness: 1,
              indent: 5,
              endIndent: 5,
            ),
            FormWidget(),
          ],
        ),
      ),
    );
  }
}
