import 'package:flutter/material.dart';

class InputFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final bool isOpen;
  final double width;

  const InputFieldWidget({
    Key? key,
    this.controller,
    required this.labelText,
    required this.isOpen,
    this.width = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isOpen
        ? SizedBox(
            width: width,
            height: 50,
            child: TextFormField(
              controller: controller,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: labelText,
                border: OutlineInputBorder(),
              ),
            ),
          )
        : Container(
            alignment: Alignment.center,
            height: 50,
            child: Text(
              labelText[0],
              style: const TextStyle(fontSize: 30),
            ),
          );
  }
}
