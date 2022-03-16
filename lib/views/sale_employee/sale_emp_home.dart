import 'package:flutter/material.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/widgets/ImageTextButton.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/sale_employee/emp_issue.dart';
import 'package:login_sample/views/sale_employee/emp_payroll.dart';
import 'package:login_sample/widgets/SideBar.dart';
import 'package:provider/provider.dart';
import 'sale_emp_contact_list.dart';
import 'sale_emp_deal_list.dart';
import 'emp_take_attendance.dart';

class HomeSaleEmployee extends StatefulWidget {
  const HomeSaleEmployee({Key? key}) : super(key: key);

  @override
  _HomeSaleEmployeeState createState() => _HomeSaleEmployeeState();
}

class _HomeSaleEmployeeState extends State<HomeSaleEmployee> {
  @override
  Widget build(BuildContext context) {
    var _account = Provider.of<AccountProvider>(context).account;
    return Scaffold(
      drawer: SideBar(context,
        name: _account.fullname!,
        role: rolesNameUtilities[_account.roleId!],
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
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
              child: ListView(
                padding:
                const EdgeInsets.only(top: 10.0, left: 35.0, bottom: 5.0),
                children: <Widget>[
                  //Hàng 1
                  Row(
                    children: <Widget>[
                      //Nút Thông tin liên lạc của khách hàng
                      ImageTextButton(
                          imageUrl: 'assets/images/my-contact.png',
                          text: 'Xem thông tin khách hàng',
                          buttonColors: const [Colors.blue, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SaleEmpContactList(),
                            ));
                          }
                      ),
                      const SizedBox(width: 20.0,),
                      //Hợp đồng
                      ImageTextButton(
                          imageUrl: 'assets/images/contracts.png',
                          text: 'Xem hợp đồng',
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
                  //Hàng 2
                  Row(
                    children: <Widget>[

                      //Xem lương
                      ImageTextButton(
                          imageUrl: 'assets/images/salary.png',
                          text: 'Xem lương',
                          buttonColors: const [Colors.pink, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const EmpPayroll(),
                            ));
                          }
                      ),
                      const SizedBox(width: 20.0,),

                      //Nút điểm danh
                      ImageTextButton(
                          imageUrl: 'assets/images/attendance-report.png',
                          text: 'Điểm danh',
                          buttonColors: const [Colors.red, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const EmpTakeAttendance(),
                            ));
                          }
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0,),
                  //Hàng 3
                  Row(
                    children: [
                      ImageTextButton(
                          imageUrl: 'assets/images/issue.png',
                          text: 'Xem vấn đề',
                          buttonColors: const [Colors.grey, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const EmpIssue(),
                            ));
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
                "Nhân viên kinh doanh",
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
