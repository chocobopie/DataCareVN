import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';

class ImageTextButton extends StatelessWidget {
  const ImageTextButton(
      {Key? key,
      required this.imageUrl,
      required this.text,
      required this.buttonColors,
      required this.onPressed})
      : super(key: key);

  final String imageUrl; //local image
  final String text; //text for the button
  final List<Color> buttonColors; //List colors for the button, must be 2 colors
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 150,
      child: TextButton(
          onPressed: onPressed,
          child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 20.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      child: Image(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                      height: 40.0,
                      width: 40.0,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: defaultFontColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ))),
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
          stops: const [0.04, 0.02],
          colors: buttonColors,
        ),
      ),
    );
  }
}
