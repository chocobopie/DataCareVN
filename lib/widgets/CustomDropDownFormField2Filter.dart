import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';
class CustomDropdownFormField2Filter extends StatelessWidget {
  const CustomDropdownFormField2Filter({Key? key, required this.items, this.onChanged, this.borderColor, this.value, required this.label, this.borderRadius, this.dropdownWidth}) : super(key: key);

  final String label;
  final List<dynamic> items;
  final dynamic onChanged;
  final Color? borderColor;
  final String? value;
  final double? borderRadius;
  final double? dropdownWidth;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      value: value,
      decoration: InputDecoration(
        //Add isDense true and zero Padding.
        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: borderColor == null ? Colors.grey.shade300 : borderColor!,
              width: 2),
          borderRadius: BorderRadius.circular(borderRadius == null ? 10 : borderRadius!),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: borderColor == null ? Colors.blue : borderColor!,
              width: 2),
          borderRadius: BorderRadius.circular(borderRadius == null ? 10 : borderRadius!),
        ),
        //Add more decoration as you want here
        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
      ),
      isExpanded: true,
      hint: Text(
        label,
        style: const TextStyle(fontSize: 12, color: defaultFontColor, fontWeight: FontWeight.w600),
      ),
      buttonHeight: 50,
      buttonPadding: const EdgeInsets.only(left: 10, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      dropdownWidth: dropdownWidth,
      items: items
          .map((item) =>
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                color: defaultFontColor,
              ),
            ),
          ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return label;
        }
        return null;
      },
      onChanged: onChanged
    );
  }
}
