import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:login_sample/models/sort_item.dart';
import 'package:login_sample/utilities/utils.dart';

class CustomDropdownButtonSortAscDes extends StatelessWidget {
  const CustomDropdownButtonSortAscDes({Key? key, this.onChanged}) : super(key: key);

  final dynamic onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton2(
      customButton: const Icon(
        Icons.sort,
        size: 40,
        color: mainBgColor,
      ),
      items: [
        ...SortItems.firstItems.map(
              (item) =>
              DropdownMenuItem<SortItem>(
                value: item,
                child: SortItems.buildItem(item),
              ),
        ),
      ],
      onChanged: onChanged,
      itemHeight: 48,
      itemPadding: const EdgeInsets.only(left: 16, right: 16),
      dropdownWidth: 160,
      dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: mainBgColor,
      ),
      dropdownElevation: 8,
      offset: const Offset(0, 8),
    );
  }
}
