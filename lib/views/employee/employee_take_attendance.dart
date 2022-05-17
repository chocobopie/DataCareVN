import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/view_models/attendance_list_view_model.dart';
import 'package:login_sample/view_models/attendance_view_model.dart';
import 'package:login_sample/views/hr/hr_attendance_report_list.dart';
import 'package:login_sample/views/hr/hr_application_list.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/views/employee/employee_attendance_report_list.dart';
import 'package:login_sample/views/employee/employee_send_application.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/hr/hr_attendance_rule.dart';
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
  late DateTime _today;
  bool _isTook = false;
  String _takeAttendanceString = '';

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
                padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 5.0),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('Hôm nay ngày ${DateFormat('dd-MM-yyyy').format(DateTime.now())}', style: const TextStyle(color: defaultFontColor),),
                      const SizedBox(height: 10.0,),

                      //Nút điểm danh
                      Column(
                        children: <Widget>[
                          Center(child: Text(_takeAttendanceString, style: const TextStyle(color: defaultFontColor),)),
                          const SizedBox(height: 20.0,),
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
                            child: (_isTook == false && _timeHms < 14.30 && _timeHms >= 8.30) ? TextButton(
                              onPressed: () async {
                                showLoaderDialog(context);
                                final data = await _takeAttendance(account: _currentAccount);
                                if(data != null){
                                  if(data.attendanceStatusId != 4 && data.periodOfDayId == 0){
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Điểm danh ca sáng thành công')));
                                    setState(() {
                                      _isTook = true;
                                      _takeAttendanceString = 'Bạn đã điểm danh ca sáng';
                                    });
                                  }else if(data.attendanceStatusId != 4 && data.periodOfDayId == 1){
                                    setState(() {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Điểm danh ca chiều thành công')));
                                      _isTook = true;
                                      _takeAttendanceString = 'Bạn đã điểm danh ca chiều';
                                    });
                                  }
                                }else{
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Điểm danh thất bại')));
                                }
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
                              )).then((value) => _getOverallInfo());
                            }
                        ),
                        //Xin đi trễ
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: IconTextButtonSmall2(
                            imageUrl: 'assets/images/late-person.png',
                            text: 'Gửi đơn xin phép',
                            colorsButton: const [Colors.red, Colors.white],
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const EmployeeLateExcuse(),
                              )).then((value) => _getOverallInfo());
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
                              )).then((value) => _getOverallInfo());
                            }
                        ),
                      ),
                      if(_currentAccount.roleId == 1 || _currentAccount.roleId == 2)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          child: IconTextButtonSmall2(
                              imageUrl: 'assets/images/late-excuse.png',
                              text: 'Duyệt đơn xin phép',
                              colorsButton: const [Colors.grey, Colors.white],
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => const HrManagerApplicationList(),
                                )).then((value) => _getOverallInfo());
                              }
                          ),
                        ),
                      if(_currentAccount.roleId == 1)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: IconTextButtonSmall2(
                            imageUrl: 'assets/images/rules.png',
                            text: 'Xem quy định của công ty',
                            colorsButton: const [Colors.blue, Colors.white],
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const HrAttendanceRule(),
                              )).then((value) => _getOverallInfo());
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

  void _getSelfAttendanceList({required bool isRefresh, required int accountId, required int currentPage,DateTime? fromDate, DateTime? toDate}) async {
    List<Attendance>? listAttendance = await AttendanceListViewModel().getSelfAttendanceList(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage, fromDate: fromDate, toDate: toDate);

    _attendances.clear();
    if(listAttendance!.isNotEmpty){
      setState(() {
        _attendances.addAll(listAttendance);
        for(int i = 0; i < _attendances.length; i++){
          if(_timeHms >= 8.30 && _timeHms <= 10.30){
            if(_attendances[i].attendanceStatusId == 4 && _attendances[i].periodOfDayId == 0){
              _isTook = false;
              _takeAttendanceString = 'Bạn chưa điểm danh ca sáng';
            }else if(_attendances[i].attendanceStatusId != 4 && _attendances[i].periodOfDayId == 0){
              _isTook = true;
              _takeAttendanceString = 'Bạn đã điểm danh ca sáng';
            }
          }else if(_timeHms >= 12.30 && _timeHms <= 14.30){
            if(_attendances[i].attendanceStatusId == 4 && _attendances[i].periodOfDayId == 1){
              _isTook = false;
              _takeAttendanceString = 'Bạn chưa điểm danh ca chiều';
            }else if(_attendances[i].attendanceStatusId != 4 && _attendances[i].periodOfDayId == 1){
              _isTook = true;
              _takeAttendanceString = 'Bạn đã điểm danh ca chiều';
            }
          } else{
            _isTook = true;
            _takeAttendanceString = 'Bạn không thể điểm danh vì đã quá giờ hoặc chưa đến giờ điểm danh';
          }
        }
      });
    }else{
      setState(() {
        _isTook = true;
        _takeAttendanceString = 'Hôm nay là ngày nghỉ';
      });
    }
  }

  void _getOverallInfo() async {
      _currentTime = DateTime.now();
      _timeHms = _currentTime.toLocal().hour + (_currentTime.toLocal().minute/100);
      _today = DateTime.parse( DateFormat('yyyy-MM-dd').format(_currentTime) );
      _getSelfAttendanceList(isRefresh: true, accountId: _currentAccount.accountId!, currentPage: 0, fromDate: _today, toDate: _today);
  }

  Future<Attendance?> _takeAttendance({required Account account}) async {

    Attendance? attendance = await AttendanceViewModel().takeAttendance(account: account);

    return attendance;
  }
}