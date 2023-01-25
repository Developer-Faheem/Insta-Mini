import 'package:flutter/material.dart';

class TextInputField1 extends StatelessWidget {
  TextEditingController textEditingController;
  String textHint;
  bool isPass = false;
  TextInputType textInputType;

  TextInputField1(
      {required this.textEditingController,
      required this.textHint,
      required this.isPass,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: textHint,
        contentPadding: const EdgeInsets.all(8),
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
      ),
      obscureText: isPass,
      keyboardType: textInputType,
    );
  }
}
