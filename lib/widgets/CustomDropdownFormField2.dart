import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownFormField2 extends StatelessWidget {
  const CustomDropdownFormField2({Key? key, required this.label, required this.hintText, required this.items, required this.onChanged, this.borderColor, this.value}) : super(key: key);

  final String label;
  final Widget hintText;
  final List<dynamic> items;
  final dynamic onChanged;
  final Color? borderColor;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      value: value,
      key: UniqueKey(),
      decoration: InputDecoration(
        errorMaxLines: 5,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor == null ? Colors.grey.shade300 : borderColor!, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
        labelText: label,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 107, 106, 144),
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      isExpanded: true,
      hint: hintText,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 50,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return '$label không được để trống';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}