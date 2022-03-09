import 'package:flutter/material.dart';
import 'package:login_sample/views/admin/admin_account_list.dart';
import 'package:login_sample/widgets/ImageTextButton.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/sale_employee/emp_take_attendance.dart';
import 'package:login_sample/widgets/SideBar.dart';
import 'hr_manager_account_list.dart';
import 'hr_manager_attendance_report.dart';
import 'hr_manager_payroll_management.dart';

class HomeHRManager extends StatefulWidget {
  const HomeHRManager({Key? key}) : super(key: key);

  @override
  _HomeHRManagerState createState() => _HomeHRManagerState();
}

class _HomeHRManagerState extends State<HomeHRManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(
        context,
        name: 'Họ và tên',
        role: 'Trưởng phòng quản lý nhân sự',
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
              height: MediaQuery.of(context).size.height * 0.3),
          Card(
              elevation: 20.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              margin: const EdgeInsets.only(top: 100.0),
              child: ListView(
                padding: const EdgeInsets.only(top: 20.0, left: 30.0),
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ImageTextButton(
                        imageUrl: 'assets/images/salary.png',
                        text: 'Xem lương',
                        buttonColors: const [Colors.blue, Colors.white],
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HrManagerPayrollManagement(),
                              ));
                        },
                      ),
                      const SizedBox(width: 30.0,),
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
                  Row(
                    children: <Widget>[
                      ImageTextButton(
                          imageUrl: 'assets/images/account_list.png',
                          text: 'Xem danh sách nhân viên',
                          buttonColors: const [Colors.yellow, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const AdminAccountList(),
                            ));
                          }
                      ),

                      const SizedBox(width: 30.0,),
                      ImageTextButton(
                          imageUrl: 'assets/images/attendance-report.png',
                          text: 'Xem báo cáo điểm danh',
                          buttonColors: const [Colors.green, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const HrManagerAttendanceReport(),
                            ));
                          }
                      ),
                    ],
                  ),
                ],
              )),

          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.blueGrey,
              ), // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Quản lý nhân sự",
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
