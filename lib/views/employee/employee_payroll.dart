import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/hr_manager/hr_manager_payroll_list.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_manager/sale_manager_payroll_management.dart';
import 'package:login_sample/widgets/CustomMonthPicker.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';
import 'package:provider/provider.dart';

class EmployeePayroll extends StatefulWidget {
  const EmployeePayroll({Key? key}) : super(key: key);

  @override
  State<EmployeePayroll> createState() => _EmployeePayrollState();
}

class _EmployeePayrollState extends State<EmployeePayroll> {

  DateTime _selectedMonth = DateTime.now();
  late Account _currentAccount = Account();

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomCenter,
                      colors: [mainBgColor, mainBgColor])),
              height: MediaQuery.of(context).size.height * 0.3
          ),
          Card(
              elevation: 20.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
              child: ListView(
                padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 5.0),
                children: <Widget>[
                  Container(
                    width: 200.0,
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: TextButton.icon(
                      onPressed: () async {
                        // _onPressed(context: context);
                        final date = await DatePicker.showPicker(context,
                          pickerModel: CustomMonthPicker(
                            currentTime: DateTime.now(),
                            minTime: DateTime(2016),
                            maxTime: DateTime.now(),
                            locale: LocaleType.vi,
                          ),
                        );

                        if (date != null) {
                          setState(() {
                            _selectedMonth = date;
                            print(_selectedMonth);
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Tháng ${DateFormat('dd-MM-yyyy').format(_selectedMonth).substring(3, 10)}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  //Lương
                  PayrollExpansionTile(
                    selectedDate: _selectedMonth,
                  ),
                  const SizedBox(height: 20.0,),

                  if(_currentAccount.roleId == 1)
                  IconTextButtonSmall2(
                      imageUrl: 'assets/images/payroll-management.png',
                      text: 'Quản lý lương của các nhân viên',
                      colorsButton: const [Colors.green, Colors.white],
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HrManagerPayrollList()));
                      }
                  ),

                  // if(_currentAccount.roleId ==3)
                  //   IconTextButtonSmall2(
                  //       imageUrl: 'assets/images/payroll-management.png',
                  //       text: 'Xem doanh thu của phòng ban',
                  //       colorsButton: const [Colors.green, Colors.white],
                  //       onPressed: (){
                  //         Navigator.push(context, MaterialPageRoute(builder: (context) => const SaleManagerPayrollManagement()));
                  //       }
                  //   ),
                ],
              )
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Xem lương",
                style: TextStyle(
                    letterSpacing: 0.0,
                    fontSize: 20.0,
                    color: Colors.blueGrey
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class BonusExpansionTile2 extends StatelessWidget {
  const BonusExpansionTile2({
    Key? key,
  }) : super(key: key);

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
          trailing: const Text('2.060.500 VNĐ'),
          children: <Widget>[
            const Divider(color: Colors.blueGrey, thickness: 1.0,),
            ListTile(
              title: const Text('Cá nhân', style: TextStyle(fontSize: 12.0,),),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: const <Widget>[
                      Text('Ký mới', style: TextStyle(fontSize: 12.0,),),
                      Text('99.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
                    ],
                  ),
                  const SizedBox(width: 20.0,),
                  Column(
                    children: const <Widget>[
                      Text('Tái ký', style: TextStyle(fontSize: 12.0,),),
                      Text('297.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
                    ],
                  )
                ],
              ),
            ),
            const ListTile(
              title: Text('Quản lý', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('964.500 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            const ListTile(
              title: Text('Người hỗ trợ', style: TextStyle(fontSize: 12.0,),),
            ),
            const ListTile(
              title: Text('CLB 20', style: TextStyle(fontSize: 12.0,),),
            ),
            const ListTile(
              title: Text(
                'Thực nhận',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Text(''
                  '2.060.500 VNĐ',
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

class PayrollExpansionTile extends StatelessWidget {
  const PayrollExpansionTile({
    Key? key, required this.selectedDate,
  }) : super(key: key);

  final DateTime selectedDate;

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
          colors: [Colors.red, Colors.white],
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text('Lương tháng ${DateFormat('dd-MM-yyyy').format(selectedDate).substring(3, 10)}'),
          trailing: const Text('14.670.000 VNĐ'),
          children: const <Widget>[
            Divider(color: Colors.blueGrey, thickness: 1.0,),
            ListTile(
              title: Text('KPI', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('8.500.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text('Hợp đồng đào tạo - Ký mới', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('1.500.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text('Tiền quảng cáo', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('500.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text('Tiền thưởng hỗ trợ sale', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('500.0000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text('Tiền thưởng quản lý Fanpage', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('200.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text('Tiền thưởng quản lý content cho Fanpage', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('700.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text('Cơ bản', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('3.000.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text('Tiền gửi xe', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('30.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text('Tiền phạt', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('0 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text('Bảo hiểm cá nhân', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('100.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text('Bảo hiểm công ty đóng', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('100.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: Text(
                'Thực nhận',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Text(
                '14.670.000 VNĐ',
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
