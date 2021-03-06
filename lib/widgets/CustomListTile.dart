import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/EditMoneyButton.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({Key? key, required this.numberEditController, required this.listTileLabel, required this.alertDialogLabel, this.readOnly, this.value, this.moneyFormatType, this.percentFormatType,}) : super(key: key);

  final TextEditingController numberEditController;
  final String listTileLabel;
  final String alertDialogLabel;
  final bool? readOnly;
  final String? value;
  final bool? moneyFormatType;
  final bool? percentFormatType;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        listTileLabel,
        style: const TextStyle(
          fontSize: 14.0,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            Text( numberEditController.text.isEmpty ? value == null ? '0'
                : (percentFormatType == false || percentFormatType == null) ? moneyFormat(value!)
                : '$value%'
                : numberEditController.text + ((percentFormatType == false || percentFormatType == null) ? '' : '%'),
              style: const TextStyle(fontSize: 14.0,),),
          if(readOnly == false || readOnly == null)
          EditMoneyButton(
            numberController: numberEditController,
            label: alertDialogLabel,
            moneyFormatType: moneyFormatType,
            percentFormatType: percentFormatType,
          ),
        ],
      ),
    );
  }
}
