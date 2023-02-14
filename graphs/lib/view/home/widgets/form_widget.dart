import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:graphs/constants/sizes.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/models/sprite.dart';
import 'package:graphs/view/home/cubit/points_cubit.dart';
import 'package:graphs/view/home/widgets/input_field_widget.dart';
import 'package:graphs/widgets/bullet_list.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({Key? key}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController xController = TextEditingController();
  final TextEditingController yController = TextEditingController();
  bool isFormOpen = true;
  bool isHinterOpen = true;

  ColorSwatch? _tempMainColor = Colors.blue;
  ColorSwatch? _mainColor = Colors.blue;
  bool wasEdited = false;

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('CANCEL'),
            ),
            TextButton(
              child: const Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                wasEdited = true;
                setState(() => _mainColor = _tempMainColor);
              },
            ),
          ],
        );
      },
    );
  }

  void _openMainColorPicker() async {
    _openDialog(
      "Main Color picker",
      MaterialColorPicker(
        selectedColor: _mainColor,
        allowShades: false,
        onMainColorChange: (color) => _tempMainColor = color,
      ),
    );
  }

  double _parseString(String value) {
    try {
      return double.parse(value);
    } on Exception {
      return 200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFormOpen ? FORM_MAX_WIDTH : FORM_MIN_WIDTH,
      child: BlocBuilder<PointsCubit, List<Sprite>>(builder: (_, points) {
        var id = BlocProvider.of<PointsCubit>(context).getFocusedID();
        if (id != 0) {
          if (!wasEdited) {
            var point = points.firstWhere((e) => e.id == id) as Point;
            nameController.text = point.name.toString();
            xController.text = point.x.toString();
            yController.text = point.y.toString();
            _mainColor = point.color as ColorSwatch;
          }
        } else {
          nameController.text = "";
          xController.text = "";
          yController.text = "";
          if (!wasEdited) _mainColor = Colors.blue;
        }
        wasEdited = false;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isFormOpen
                            ? const Expanded(
                                child: Text(
                                "Edit point",
                                style: TextStyle(fontSize: 30),
                              ))
                            : const SizedBox(),
                        IconButton(
                          splashRadius: 25,
                          onPressed: () {
                            setState(() {
                              isFormOpen = !isFormOpen;
                            });
                          },
                          icon: Icon(isFormOpen
                              ? Icons.arrow_forward_ios
                              : Icons.menu),
                        ),
                      ],
                    ),
                  ),
                  InputFieldWidget(
                      labelText: "Name",
                      isOpen: isFormOpen,
                      controller: nameController),
                  const SizedBox(height: 10),
                  InputFieldWidget(
                    labelText: "X",
                    isOpen: isFormOpen,
                    controller: xController,
                    isDigitsOnly: true,
                    max: AREA_SIZE_X - DEFAULT_POINT_SIZE,
                  ),
                  const SizedBox(height: 10),
                  InputFieldWidget(
                    labelText: "Y",
                    isOpen: isFormOpen,
                    controller: yController,
                    isDigitsOnly: true,
                    max: AREA_SIZE_Y - DEFAULT_POINT_SIZE,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isFormOpen
                          ? const Text("Select color",
                              style: TextStyle(fontSize: 25))
                          : const SizedBox(),
                      id > 0 || isFormOpen
                          ? GestureDetector(
                              onTap: _openMainColorPicker,
                              child: CircleColor(
                                color: _mainColor!,
                                circleSize: 35,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 50),
                  if (isFormOpen)
                    FloatingActionButton.extended(
                      onPressed: () {
                        BlocProvider.of<PointsCubit>(context).addPoint(Point(
                            name: nameController.text,
                            x: _parseString(xController.text),
                            y: _parseString(yController.text),
                            color: _mainColor!));
                      },
                      label: Container(
                        width: 200,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Add new point"),
                            Icon(Icons.add),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (id > 0 && isFormOpen)
                    FloatingActionButton.extended(
                      onPressed: () {
                        BlocProvider.of<PointsCubit>(context).editPoint(
                          id,
                          nameController.text,
                          _parseString(xController.text),
                          _parseString(yController.text),
                          _mainColor!,
                        );
                      },
                      backgroundColor: Colors.green,
                      label: Container(
                        width: 200,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Edit this point"),
                            Icon(Icons.edit),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (id > 0 && isFormOpen)
                    FloatingActionButton.extended(
                      onPressed: () {
                        BlocProvider.of<PointsCubit>(context).deletePoint(id);
                      },
                      backgroundColor: Colors.red,
                      label: Container(
                        width: 200,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Delete this point"),
                            Icon(Icons.delete),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Spacer(),
            if (isFormOpen)
              Align(
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
                            setState(() {
                              isHinterOpen = !isHinterOpen;
                            });
                          },
                          icon: Icon(isHinterOpen
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up),
                        ),
                        if (isHinterOpen)
                          const BulletList([
                            "To select point, tap on it by Left Mouse Button",
                            "To connect points, first select point, then tap on another point by Right Mouse Button",
                          ]),
                      ],
                    )),
              ),
          ],
        );
      }),
    );
  }
}
