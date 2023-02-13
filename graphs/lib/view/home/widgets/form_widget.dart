import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:graphs/constants/sizes.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/models/sprite.dart';
import 'package:graphs/view/home/cubit/points_cubit.dart';
import 'package:graphs/view/home/widgets/input_field_widget.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({Key? key}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController xController = TextEditingController();
  final TextEditingController yController = TextEditingController();
  bool isOpen = true;

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

  void clearButtonClick(BuildContext context) {
    BlocProvider.of<PointsCubit>(context).clearAll();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isOpen ? FORM_MAX_WIDTH : FORM_MIN_WIDTH,
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<PointsCubit, List<Sprite>>(builder: (_, points) {
        var index = BlocProvider.of<PointsCubit>(context).getFocusedIndex();
        if (index != 0) {
          if (!wasEdited) {
            var point = points[index] as Point;
            nameController.text = point.name.toString();
            xController.text = point.x.toString();
            yController.text = point.y.toString();
            _mainColor = point.color as ColorSwatch;
          }
        } else {
          nameController.text = "";
          xController.text = "";
          yController.text = "";
        }
        wasEdited = false;

        return Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isOpen
                      ? const Expanded(
                          child: Text(
                          "Edit point",
                          style: TextStyle(fontSize: 30),
                        ))
                      : const SizedBox(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isOpen = !isOpen;
                      });
                    },
                    icon: Icon(isOpen ? Icons.arrow_forward_ios : Icons.menu),
                  ),
                ],
              ),
            ),
            InputFieldWidget(
                labelText: "Name", isOpen: isOpen, controller: nameController),
            const SizedBox(height: 10),
            InputFieldWidget(
              labelText: "X",
              isOpen: isOpen,
              controller: xController,
              isDigitsOnly: true,
              max: AREA_SIZE_X - DEFAULT_POINT_SIZE,
            ),
            const SizedBox(height: 10),
            InputFieldWidget(
              labelText: "Y",
              isOpen: isOpen,
              controller: yController,
              isDigitsOnly: true,
              max: AREA_SIZE_Y - DEFAULT_POINT_SIZE,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isOpen
                    ? const Text("Select color", style: TextStyle(fontSize: 25))
                    : const SizedBox(),
                index > 0 || isOpen
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
            if (isOpen)
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
            if (index > 0 && isOpen)
              FloatingActionButton.extended(
                onPressed: () {
                  BlocProvider.of<PointsCubit>(context).editPoint(
                      Point(
                          name: nameController.text,
                          x: _parseString(xController.text),
                          y: _parseString(yController.text),
                          color: _mainColor!),
                      index);
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
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    if (isOpen)
                      ElevatedButton.icon(
                        onPressed: () {
                          clearButtonClick(context);
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text("Clear all"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                      ),
                    if (!isOpen)
                      Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.red,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.clear),
                          color: Colors.white,
                          onPressed: () {
                            clearButtonClick(context);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
