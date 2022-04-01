import 'package:flutter/material.dart';
import 'package:login_sample/widgets/CustomListTile.dart';
import 'package:login_sample/utilities/utils.dart';

class PayrollExpansionTile extends StatelessWidget {
  const PayrollExpansionTile({
    Key? key, required this.basicPayrollController, required this.carParkController, required this.fineController, required this.personalInsuranceController, required this.paidInsuranceController, required this.selectMonth,
  }) : super(key: key);

  final TextEditingController basicPayrollController;
  final TextEditingController carParkController;
  final TextEditingController fineController;
  final TextEditingController personalInsuranceController;
  final TextEditingController paidInsuranceController;
  final String selectMonth;

  String calculateMoney(){

    double finalPayroll;
    double basicPayroll = 0;
    double carPark = 0;
    double fine = 0;
    double personalInsurance = 0;
    double paidInsurance = 0;

    if(basicPayrollController.text.isNotEmpty){
      basicPayroll = double.parse(basicPayrollController.text.replaceAll('.', ''));
    }

    if(carParkController.text.isNotEmpty){
      carPark = double.parse(carParkController.text.replaceAll('.', ''));
    }

    if(fineController.text.isNotEmpty){
      fine = double.parse(fineController.text.replaceAll('.', ''));
    }

    if(personalInsuranceController.text.isNotEmpty){
      personalInsurance = double.parse(personalInsuranceController.text.replaceAll('.', ''));
    }

    if(paidInsuranceController.text.isNotEmpty){
      paidInsurance = double.parse(paidInsuranceController.text.replaceAll('.', ''));
    }

    finalPayroll = basicPayroll - carPark - fine - personalInsurance - paidInsurance;

    String finalPayrollString = '${formatNumber(finalPayroll.toString().substring(0, finalPayroll.toString().length - 2).replaceAll('.', ''))} VNĐ';


    return finalPayrollString;
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
          colors: [Colors.blue, Colors.white],
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text('Lương'),
          trailing: Text(calculateMoney().toString()),
          children: <Widget>[
            const Divider(color: Colors.blue, thickness: 1.0,),
            CustomListTile(listTileLabel: 'Lương cơ bản', alertDialogLabel: 'Cập nhật lương cơ bản', numberEditController: basicPayrollController,),
            CustomListTile(listTileLabel: 'Tiền gửi xe', alertDialogLabel: 'Cập nhật tiền gửi xe', numberEditController: carParkController,),
            CustomListTile(listTileLabel: 'Tiền phạt', alertDialogLabel: 'Cập nhật tiền phạt', numberEditController: fineController,),
            CustomListTile(listTileLabel: 'Bảo hiểm cá nhân', alertDialogLabel: 'Cập nhật tiền bảo hiểm cá nhân', numberEditController: personalInsuranceController,),
            CustomListTile(listTileLabel: 'Bảo hiểm công ty đóng', alertDialogLabel: 'Cập nhật tiền bảo hiểm công ty đóng', numberEditController: paidInsuranceController,),
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