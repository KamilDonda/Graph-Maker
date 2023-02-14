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
      body: BlocProvider<PointsCubit>(
        create: (_) => PointsCubit()..getPoints(),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        const Text(
                          'Graph',
                          style: TextStyle(fontSize: 30),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            BlocProvider.of<PointsCubit>(context).clearAll();
                          },
                          icon: const Icon(Icons.clear),
                          label: const Text("Clear all"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  const Expanded(child: GraphAreaWidget()),
                ],
              ),
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
            ),
            const FormWidget(),
          ],
        ),
      ),
    );
  }
}
