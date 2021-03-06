import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({Key? key, required this.title, this.onPressed, required this.radius, required this.color, this.fontSize}) : super(key: key);

  final String title;
  final dynamic onPressed;
  final double radius;
  final Color color;
  final double? fontSize;


  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary: defaultFontColor,
          side: BorderSide(width: 2.0, color: color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radius))),
        ),
        onPressed: onPressed,
        child: Text(title, style: TextStyle(fontSize: fontSize ?? 12),)
    );
  }
}
