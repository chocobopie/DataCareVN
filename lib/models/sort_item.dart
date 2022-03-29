import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SortItem {
  final String text;
  final IconData icon;

  const SortItem({
    required this.text,
    required this.icon,
  });
}

class SortItems {
  static const List<SortItem> firstItems = [asc, des];

  static const asc = SortItem(text: 'Tăng dần', icon: Icons.arrow_drop_up);
  static const des = SortItem(text: 'Giảm dần', icon: Icons.arrow_drop_down);


  static Widget buildItem(SortItem item) {
    return Row(
      children: [
        Icon(
            item.icon,
            color: Colors.white,
            size: 22
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, SortItem item) {
    switch (item) {
      case SortItems.asc:
        return true;
      case SortItems.des:
      //Do something
        return false;
    }
  }
}