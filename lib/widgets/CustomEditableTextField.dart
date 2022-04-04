import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:login_sample/utilities/utils.dart';

class CustomEditableTextFormField extends StatelessWidget {
   const CustomEditableTextFormField({
    Key? key, required this.text, required this.title, required this.readonly, this.textEditingController, this.inputNumberOnly, this.inputEmailOnly, this.onTap, this.borderColor, this.width, this.obscureText, this.isNull, this.citizenIdentity, this.isEmailCheck, this.isPhoneNumber, this.isBankAccountNumber
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
  final bool? citizenIdentity;
  final bool? isEmailCheck;
  final bool? isPhoneNumber;
  final bool? isBankAccountNumber;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        key: Key(text.trim().toString()),
        validator: (isNull != true) ? (value) {
          if(value!.isEmpty){
            return '$title không được bỏ trống';
          }else if(value.isNotEmpty && isEmailCheck == true){
            if(EmailValidator.validate(value) == true){
              return null;
            }
            if(EmailValidator.validate(value) == false){
              return 'Email không đúng định dạng';
            }
          }else if(isPhoneNumber == true){
            if(value.length < 10){
              return 'Số điện thoại phải hơn 9 chữ số';
            }
          }
          return null;
        } : null,
        initialValue: text.trim().toString(),
        onTap: onTap,
        obscureText: obscureText == null ? false : obscureText!,
        minLines: 1,
        maxLines: obscureText == null || obscureText == false ? 5 : 1,
        inputFormatters: (inputNumberOnly == true && citizenIdentity == null && isPhoneNumber == null && isBankAccountNumber == null) ? <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ] : (inputNumberOnly == null && citizenIdentity == null && isPhoneNumber == null && isBankAccountNumber == null) ? <TextInputFormatter>[
          LengthLimitingTextInputFormatter(50),
        ] : (inputNumberOnly == true && citizenIdentity == true && isPhoneNumber == null && isBankAccountNumber == null) ? <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(12),
        ] : (inputNumberOnly == true && isPhoneNumber == true && citizenIdentity == null && isBankAccountNumber == null) ? <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
        ] :(inputNumberOnly == true && isPhoneNumber == null && citizenIdentity == null && isBankAccountNumber == true) ? <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(20),
        ] :<TextInputFormatter>[
          LengthLimitingTextInputFormatter(50),
        ],
        keyboardType: inputNumberOnly == true ? TextInputType.number : inputEmailOnly == true ? TextInputType.emailAddress : TextInputType.text,
        onChanged: (val) {
          textEditingController?.text = val.trim();
        },
        decoration: InputDecoration(
          errorMaxLines: 5,
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