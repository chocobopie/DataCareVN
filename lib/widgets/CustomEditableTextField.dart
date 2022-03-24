import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:login_sample/utilities/utils.dart';

class CustomEditableTextFormField extends StatelessWidget {
   const CustomEditableTextFormField({
    Key? key, required this.text, required this.title, required this.readonly, this.textEditingController, this.inputNumberOnly, this.inputEmailOnly, this.onTap, this.borderColor, this.width, this.obscureText, this.isNull
  }) : super(key: key);

  final String title;
  final String text;
  final bool readonly;
  final TextEditingController? textEditingController;
  final bool? inputNumberOnly;
  final bool? inputEmailOnly;
  final dynamic onTap;
  final Color? borderColor;
  final double? width;
  final bool? obscureText;
  final bool? isNull;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        key: Key(text.toString()),
        validator: isNull != true ? (value) {
          if(value!.isEmpty){
            return '$title không được bỏ trống';
          }
          return null;
        } : null,
        initialValue: text.toString(),
        onTap: onTap,
        obscureText: obscureText == null ? false : obscureText!,
        minLines: 1,
        maxLines: obscureText == null || obscureText == false ? 5 : 1,
        inputFormatters: inputNumberOnly == true ? <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ] : inputNumberOnly == null ? <TextInputFormatter>[
          LengthLimitingTextInputFormatter(50),
        ] : <TextInputFormatter>[
          LengthLimitingTextInputFormatter(50),
        ],
        keyboardType: inputNumberOnly == true ? TextInputType.number : inputEmailOnly == true ? TextInputType.emailAddress : TextInputType.text,
        onChanged: (val) {
          textEditingController?.text = val;
        },
        decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor == null ? Colors.grey.shade300 : borderColor!, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
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
                color: borderColor == null ? Colors.grey.shade300 : borderColor!,
                width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: borderColor == null ? Colors.blue : borderColor!,
                width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        readOnly: readonly,
      ),
      width: width ?? 150.0,
    );
  }
}