import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';

class CustomReadOnlyTextField extends StatelessWidget {
  const CustomReadOnlyTextField({
    Key? key, required this.text, required this.title, this.borderColor,
  }) : super(key: key);

  final String title;
  final String text;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.only(left: 20.0, top: 15.0, bottom: 15.0, right: 10.0),
          labelText: title,
          hintMaxLines: 5,
          hintText: text,
          labelStyle: const TextStyle(
            color: defaultFontColor,
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
        readOnly: true,
      ),
      width: 150.0,
    );
  }
}