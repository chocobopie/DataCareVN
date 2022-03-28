import 'package:flutter/material.dart';
import 'package:login_sample/views/sale_manager/sale_manager_payroll_management.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/employee/employee_payroll.dart';

class SaleManagerManagement extends StatelessWidget {
  const SaleManagerManagement({Key? key}) : super(key: key);

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
                  Column(
                    children: <Widget>[
                      IconTextButtonSmall2(
                          imageUrl: 'assets/images/payroll-management.png',
                          text: 'Lương của tôi',
                          colorsButton: const [Colors.green, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const EmployeePayroll()));
                          }
                      ),
                      const SizedBox(height: 20.0,),
                      IconTextButtonSmall2(
                          imageUrl: 'assets/images/payroll-management.png',
                          text: 'Lương và doanh thu của phòng ban',
                          colorsButton: const [Colors.green, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SaleManagerPayrollManagement()));
                          }
                      ),
                    ],
                  )
                ],
              )
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(// Add AppBar here only
              iconTheme: const IconThemeData(color: Colors.blueGrey),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Xem lương",
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
