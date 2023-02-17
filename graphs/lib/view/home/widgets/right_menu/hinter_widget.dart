import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/view/home/cubit/right_menu/hinter_cubit.dart';
import 'package:graphs/widgets/bullet_list.dart';

class HinterWidget extends StatelessWidget {
  const HinterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HinterCubit, bool>(builder: (_, isHinterOpen) {
      return Align(
        alignment: Alignment.bottomRight,
        child: Container(
            // width: FORM_MAX_WIDTH,
            decoration: BoxDecoration(
              backgroundBlendMode: BlendMode.multiply,
              color: Colors.grey[300],
              borderRadius: !isHinterOpen
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                    )
                  : null,
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    BlocProvider.of<HinterCubit>(context).toggleHinter();
                  },
                  icon: Icon(isHinterOpen
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up),
                ),
                if (isHinterOpen)
                  const BulletList([
                    "To select point, use Left Mouse Button on it",
                    "To connect points, first select point, then use Right Mouse Button on another point",
                    "When X or Y is empty, point will be placed in the center of the area",
                    "If point is selected, the new one will be placed at the same coordinates",
                    "To delete connection, use Right Mouse Button on the weight",
                    "To reset edge position, use Left Mouse Button on the weight twice",
                  ]),
              ],
            )),
      );
    });
  }
}
