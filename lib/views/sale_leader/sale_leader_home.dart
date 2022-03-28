import 'package:flutter/material.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/widgets/ImageTextButton.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/sale_employee/sale_emp_contact_list.dart';
import 'package:login_sample/views/sale_employee/sale_emp_deal_list.dart';
import 'package:login_sample/views/employee/employee_issue.dart';
import 'package:login_sample/views/employee/employee_payroll.dart';
import 'package:login_sample/views/employee/employee_take_attendance.dart';
import 'package:login_sample/widgets/SideBar.dart';
import 'package:provider/provider.dart';

class HomeSaleLeader extends StatefulWidget {
  const HomeSaleLeader({Key? key}) : super(key: key);

  @override
  _HomeSaleLeaderState createState() => _HomeSaleLeaderState();
}

class _HomeSaleLeaderState extends State<HomeSaleLeader> {
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
                const EdgeInsets.only(top: 10.0, left: 10.0, right: 18.0, bottom: 5.0),
                children: <Widget>[
                  //Hàng 1
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: <Widget>[
                        //Nút khách hàng của tôi
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                          child: Container(
                            height: 120,
                            width: 150,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const SaleEmpContactList(),
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                                  child: Column(
                                    children: const <Widget>[
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: SizedBox(
                                          child: Image(
                                            image: AssetImage('assets/images/my-contact.png'),
                                            fit: BoxFit.cover,
                                          ),
                                          height: 40.0,
                                          width: 40.0,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            'Thông tin liên lạc khách hàng',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Color.fromARGB(255, 107, 106, 144),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
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
                                stops: [0.04, 0.02],
                                colors: [Colors.blue, Colors.white],
                              ),
                            ),
                          ),
                        ),

                        //Hợp đồng của tôi
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                          child: Container(
                            height: 120,
                            width: 150,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const SaleEmpDealList(),
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                                  child: Column(
                                    children: const <Widget>[
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: SizedBox(
                                          child: Image(
                                            image: AssetImage('assets/images/contracts.png'),
                                            fit: BoxFit.cover,
                                          ),
                                          height: 40.0,
                                          width: 40.0,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            'Hợp đồng',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Color.fromARGB(255, 107, 106, 144),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
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
                                stops: [0.04, 0.02],
                                colors: [Colors.green, Colors.white],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Hàng 2
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        //Nút lương của tôi
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                          child: Container(
                            height: 120,
                            width: 150,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const EmployeePayroll(),
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                                  child: Column(
                                    children: const <Widget>[
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: SizedBox(
                                          child: Image(
                                            image: AssetImage('assets/images/salary.png'),
                                            fit: BoxFit.cover,
                                          ),
                                          height: 40.0,
                                          width: 40.0,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            'Xem lương',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Color.fromARGB(255, 107, 106, 144),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
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
                                stops: [0.04, 0.02],
                                colors: [Colors.pink, Colors.white],
                              ),
                            ),
                          ),
                        ),

                        //Nút  điểm danh
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                          child: Container(
                            height: 120,
                            width: 150,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const EmployeeTakeAttendance(),
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                                  child: Column(
                                    children: const <Widget>[
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: SizedBox(
                                          child: Image(
                                            image: AssetImage('assets/images/attendance-report.png'),
                                            fit: BoxFit.cover,
                                          ),
                                          height: 40.0,
                                          width: 40.0,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            'Điểm danh',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Color.fromARGB(255, 107, 106, 144),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
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
                                stops: [0.04, 0.02],
                                colors: [Colors.red, Colors.white],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Hàng 3
                  // Row(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(top: 20.0, left: 20),
                  //       child: ImageTextButton(
                  //           imageUrl: 'assets/images/issue.png',
                  //           text: 'Vấn đề',
                  //           buttonColors: const [Colors.grey, Colors.white],
                  //           onPressed: (){
                  //             Navigator.push(context, MaterialPageRoute(
                  //               builder: (context) => const EmpIssue(),
                  //             ));
                  //           }
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              )
          ),

          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey,),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Trưởng nhóm kinh doanh",
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

