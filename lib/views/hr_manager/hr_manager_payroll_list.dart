import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/hr_manager/hr_manager_payroll_detail.dart';
import 'package:login_sample/widgets/CustomFilterFormField.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';

class HrManagerPayrollList extends StatefulWidget {
  const HrManagerPayrollList({Key? key}) : super(key: key);

  @override
  _HrManagerPayrollListState createState() => _HrManagerPayrollListState();
}

class _HrManagerPayrollListState extends State<HrManagerPayrollList> {
  List<EmployeePayroll> empPayrolls = [
    EmployeePayroll(
        id: '1',
        name: 'Tên 1',
        role: 'NVKD',
        department: 'Ban 1',
        team: 'Nhóm A',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '2',
        name: 'Tên 2',
        role: 'NVKD',
        department: 'Ban 2',
        team: 'Nhóm B',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '3',
        name: 'Tên 3',
        role: 'TNKD',
        department: 'Ban 3',
        team: 'Nhóm C',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '4',
        name: 'Tên 4',
        role: 'NVKD',
        department: 'Ban 4',
        team: 'Nhóm D',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '5',
        name: 'Tên 5',
        role: 'NVKD',
        department: 'Ban 5',
        team: 'Nhóm E',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '6',
        name: 'Tên 6',
        role: 'TNKD',
        department: 'Ban 6',
        team: 'Nhóm F',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '7',
        name: 'Tên 7',
        role: 'NVKD',
        department: 'Ban 7',
        team: 'Nhóm G',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '8',
        name: 'Tên 8',
        role: 'NVKD',
        department: 'Ban 8',
        team: 'Nhóm H',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '9',
        name: 'Tên 9',
        role: 'NVKD',
        department: 'Ban 9',
        team: 'Nhóm I',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '10',
        name: 'Tên 10',
        role: 'NVKD',
        department: 'Ban 10',
        team: 'Nhóm K',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '11',
        name: 'Tên 11',
        role: 'TPKD',
        department: 'Ban 11',
        team: 'Nhóm L',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
  ];

  @override
  Widget build(BuildContext context) {
    double leftRight = MediaQuery.of(context).size.width * 0.05;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomCenter,
                      colors: [mainBgColor, mainBgColor])),
              height: MediaQuery.of(context).size.height * 0.15),
          Card(
              elevation: 20.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              margin: const EdgeInsets.only(top: 80.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                    child: Column(
                      children: <Widget>[
                        const Text('LỌC THEO', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                        Row(
                          children: <Widget>[
                            const Expanded(
                              child: CustomOutlinedButton(
                                  title: 'Khối',
                                  radius: 20.0,
                                  color: mainBgColor
                              ),
                            ),

                            const Expanded(
                              child: CustomOutlinedButton(
                                  title: 'Phòng ban',
                                  radius: 20.0,
                                  color: mainBgColor
                              ),
                            ),

                            const Expanded(
                              child: CustomOutlinedButton(
                                  title: 'Nhóm',
                                  radius: 20,
                                  color: mainBgColor
                              ),
                            ),

                            const Expanded(
                              child: CustomOutlinedButton(
                                  title: 'Chức vụ',
                                  radius: 20,
                                  color: mainBgColor
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,),
                              onPressed: () {
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   child: TextField(
                  //     autofocus: true,
                  //     readOnly: true,
                  //     decoration: InputDecoration(
                  //       floatingLabelBehavior: FloatingLabelBehavior.always,
                  //       contentPadding: const EdgeInsets.only(left: 20.0),
                  //       labelText: 'Số nhân viên',
                  //       hintText: '${empPayrolls.length}',
                  //       labelStyle: const TextStyle(
                  //         color: Color.fromARGB(255, 107, 106, 144),
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide:
                  //             const BorderSide(color: Colors.blue, width: 2),
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide:
                  //             const BorderSide(color: Colors.blue, width: 2),
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     ),
                  //   ),
                  //   width: 150.0,
                  // ),
                ],
              )),

          //Card dưới
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.21),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                elevation: 20.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: ListView.builder(
                    itemCount: empPayrolls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: leftRight,
                            right: leftRight,
                            bottom: leftRight),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: ListTile(
                            title: Text(empPayrolls[index].name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, right: 20.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Phòng ban: ${empPayrolls[index].department}',
                                        style: const TextStyle(fontSize: 12.0),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        'Nhóm: ${empPayrolls[index].team}',
                                        style: const TextStyle(fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    children: <Widget>[
                                      const Text(
                                        'Tiền lương',
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        empPayrolls[index].payroll,
                                        style: const TextStyle(fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            dense: true,
                            subtitle: Text(empPayrolls[index].role),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HrManagerPayrollDetail(
                                            empPayrolls: empPayrolls[index],
                                          )));
                            },
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),

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
                "Quản lý lương của các nhân viên",
                style: TextStyle(
                  letterSpacing: 0.0,
                  fontSize: 18.0,
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

class EmployeePayroll {
  String id;
  String name;
  String role;
  String department;
  String team;
  String email;
  String payroll;

  EmployeePayroll({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.team,
    required this.email,
    required this.payroll,
  });
}
