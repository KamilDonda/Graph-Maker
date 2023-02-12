import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isOpen;
  final bool isDigitsOnly;
  final double width;
  final int max;

  const InputFieldWidget({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.isOpen,
    this.isDigitsOnly = false,
    this.width = 200,
    this.max = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isOpen
        ? SizedBox(
            width: width,
            height: 50,
            child: TextFormField(
              inputFormatters: [
                UpperCaseTextFormatter(),
                NumericalRangeFormatter(max: max),
                LengthLimitingTextInputFormatter(isDigitsOnly ? 4 : 2),
                if (isDigitsOnly) FilteringTextInputFormatter.digitsOnly,
              ],
              controller: controller,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: labelText,
                border: const OutlineInputBorder(),
              ),
            ),
          )
        : Container(
            alignment: Alignment.center,
            height: 50,
            child: Text(
              controller.text.isEmpty ? labelText[0] : controller.text[0],
              style: const TextStyle(fontSize: 30),
            ),
          );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class NumericalRangeFormatter extends TextInputFormatter {
  final int max;
  NumericalRangeFormatter({required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return int.parse(newValue.text) > max ? oldValue : newValue;
  }
}
