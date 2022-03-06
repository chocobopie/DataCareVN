import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';

class CustomReadOnlyTextField extends StatelessWidget {
  const CustomReadOnlyTextField({
    Key? key, required this.text, required this.title,
  }) : super(key: key);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.only(left: 20.0),
          labelText: title,
          hintText: text,
          labelStyle: const TextStyle(
            color: defaultFontColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Colors.blue,
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