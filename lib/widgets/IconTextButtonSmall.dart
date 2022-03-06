import 'package:flutter/material.dart';

class IconTextButtonSmall extends StatelessWidget {
  const IconTextButtonSmall({
    Key? key, required this.imageUrl, required this.text, required this.colorsButton, required this.route,
  }) : super(key: key);

  final String imageUrl; //local image
  final String text; //text for the button
  final List<Color> colorsButton; //colors for the button, must be 2 colors
  final String route; //route for navigating to new screen

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: (){
          Navigator.pushNamed(context, '/$route');
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0,),
              child: Image(image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 12.0,
                color: Color.fromARGB(255, 107, 106, 144),
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
      width: 350,
      height: 50,
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
          stops: const [0.02, 0.01],
          colors: colorsButton,
        ),
      ),
    );
  }
}
