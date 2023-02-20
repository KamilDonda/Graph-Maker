import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/constants/sizes.dart';
import 'package:graphs/view/home/cubit/right_menu/hinter_cubit.dart';
import 'package:graphs/view/home/cubit/right_menu/right_menu_cubit.dart';
import 'package:graphs/view/home/cubit/sprites_cubit.dart';
import 'package:graphs/view/home/cubit/visibility/directed_graph_cubit.dart';
import 'package:graphs/view/home/widgets/graph_area_widget.dart';
import 'package:graphs/view/home/widgets/right_menu/right_menu_widget.dart';
import 'package:screenshot/screenshot.dart';

import 'cubit/visibility/weight_visibility_cubit.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final ScreenshotController controller = ScreenshotController();

  void saveFile(Uint8List? capturedImage) {
    js.context.callMethod("webSaveAs", [
      html.Blob([capturedImage]),
      "Graph.png"
    ]);
  }

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
                      BlocBuilder<DirectedGraphCubit, bool>(
                          builder: (_, isGraphDirected) {
                        return ElevatedButton.icon(
                          onPressed: () {
                            BlocProvider.of<DirectedGraphCubit>(context)
                                .toggleDirectedGraph();
                          },
                          icon: Icon(isGraphDirected
                              ? Icons.visibility_off
                              : Icons.visibility),
                          label: Text(
                              isGraphDirected ? "Hide arrows" : "Show arrows"),
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(150, 40),
                              backgroundColor: Colors.grey),
                        );
                      }),
                      const SizedBox(width: 10),
                      BlocBuilder<WeightVisibilityCubit, bool>(
                        builder: (_, areWeightsVisible) {
                          return ElevatedButton.icon(
                            onPressed: () {
                              BlocProvider.of<WeightVisibilityCubit>(context)
                                  .toggleWeightsVisibility();
                            },
                            icon: Icon(areWeightsVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            label: Text(areWeightsVisible
                                ? "Hide weights"
                                : "Show weights"),
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(150, 40),
                                backgroundColor: Colors.grey),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          BlocProvider.of<SpritesCubit>(context).clearAll();
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text("Clear all"),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(150, 40),
                            backgroundColor: Colors.red),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          BlocProvider.of<SpritesCubit>(context).resetSprite();
                          controller
                              .capture(delay: const Duration(milliseconds: 50))
                              .then((capturedImage) async {
                            saveFile(capturedImage);
                          });
                        },
                        icon: const Icon(Icons.download),
                        label: const Text("Download"),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(150, 40),
                            backgroundColor: Colors.green),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
                Expanded(
                    child: GraphAreaWidget(screenshotController: controller)),
              ],
            ),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          // const FormWidget(),
          MultiBlocProvider(providers: [
            BlocProvider(create: (_) => RightMenuCubit()),
            BlocProvider(create: (_) => HinterCubit()),
          ], child: const RightMenuWidget()),
        ],
      ),
    );
  }
}
