import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/views/employee/employee_payroll.dart';
import 'package:login_sample/views/sale_manager/sale_manager_kpi_report.dart';
import 'package:login_sample/widgets/ImageTextButton.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/sale_employee/sale_emp_contact_list.dart';
import 'package:login_sample/views/sale_employee/sale_emp_deal_list.dart';
import 'package:login_sample/views/employee/employee_issue.dart';
import 'package:login_sample/views/employee/employee_take_attendance.dart';
import 'package:login_sample/widgets/SideBar.dart';
import 'package:provider/provider.dart';

class HomeSaleManager extends StatefulWidget {
  const HomeSaleManager({Key? key}) : super(key: key);

  @override
  _HomeSaleManagerState createState() => _HomeSaleManagerState();
}

class _HomeSaleManagerState extends State<HomeSaleManager> {
  
  @override
  Widget build(BuildContext context) {
    var _account = Provider.of<AccountProvider>(context).account;
    return Scaffold(
      drawer: SideBar(context,
        name: _account.fullname!,
        role: rolesNames[_account.roleId!],
        imageUrl: 'assets/images/logo.png',
      ),
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
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              margin: const EdgeInsets.only(top: 100.0),
              child: ListView(
                padding: const EdgeInsets.only(top: 10.0, left: 35.0, bottom: 5.0),
                children: <Widget>[
                  //H??ng 1
                  if(_account.roleId != 6)
                  Row(
                    children: <Widget>[
                      //Th??ng tin li??n l???c kh??ch h??ng
                      ImageTextButton(
                          imageUrl: 'assets/images/my-contact.png',
                          text: 'Xem th??ng tin kh??ch h??ng',
                          buttonColors: const [Colors.blue, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SaleEmpContactList(),
                            ));
                          }
                      ),
                      const SizedBox(width: 20.0,),
                      //H???p ?????ng
                      ImageTextButton(
                          imageUrl: 'assets/images/contracts.png',
                          text: 'Xem h???p ?????ng',
                          buttonColors: const [Colors.green, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SaleEmpDealList(),
                            ));
                          }
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0,),
                  //H??ng 2
                  if(_account.roleId != 6)
                  Row(
                    children: <Widget>[
                      //N??t xem l????ng
                      ImageTextButton(
                          imageUrl: 'assets/images/salary.png',
                          text: 'Xem l????ng',
                          buttonColors: const [Colors.pink, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const EmployeePayroll(),
                            ));
                          }
                      ),
                      const SizedBox(width: 20.0,),
                      //N??t ??i???m danh
                      ImageTextButton(
                          imageUrl: 'assets/images/attendance-report.png',
                          text: '??i???m danh',
                          buttonColors: const [Colors.red, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const EmployeeTakeAttendance(),
                            ));
                          }
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0,),
                  // H??ng 3
                  Row(
                    children: [
                      ImageTextButton(
                          imageUrl: 'assets/images/issue.png',
                          text: 'Xem v???n ?????',
                          buttonColors: const [Colors.grey, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const EmployeeIssue(),
                            ));
                          }
                      ),
                      const SizedBox(width: 20.0,),
                      if(_account.roleId != 6)
                      ImageTextButton(
                          imageUrl: 'assets/images/payroll-management.png',
                          text: 'Xem doanh thu c???a ph??ng ban',
                          buttonColors: const [Colors.green, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SaleManagerKpiReportManagement()));
                          }
                      ),
                    ],
                  ),
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
                'Kh???i kinh doanh',
                style: TextStyle(
                  letterSpacing: 0.0,
                  fontSize: 20.0,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
