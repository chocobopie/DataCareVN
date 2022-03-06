import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';

class CustomExpansionTile extends StatelessWidget {
  const CustomExpansionTile({Key? key, required this.label, required this.children, required this.colors}) : super(key: key);

  final String label;
  final List<Widget> children;

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 1,
              offset: const Offset(
                  0, 3), // changes position of shadow
            ),
          ],
          gradient: LinearGradient(
            stops: const [0.02, 0.01],
            colors: colors,
          ),
        ),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              label,
              style: const TextStyle(fontSize: 16.0, color: defaultFontColor),
            ),
            children: <Widget>[
              ...children,
            ],
          ),
        )
    );
  }
}

