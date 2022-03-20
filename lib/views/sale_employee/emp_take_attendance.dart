import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/WorldTimeAPI.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/view_models/attendance_list_view_model.dart';
import 'package:login_sample/view_models/attendance_view_model.dart';
import 'package:login_sample/view_models/world_time_api_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/emp_attendance_report.dart';
import 'package:login_sample/views/sale_employee/emp_late_excuse.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';
import 'package:provider/provider.dart';

class EmpTakeAttendance extends StatefulWidget {
  const EmpTakeAttendance({Key? key}) : super(key: key);

  @override
  _EmpTakeAttendanceState createState() => _EmpTakeAttendanceState();
}

class _EmpTakeAttendanceState extends State<EmpTakeAttendance> {

  late final List<Attendance> _attendances = [];
  late Account currentAccount;
  late DateTime _currentTime;
  late double _timeHms;
  late final DateTime _today;
  bool isTook = false;
  String takeAttendanceString = '';

  @override
  void initState() {
    super.initState();
    currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCorrectData();
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
              child: takeAttendanceString.isNotEmpty ? ListView(
                padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 5.0),
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
                              color: isTook == false ? Colors.red : mainBgColor,
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
                            child: TextButton(
                              onPressed: isTook == false ? () async {
                                // _getCorrectData();
                                // Attendance attendance = Attendance(
                                //     accountId: currentAccount.accountId!,
                                //     date: _currentTime.toLocal(),
                                //     attendanceStatusId: _timeHms <= 9.0 ? 0 : 2
                                // );
                                // final data = await AttendanceViewModel().takeAttendance(attendance: attendance);
                                // if(data.attendanceStatusId.toString().isNotEmpty){
                                //   setState(() {
                                //     isTook = true;
                                //     takeAttendanceString = 'Bạn đã điểm danh cho hôm nay';
                                //   });
                                // }
                              } : null,
                              child: Text(
                                takeAttendanceString,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),
                      //Xem báo cáo điểm danh
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: IconTextButtonSmall2(
                            imageUrl: 'assets/images/attendance-report.png',
                            text: 'Xem báo cáo điểm danh',
                            colorsButton: const [Colors.green, Colors.white],
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const EmpAttendanceReport(),
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
                                builder: (context) => const EmpLateExcuse(),
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
    List<Attendance> listAttendance = await AttendanceListViewModel().getAttendanceListByAccountId(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage, fromDate: fromDate, toDate: toDate);

    if(listAttendance.isNotEmpty){
      setState(() {
        _attendances.addAll(listAttendance);
        isTook = true;
        takeAttendanceString = 'Bạn đã điểm danh cho hôm nay';
      });
    }else{
      setState(() {
        takeAttendanceString = 'Điểm danh hôm nay';
      });
      isTook;
    }
  }

  void _getCorrectData() async {
    WorldTimeApi data = await WorldTimeApiViewModel().getCorrectTime();

    if(data.datetime.toString().isNotEmpty){
      _currentTime = data.datetime;
      _timeHms = _currentTime.toLocal().hour + (_currentTime.toLocal().minute/100);
      _today = DateTime.parse( DateFormat('yyyy-MM-dd').format(_currentTime) );
      _getAttendanceListByAccountId(isRefresh: true, accountId: currentAccount.accountId!, currentPage: 0, fromDate: _today, toDate: _today);
    }
  }
}