import 'package:flutter/material.dart';
import 'package:login_sample/widgets/EditMoneyButton.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.numberEditController,
    required this.listTileLabel,
    required this.alertDialogLabel,
  }) : super(key: key);

  final TextEditingController numberEditController;
  final String listTileLabel;
  final String alertDialogLabel;

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
          if (listTileLabel == 'Gửi xe' ||
              listTileLabel == 'Tiền phạt' ||
              listTileLabel == 'Bảo hiểm cá nhân' ||
              listTileLabel == 'Bảo hiểm công ty đóng')
            Text(
              '- ${numberEditController.text}',
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          if (listTileLabel == 'Cơ bản' ||
              listTileLabel == 'Quản lý' ||
              listTileLabel == 'Người hỗ trợ' ||
              listTileLabel == 'CLB 20' ||
              listTileLabel == 'Tuyển dụng' ||
              listTileLabel == 'Thưởng CTTĐ' ||
              listTileLabel == 'Thưởng nóng cá nhân' ||
              listTileLabel == 'Thưởng nóng nhóm' ||
              listTileLabel == 'Cá nhân ký mới' ||
              listTileLabel == 'Cá nhân tái ký'
          )
            Text(
              '+ ${numberEditController.text}',
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          EditMoneyButton(
            numberController: numberEditController,
            label: alertDialogLabel,
          ),
        ],
      ),
    );
  }
}
