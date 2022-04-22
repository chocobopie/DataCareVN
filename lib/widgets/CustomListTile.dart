import 'package:flutter/material.dart';
import 'package:login_sample/widgets/EditMoneyButton.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.numberEditController,
    required this.listTileLabel,
    required this.alertDialogLabel, this.readOnly,
  }) : super(key: key);

  final TextEditingController numberEditController;
  final String listTileLabel;
  final String alertDialogLabel;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        listTileLabel,
        style: const TextStyle(
          fontSize: 12.0,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            Text(numberEditController.text, style: const TextStyle(fontSize: 12.0,),),
          if(readOnly == false)
          EditMoneyButton(
            numberController: numberEditController,
            label: alertDialogLabel,
          ),
        ],
      ),
    );
  }
}
