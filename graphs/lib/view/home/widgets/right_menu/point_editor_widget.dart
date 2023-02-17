import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:graphs/constants/sizes.dart';
import 'package:graphs/models/point.dart';
import 'package:graphs/models/sprite.dart';
import 'package:graphs/view/home/cubit/sprites_cubit.dart';
import 'package:graphs/view/home/widgets/right_menu/input_field_widget.dart';

class PointEditorWidget extends StatefulWidget {
  final bool isMenuOpen;
  final Sprite? sprite;

  const PointEditorWidget({
    Key? key,
    required this.isMenuOpen,
    required this.sprite,
  }) : super(key: key);

  @override
  State<PointEditorWidget> createState() => _PointEditorWidgetState();
}

class _PointEditorWidgetState extends State<PointEditorWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController xController = TextEditingController();
  final TextEditingController yController = TextEditingController();

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

  int _parseString(String value, {int defaultValue = 200}) {
    try {
      return int.parse(value);
    } on Exception {
      return defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    var id = BlocProvider.of<SpritesCubit>(context).getFocusedID();
    if (widget.sprite != null) {
      if (!wasEdited) {
        var sprite = widget.sprite;
        if (sprite is Point) {
          nameController.text = sprite.name.toString();
          xController.text = sprite.x.toString();
          yController.text = sprite.y.toString();
          _mainColor = sprite.color as ColorSwatch;
        }
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
        InputFieldWidget(
            labelText: "Name",
            isOpen: widget.isMenuOpen,
            controller: nameController),
        const SizedBox(height: 10),
        InputFieldWidget(
          labelText: "X",
          isOpen: widget.isMenuOpen,
          controller: xController,
          isDigitsOnly: true,
          max: AREA_SIZE_X - DEFAULT_POINT_SIZE,
        ),
        const SizedBox(height: 10),
        InputFieldWidget(
          labelText: "Y",
          isOpen: widget.isMenuOpen,
          controller: yController,
          isDigitsOnly: true,
          max: AREA_SIZE_Y - DEFAULT_POINT_SIZE,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.isMenuOpen
                ? const Text("Select color", style: TextStyle(fontSize: 25))
                : const SizedBox(),
            id != UNFOCUSED || widget.isMenuOpen
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
        if (widget.isMenuOpen)
          FloatingActionButton.extended(
            onPressed: () {
              BlocProvider.of<SpritesCubit>(context).addPoint(Point(
                  name: nameController.text,
                  x: _parseString(xController.text,
                      defaultValue: (AREA_SIZE_X - DEFAULT_POINT_SIZE) ~/ 2),
                  y: _parseString(yController.text,
                      defaultValue: (AREA_SIZE_Y - DEFAULT_POINT_SIZE) ~/ 2),
                  color: _mainColor!));
            },
            label: Container(
              width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(id == UNFOCUSED ? "Add new point" : "Copy this point"),
                  const Icon(Icons.add),
                ],
              ),
            ),
          ),
        const SizedBox(height: 10),
        if (id != UNFOCUSED && widget.isMenuOpen)
          FloatingActionButton.extended(
            onPressed: () {
              BlocProvider.of<SpritesCubit>(context).editPoint(
                widget.sprite as Point,
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
                  Text("Save this point"),
                  Icon(Icons.done),
                ],
              ),
            ),
          ),
        const SizedBox(height: 10),
        if (id != UNFOCUSED && widget.isMenuOpen)
          FloatingActionButton.extended(
            onPressed: () {
              BlocProvider.of<SpritesCubit>(context).deletePoint(id);
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
    );
  }
}
