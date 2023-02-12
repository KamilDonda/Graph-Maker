import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:graphs/view/home/widgets/input_field.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({Key? key}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController nameController = TextEditingController();
  static const double MAX_WIDTH = 220;
  static const double MIN_WIDTH = 60;
  bool isOpen = true;

  ColorSwatch? _tempMainColor;
  ColorSwatch? _mainColor = Colors.blue;

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
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
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
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isOpen ? MAX_WIDTH : MIN_WIDTH,
      padding: const EdgeInsets.all(10),
      child: Column(
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
          InputFieldWidget(labelText: "Name", isOpen: isOpen),
          const SizedBox(height: 10),
          InputFieldWidget(labelText: "X", isOpen: isOpen),
          const SizedBox(height: 10),
          InputFieldWidget(labelText: "Y", isOpen: isOpen),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isOpen
                  ? const Text("Select color", style: TextStyle(fontSize: 25))
                  : const SizedBox(),
              GestureDetector(
                onTap: _openMainColorPicker,
                child: CircleColor(
                  color: _mainColor!,
                  circleSize: 35,
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          if (isOpen)
            FloatingActionButton.extended(
              onPressed: () {},
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
        ],
      ),
    );
  }
}
