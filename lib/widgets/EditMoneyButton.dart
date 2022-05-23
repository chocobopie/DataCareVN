import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_sample/utilities/utils.dart';

class EditMoneyButton extends StatelessWidget {
  const EditMoneyButton({
    Key? key, required this.numberController, required this.label, this.moneyFormatType, this.percentFormatType
  }) : super(key: key);

  final TextEditingController numberController;
  final String label;
  final bool? moneyFormatType;
  final bool? percentFormatType;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: TextFormField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                minLines: 2,
                maxLines: 5,
                decoration: (moneyFormatType == true || moneyFormatType == null) ? InputDecoration(suffixText: currency) : null,
                keyboardType: (percentFormatType == false || percentFormatType == null) ? TextInputType.number : const TextInputType.numberWithOptions(decimal: true, signed: true),
                controller: numberController,
                onChanged: (string){
                  if(moneyFormatType == true || moneyFormatType == null){
                    string = formatNumber(string.replaceAll('.', ''));
                  }
                  numberController.value = TextEditingValue(
                    text: string,
                    selection: TextSelection.collapsed(offset: string.length),
                  );

                },
              ),
              title: Text(label, style: const TextStyle(color: defaultFontColor, fontSize: 16.0),),
              actions: <Widget>[
                TextButton(
                    child: const Text("Huỷ"),
                    onPressed: (){
                      if(numberController.text.isNotEmpty){
                        numberController.clear();
                      }
                      Navigator.pop(context);
                    }
                ),
                TextButton(
                  child: const Text("Lưu"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.edit, color: Colors.green,)
    );
  }
}