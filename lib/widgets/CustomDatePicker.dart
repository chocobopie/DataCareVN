import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({Key? key, required this.label, required this.hintText, this.borderColor, this.onTap, this.readOnly}) : super(key: key);

  final String label;
  final String hintText;
  final dynamic onTap;
  final Color? borderColor;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly ?? false,
      onTap: onTap,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.only(left: 20.0),
        labelText: label,
        hintText: hintText,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 107, 106, 144),
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: borderColor == null ? Colors.grey.shade300 : borderColor!,
              width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: borderColor == null ? Colors.blue : borderColor!,
              width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
