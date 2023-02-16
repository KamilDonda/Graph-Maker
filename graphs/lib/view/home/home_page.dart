import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/constants/sizes.dart';
import 'package:graphs/models/sprite.dart';
import 'package:graphs/view/home/cubit/points_cubit.dart';
import 'package:graphs/view/home/widgets/form_widget.dart';
import 'package:graphs/view/home/widgets/graph_area_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: TOP_BAR_HEIGHT,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Text(
                        'Graph',
                        style: TextStyle(fontSize: 30),
                      ),
                      const Spacer(),
                      BlocBuilder<PointsCubit, List<Sprite>>(
                          builder: (context, snapshot) {
                        var areVisible = BlocProvider.of<PointsCubit>(context)
                            .areBulletsVisible();
                        return ElevatedButton.icon(
                          onPressed: () {
                            BlocProvider.of<PointsCubit>(context)
                                .toggleBulletsVisibility();
                          },
                          icon: Icon(areVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          label: Text(
                              areVisible ? "Hide bullets" : "Show bullets"),
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(140, 40),
                              backgroundColor: Colors.grey),
                        );
                      }),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          BlocProvider.of<PointsCubit>(context).clearAll();
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text("Clear all"),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(120, 40),
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
    );
  }
}
