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
        name: 'Đỗ Ðức Anh',
        role: 'Nhân viên kinh doanh',
        department: 'Phòng quảng cáo',
        team: 'Nhóm Kiều Thủy',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '2',
        name: 'Tăng Quốc Ðiền',
        role: 'NVKD',
        department: 'Phòng quảng cáo',
        team: 'Nhóm Kiều Thủy',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '3',
        name: 'Phương Thái Ðức',
        role: 'TNKD',
        department: 'Phòng quảng cáo',
        team: 'Nhóm Kiều Thủy',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '4',
        name: 'Đức Ðông Dương',
        role: 'NVKD',
        department: 'Phòng quảng cáo',
        team: 'Nhóm Kiều Thủy',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '5',
        name: 'Chương Tường Lâm',
        role: 'NVKD',
        department: 'Phòng quảng cáo',
        team: 'Nhóm Thúy Anh',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '6',
        name: 'Liễu Quang Tài',
        role: 'TNKD',
        department: 'Phòng đào tạo',
        team: 'Nhóm Thúy Anh',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '7',
        name: 'Cát Trung Thành',
        role: 'NVKD',
        department: 'Phòng đào tạo',
        team: 'Nhóm Thúy Anh',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '8',
        name: 'Ao Hữu Vĩnh',
        role: 'NVKD',
        department: 'Phòng đào tạo',
        team: 'Nhóm Thúy Anh',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '9',
        name: 'Bồ Việt Chính',
        role: 'NVKD',
        department: 'Phòng đào tạo',
        team: 'Nhóm Văn Đại',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '10',
        name: 'Cung Bảo Ðịnh',
        role: 'NVKD',
        department: 'Phòng đào tạo',
        team: 'Nhóm Văn Đại',
        email: 'email',
        payroll: '3.000.000 VNĐ'),
    EmployeePayroll(
        id: '11',
        name: 'Đương Hùng Dũng',
        role: 'TPKD',
        department: 'Phòng đào tạo',
        team: 'Nhóm Văn Đại',
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
                            // const Expanded(
                            //   child: CustomOutlinedButton(
                            //       title: 'Khối',
                            //       radius: 20.0,
                            //       color: mainBgColor
                            //   ),
                            // ),

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
                      final account = empPayrolls[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => HrManagerPayrollDetail(empPayrolls: account,)));
                          },
                          child: Card(
                            elevation: 10.0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[

                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        const Text('Tên nhân viên:'),
                                        const Spacer(),
                                        Text(account.name),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        const Text('Chức vụ:'),
                                        const Spacer(),
                                        Text(account.role),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        const Text('Nhóm:'),
                                        const Spacer(),
                                        Text(account.team),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        const Text('Phòng ban::'),
                                        const Spacer(),
                                        Text(account.department),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
