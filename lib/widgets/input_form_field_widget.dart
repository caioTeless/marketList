import 'package:flutter/material.dart';

import '../helpers/input_validation.dart';

class InputFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String?) onSaved;
  final bool? isKeyboardNumber;

  const InputFormFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSaved,
    this.isKeyboardNumber,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: InputValidation.validateInput,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(),
        ),
      ),
      keyboardType:
          isKeyboardNumber != null ? TextInputType.number : TextInputType.text,
      onSaved: onSaved,
    );
  }
}
