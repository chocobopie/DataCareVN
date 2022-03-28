import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/fromDateToDate.dart';
import 'package:login_sample/views/hr_manager/hr_manager_attendance_report_list.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/sale_employee/sale_emp_date_filter.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:number_paginator/number_paginator.dart';

class EmployeeLateExcuseList extends StatefulWidget {
  const EmployeeLateExcuseList({Key? key}) : super(key: key);

  @override
  _EmployeeLateExcuseListState createState() => _EmployeeLateExcuseListState();
}

class _EmployeeLateExcuseListState extends State<EmployeeLateExcuseList> {

  String fromDateToDateString = 'Ngày gửi đơn';
  DateTime? _fromDate, _toDate;


  List<UserAttendance> userLateExcuses = [
    UserAttendance(id: '1', name: 'Nguyễn Văn A', team: 'Nhóm 1', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '2', name: 'Nguyễn Văn B', team: 'Nhóm 2', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '3', name: 'Nguyễn Văn C', team: 'Nhóm 3', department: 'Đào tạo', attendance: 'Chấp nhận'),
    UserAttendance(id: '4', name: 'Nguyễn Văn D', team: 'Nhóm 4', department: 'Đào tạo', attendance: 'Chấp nhận'),
    UserAttendance(id: '5', name: 'Nguyễn Văn E', team: 'Nhóm 5', department: 'Đào tạo', attendance: 'Chấp nhận'),
    UserAttendance(id: '6', name: 'Nguyễn Văn F', team: 'Nhóm 6', department: 'Đào tạo', attendance: 'Chấp nhận'),
    UserAttendance(id: '7', name: 'Nguyễn Văn G', team: 'Nhóm 7', department: 'Đào tạo', attendance: 'Từ chối'),
    UserAttendance(id: '8', name: 'Nguyễn Văn H', team: 'Nhóm 8', department: 'Đào tạo', attendance: 'Từ chối'),
    UserAttendance(id: '9', name: 'Nguyễn Văn I', team: 'Nhóm 9', department: 'Đào tạo', attendance: 'Từ chối'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Card(
        elevation: 10.0,
        child: NumberPaginator(
          numberPages: 10,
          buttonSelectedBackgroundColor: mainBgColor,
          onPageChange: (int index) {

          },
        ) ,
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
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            margin: const EdgeInsets.only(top: 90),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text('Lọc theo:', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                      const SizedBox(width: 10.0,),
                      Expanded(
                        child: CustomOutlinedButton(
                            title: fromDateToDateString,
                            radius: 10.0,
                            color: mainBgColor,
                            onPressed: () async {
                            final data = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SaleEmpDateFilter(),
                            ));
                            if(data != null){
                              FromDateToDate fromDateToDate = data;
                              setState(() {
                                _fromDate = fromDateToDate.fromDate;
                                _toDate = fromDateToDate.toDate;
                                fromDateToDateString = '${fromDateToDate.fromDateString} → ${fromDateToDate.toDateString}';
                              });
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomOutlinedButton(
                          title: 'Trạng thái',
                          radius: 10,
                          color: mainBgColor,
                          onPressed: (){},
                        ),
                      ),
                      IconButton(
                          onPressed: (){
                            setState(() {
                              _fromDate = null;
                              _toDate = null;
                              fromDateToDateString = 'Ngày gửi đơn';
                            });
                          },
                          icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                      ),
                    ],
                  )
                ],
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.20),
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
                elevation: 100.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                margin: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.01),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Row(
                        children: const <Widget>[
                          Text('Ngày gửi', style: TextStyle(color: defaultFontColor),),
                          Spacer(),
                          Text('Ngày xin đi trễ', style: TextStyle(color: defaultFontColor),),
                          Spacer(),
                          Text('Trạng thái', style: TextStyle(color: defaultFontColor),)
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: userLateExcuses.length,
                          itemBuilder: (context, index){
                            final userLateExcuse = userLateExcuses[index];
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                              child: Card(
                                elevation: 5,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                ),
                                child: ListTile(
                                  trailing: Text(userLateExcuse.attendance, style: TextStyle(
                                      color: userLateExcuse.attendance != 'Mới'
                                          ? (userLateExcuse.attendance != 'Chấp nhận')
                                          ? Colors.red : Colors.blue : Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                  ),
                                  leading: SizedBox(
                                    height: 50.0,
                                    width: 200.0,
                                    child: Row(
                                      children: [
                                        Column(
                                          children: <Widget>[
                                            const SizedBox(height: 15.0,),
                                            Text(DateFormat('dd-MM-yyyy').format(DateTime.now())),
                                          ],
                                        ),
                                        const SizedBox(width: 40.0,),
                                        const Spacer(),
                                        Column(
                                          children: <Widget>[
                                            const SizedBox(height: 15.0,),
                                            Text(DateFormat('dd-MM-yyyy').format(DateTime.now())),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              // Add AppBar here only
              iconTheme: const IconThemeData(color: Colors.blueGrey),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Danh sách đơn xin đi trễ",
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
