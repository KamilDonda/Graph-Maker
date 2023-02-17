import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isOpen;
  final bool isDigitsOnly;
  final double width;
  final double max;

  String displayText() {
    if (isDigitsOnly) {
      return controller.text;
    } else {
      return controller.text.isEmpty ? "" : controller.text[0];
    }
  }

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
                LengthLimitingTextInputFormatter(isDigitsOnly ? 4 : 2),
                if (isDigitsOnly) FilteringTextInputFormatter.digitsOnly,
                if (isDigitsOnly) NumericalRangeFormatter(max: max),
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
              displayText(),
              style: const TextStyle(fontSize: 16),
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
  final double max;

  NumericalRangeFormatter({required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!isNumeric(newValue.text)) {
      return newValue;
    }
    return int.parse(newValue.text) > max ? oldValue : newValue;
  }
}

bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
