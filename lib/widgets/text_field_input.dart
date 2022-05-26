import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
 
  const TextFieldInput({
     Key? key,
     required this.textEditingController,
     required this.hintText,
     required this.textInputType,
     this.isPass = false,
      }) : super(key: key);

  final TextEditingController textEditingController;
  final String hintText;
  final TextInputType textInputType;
  final bool isPass;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context)
    );
    return TextField(
      controller: textEditingController,
      decoration:  InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8)
      ),
      keyboardType: textInputType,
      obscureText: isPass,//obscuring text
    );
  }
}