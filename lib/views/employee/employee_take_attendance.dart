import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/WorldTimeAPI.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/models/sort_item.dart';
import 'package:login_sample/view_models/attendance_list_view_model.dart';
import 'package:login_sample/view_models/attendance_view_model.dart';
import 'package:login_sample/view_models/world_time_api_view_model.dart';
import 'package:login_sample/views/hr_manager/hr_manager_attendance_report_list.dart';
import 'package:login_sample/views/hr_manager/hr_manager_late_excuse_list.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/employee/employee_attendance_report_list.dart';
import 'package:login_sample/views/employee/employee_late_excuse.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';
import 'package:provider/provider.dart';

class EmployeeTakeAttendance extends StatefulWidget {
  const EmployeeTakeAttendance({Key? key}) : super(key: key);

  @override
  _EmployeeTakeAttendanceState createState() => _EmployeeTakeAttendanceState();
}

class _EmployeeTakeAttendanceState extends State<EmployeeTakeAttendance> {

  late final List<Attendance> _attendances = [];
  late Account _currentAccount;
  late DateTime _currentTime;
  late double _timeHms;
  late final DateTime _today;
  bool _isTook = false;
  String _takeAttendanceString = '';

  List<UserAttendance> userLateExcuses = [
    UserAttendance(id: '1', name: 'Hồ Phượng Vy', team: 'Nhóm Kiều Trinh', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '2', name: 'Vĩnh Phương Thảo', team: 'Nhóm Minh Nhân', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '3', name: 'Đỗ Xuân Phượng', team: 'Nhóm Phan Minh', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '4', name: 'Ngư Thanh Hà', team: 'Nhóm Trần An', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '5', name: 'Ngô Thu Nhiên', team: 'Nhóm Trần An', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '6', name: 'Vũ Hiền Mai', team: 'Nhóm Trần An', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '7', name: 'Lý Trúc Vy', team: 'Nhóm Trần An', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '8', name: 'Đàm An Bình', team: 'Nhóm Trần An', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '9', name: 'Chung Xuân Nhiên', team: 'Nhóm Trần An', department: 'Đào tạo', attendance: 'Mới'),
  ];

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getOverallInfo();
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
              elevation: 0.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              margin: const EdgeInsets.only(top: 100.0),
              child: _takeAttendanceString.isNotEmpty ? ListView(
                padding: const EdgeInsets.only(top: 10.0, left: 1.0, right: 10.0, bottom: 5.0),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('Hôm nay ngày ${DateFormat('dd-MM-yyyy').format(DateTime.now())}', style: const TextStyle(color: defaultFontColor),),
                      const SizedBox(height: 10.0,),

                      //Nút điểm danh
                      Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25.0),
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

                            child: (_isTook == false && _timeHms < 17) ? TextButton(
                              onPressed: () async {
                                _takeAttendance(account: _currentAccount);
                              },
                              child: const Text(
                                'Điểm danh',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ) : null,
                          ),
                          const SizedBox(height: 10.0,),
                          Text(_takeAttendanceString, style: const TextStyle(color: defaultFontColor),),
                        ],
                      ),
                      const SizedBox(height: 20.0,),
                      //Xem báo cáo điểm danh
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: IconTextButtonSmall2(
                            imageUrl: 'assets/images/attendance-report.png',
                            text: 'Xem báo cáo điểm danh bản thân',
                            colorsButton: const [Colors.green, Colors.white],
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const EmployeeAttendanceReportList(),
                              ));
                            }
                        ),
                        //Xin đi trễ
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: IconTextButtonSmall2(
                            imageUrl: 'assets/images/late-person.png',
                            text: 'Xin đi trễ',
                            colorsButton: const [Colors.red, Colors.white],
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const EmployeeLateExcuse(),
                              ));
                            }
                        ),
                      ),
                      if(_currentAccount.roleId == 2 || _currentAccount.roleId == 1)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: IconTextButtonSmall2(
                            imageUrl: 'assets/images/time-report.png',
                            text: 'Xem báo cáo điểm danh các nhân viên',
                            colorsButton: const [Colors.orange, Colors.white],
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const HrManagerAttendanceReportList(),
                              ));
                            }
                        ),
                      ),
                      if(_currentAccount.roleId == 1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          child: IconTextButtonSmall2(
                              imageUrl: 'assets/images/late-excuse.png',
                              text: 'Duyệt đơn xin phép đi trễ',
                              colorsButton: const [Colors.grey, Colors.white],
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => HrManagerLateExcuseList(
                                    attendanceType: 'Xin phép đi trễ',
                                    userLateExcuses: userLateExcuses,
                                  ),
                                ));
                              }
                          ),
                        ),
                    ],
                  )
                ],
              ) : const Center(child: CircularProgressIndicator()),
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
                "Điểm danh",
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

  void _getAttendanceListByAccountId({required bool isRefresh, required int accountId, required int currentPage,DateTime? fromDate, DateTime? toDate, int? attendanceStatusId}) async {
    List<Attendance> listAttendance = await AttendanceListViewModel().getSelfAttendanceListByAccountId(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage, fromDate: fromDate, toDate: toDate);

    if(listAttendance.isNotEmpty){
      setState(() {
        _attendances.addAll(listAttendance);
        if(_attendances[0].attendanceStatusId == 3){
          _isTook = false;
          _takeAttendanceString = 'Bạn chưa điểm danh cho hôm nay';
        }else{
          _isTook = true;
          _takeAttendanceString = 'Bạn đã điểm danh cho hôm nay';
        }
      });
    }
  }

  void _getOverallInfo() async {
      _currentTime = DateTime.now();
      _timeHms = _currentTime.toLocal().hour + (_currentTime.toLocal().minute/100);
      print(_timeHms);
      _today = DateTime.parse( DateFormat('yyyy-MM-dd').format(_currentTime) );
      _getAttendanceListByAccountId(isRefresh: true, accountId: _currentAccount.accountId!, currentPage: 0, fromDate: _today, toDate: _today);
  }

  void _takeAttendance({required Account account}) async {
    Attendance? attendance = await AttendanceViewModel().takeAttendance(account: account);

    if(attendance != null){
      setState(() {
        _isTook = true;
        _attendances.add(attendance);
      });
    }
  }
}