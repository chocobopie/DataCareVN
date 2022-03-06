import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_sample/utilities/utils.dart';

class IconTextButtonSmall3 extends StatelessWidget {
  const IconTextButtonSmall3(
      {Key? key,
      required this.title,
      required this.colorsButton,
      required this.subtitle})
      : super(key: key);

  final String title;
  final String subtitle;
  final List<Color> colorsButton; //List colors for the button, must be 2 colors

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomColumn(title: title, subtitle: subtitle),
      width: 85,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.15, 0.01],
          colors: colorsButton,
        ),
      ),
    );
  }
}

class CustomColumn extends StatelessWidget {
  const CustomColumn({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.0,
              color: defaultFontColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14.0,
              color: defaultFontColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
