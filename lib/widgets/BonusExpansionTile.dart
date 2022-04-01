import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomListTile.dart';

class BonusExpansionTile extends StatelessWidget {
  const BonusExpansionTile({
    Key? key,
    this.personalNewSignController,
    this.manageController,
    this.supporterController,
    this.club20Controller,
    this.recruitmentController,
    this.personalBonusController,
    this.teamBonusController,
    this.cttdBonusController,
    this.personalReSignController,
    this.emulationBonusController,
    this.recruitmentBonusController,
  }) : super(key: key);

  final TextEditingController? personalNewSignController;
  final TextEditingController? personalReSignController;
  final TextEditingController? manageController;
  final TextEditingController? supporterController;
  final TextEditingController? club20Controller;
  final TextEditingController? recruitmentController;
  final TextEditingController? cttdBonusController;
  final TextEditingController? personalBonusController;
  final TextEditingController? teamBonusController;
  final TextEditingController? emulationBonusController;
  final TextEditingController? recruitmentBonusController;

  String calculateMoney(){

    double finalBonus;
    double basicPayroll = 0;
    double carPark = 0;
    double fine = 0;
    double personalInsurance = 0;
    double paidInsurance = 0;

    if(emulationBonusController!.text.isNotEmpty){
      basicPayroll = double.parse(emulationBonusController!.text.replaceAll('.', ''));
    }

    if(recruitmentBonusController!.text.isNotEmpty){
      carPark = double.parse(recruitmentBonusController!.text.replaceAll('.', ''));
    }

    if(personalBonusController!.text.isNotEmpty){
      fine = double.parse(personalBonusController!.text.replaceAll('.', ''));
    }

    if(teamBonusController!.text.isNotEmpty){
      personalInsurance = double.parse(teamBonusController!.text.replaceAll('.', ''));
    }


    finalBonus = basicPayroll + carPark + fine + personalInsurance + paidInsurance;

    String finalBonusString = '${formatNumber(finalBonus.toString().substring(0, finalBonus.toString().length - 2).replaceAll('.', ''))} VNĐ';


    return finalBonusString;
  }

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
          trailing: Text(calculateMoney().toString()),
          children: <Widget>[
            const Divider(
              color: Colors.green,
              thickness: 1.0,
            ),
            CustomListTile(
                numberEditController: emulationBonusController!,
                listTileLabel: 'Thưởng thi đua',
                alertDialogLabel: 'Cập nhật thưởng thi đua'),
            CustomListTile(
                numberEditController: recruitmentBonusController!,
                listTileLabel: 'Thưởng tuyển dụng',
                alertDialogLabel: 'Cập nhật thưởng tuyển dụng'),
            CustomListTile(
                numberEditController: personalBonusController!,
                listTileLabel: 'Thưởng nóng cá nhân',
                alertDialogLabel: 'Cập nhật thưởng nóng cá nhân'),
            CustomListTile(
                numberEditController: teamBonusController!,
                listTileLabel: 'Thưởng nóng nhóm',
                alertDialogLabel: 'Cập nhật thưởng nóng nhóm'),
            ListTile(
              title: const Text(
                'Thực nhận',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Text(
                calculateMoney().toString(),
                style: const TextStyle(
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
