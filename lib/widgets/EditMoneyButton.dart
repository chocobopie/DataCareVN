import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_sample/utilities/utils.dart';

class EditMoneyButton extends StatelessWidget {
  const EditMoneyButton({
    Key? key, required this.numberController, required this.label
  }) : super(key: key);

  final TextEditingController numberController;
  final String label;

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
                decoration: InputDecoration(suffixText: currency),
                keyboardType: TextInputType.number,
                controller: numberController,
                onChanged: (string){
                  string = formatNumber(string.replaceAll('.', ''));
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
                      numberController.value = const TextEditingValue(
                        text: '',
                      );
                      Navigator.pop(context);
                    }
                ),
                TextButton(
                  child: const Text("Lưu"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.edit, color: Colors.green,)
    );
  }
}