import 'package:flutter/material.dart';
import 'package:login_sample/widgets/CustomListTile.dart';

class BonusExpansionTile extends StatelessWidget {
  const BonusExpansionTile({
    Key? key,
    required this.personalNewSignController,
    required this.manageController,
    required this.supporterController,
    required this.club20Controller,
    required this.recruitmentController,
    required this.personalBonusController,
    required this.teamBonusController,
    required this.cttdBonusController,
    required this.personalReSignController,
  }) : super(key: key);

  final TextEditingController personalNewSignController;
  final TextEditingController personalReSignController;
  final TextEditingController manageController;
  final TextEditingController supporterController;
  final TextEditingController club20Controller;
  final TextEditingController recruitmentController;
  final TextEditingController cttdBonusController;
  final TextEditingController personalBonusController;
  final TextEditingController teamBonusController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        gradient: const LinearGradient(
          stops: [0.02, 0.01],
          colors: [Colors.green, Colors.white],
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text('Thưởng'),
          trailing: const Text(''),
          children: <Widget>[
            const Divider(
              color: Colors.green,
              thickness: 1.0,
            ),
            CustomListTile(
                numberEditController: personalNewSignController,
                listTileLabel: 'Cá nhân ký mới',
                alertDialogLabel: 'Cập nhật thưởng ký mới'),
            CustomListTile(
                numberEditController: personalReSignController,
                listTileLabel: 'Cá nhân tái ký',
                alertDialogLabel: 'Cập nhật thưởng tái ký'),
            CustomListTile(
                numberEditController: manageController,
                listTileLabel: 'Quản lý',
                alertDialogLabel: 'Cập nhật thưởng quản lý'),
            CustomListTile(
                numberEditController: supporterController,
                listTileLabel: 'Người hỗ trợ',
                alertDialogLabel: 'Cập nhật thưởng người hỗ trợ'),
            CustomListTile(
                numberEditController: club20Controller,
                listTileLabel: 'CLB 20',
                alertDialogLabel: 'Cập nhật thưởng CLB 20'),
            CustomListTile(
                numberEditController: recruitmentController,
                listTileLabel: 'Tuyển dụng',
                alertDialogLabel: 'Cập nhật thưởng tuyển dụng'),
            CustomListTile(
                numberEditController: cttdBonusController,
                listTileLabel: 'Thưởng CTTĐ',
                alertDialogLabel: 'Cập nhật thưởng CTTĐ'),
            CustomListTile(
                numberEditController: personalBonusController,
                listTileLabel: 'Thưởng nóng cá nhân',
                alertDialogLabel: 'Cập nhật thưởng nóng cá nhân'),
            CustomListTile(
                numberEditController: teamBonusController,
                listTileLabel: 'Thưởng nóng nhóm',
                alertDialogLabel: 'Cập nhật thưởng nóng nhóm'),
            const ListTile(
              title: Text(
                'Thực nhận',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Text(
                '',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
