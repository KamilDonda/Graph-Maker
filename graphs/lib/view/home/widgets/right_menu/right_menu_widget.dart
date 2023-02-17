import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/constants/sizes.dart';
import 'package:graphs/models/line.dart';
import 'package:graphs/models/sprite.dart';
import 'package:graphs/view/home/cubit/right_menu/right_menu_cubit.dart';
import 'package:graphs/view/home/cubit/sprites_cubit.dart';
import 'package:graphs/view/home/widgets/right_menu/hinter_widget.dart';
import 'package:graphs/view/home/widgets/right_menu/point_editor_widget.dart';

class RightMenuWidget extends StatelessWidget {
  const RightMenuWidget({Key? key}) : super(key: key);

  Sprite? getSprite(List<Sprite> sprites, int id) {
    try {
      return sprites.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RightMenuCubit, bool>(builder: (_, isMenuOpen) {
      return SizedBox(
        width: isMenuOpen ? FORM_MAX_WIDTH : FORM_MIN_WIDTH,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: BlocBuilder<SpritesCubit, List<Sprite>>(
                builder: (_, points) {
                  var id =
                      BlocProvider.of<SpritesCubit>(context).getFocusedID();
                  Sprite? sprite = getSprite(points, id);
                  return Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isMenuOpen
                                ? const Expanded(
                                    child: Text(
                                    "Edit point",
                                    style: TextStyle(fontSize: 30),
                                  ))
                                : const SizedBox(),
                            IconButton(
                              splashRadius: 25,
                              onPressed: () {
                                BlocProvider.of<RightMenuCubit>(context)
                                    .toggleMenu();
                              },
                              icon: Icon(isMenuOpen
                                  ? Icons.arrow_forward_ios
                                  : Icons.menu),
                            ),
                          ],
                        ),
                      ),
                      (sprite is Line)
                          ? const Text("Line", style: TextStyle(fontSize: 20))
                          : PointEditorWidget(
                              isMenuOpen: isMenuOpen, sprite: sprite),
                    ],
                  );
                },
              ),
            ),
            const Spacer(),
            if (isMenuOpen) const HinterWidget(),
          ],
        ),
      );
    });
  }
}
