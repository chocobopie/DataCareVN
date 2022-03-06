import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:login_sample/utilities/utils.dart';

class CustomEditableTextField extends StatelessWidget {
   const CustomEditableTextField({
    Key? key, required this.text, required this.title, required this.readonly, required this.textEditingController, this.inputNumberOnly, this.inputEmailOnly
  }) : super(key: key);

  final String title;
  final String text;
  final bool readonly;
  final TextEditingController textEditingController;
  final bool? inputNumberOnly;
  final bool? inputEmailOnly;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        inputFormatters: inputNumberOnly == true ? <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(15),
        ] : null,
        keyboardType: inputNumberOnly == true ? TextInputType.number : inputEmailOnly == true ? TextInputType.emailAddress : TextInputType.text,
        onChanged: (val) {
          textEditingController.text = val;
        },
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.only(left: 20.0),
          labelText: title,
          hintText: text,
          labelStyle: const TextStyle(
            color: defaultFontColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Colors.blue,
                width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        readOnly: readonly,
      ),
      width: 150.0,
    );
  }
}