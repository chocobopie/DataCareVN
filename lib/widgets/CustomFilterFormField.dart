import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomFilterFormField extends StatelessWidget {
  const CustomFilterFormField({Key? key, required this.items, required this.titleWidth, required this.dropdownWidth, required this.hint, this.onChanged,this.selectedValue, this.dropdownHeight}) : super(key: key);

  final double titleWidth;
  final double dropdownWidth;
  final double? dropdownHeight;
  final List<String> items;
  final String hint;
  final String? selectedValue;
  final dynamic onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: titleWidth,
      child: CustomDropdownButton2(
        scrollbarAlwaysShow: true,
        dropdownWidth: dropdownWidth,
        dropdownHeight: dropdownHeight,
        icon: const Visibility (visible:false, child: Icon(Icons.arrow_downward)),
        hint: hint,
        dropdownItems: items,
        onChanged: onChanged,
        value: selectedValue,
      ),
    );
  }
}
