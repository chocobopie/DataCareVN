import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/models/fromDateToDate.dart';
import 'package:login_sample/models/sort_item.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/attendance_list_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_date_filter.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EmployeeAttendanceReportList extends StatefulWidget {
  const EmployeeAttendanceReportList({Key? key}) : super(key: key);

  @override
  _EmployeeAttendanceReportListState createState() => _EmployeeAttendanceReportListState();
}

class _EmployeeAttendanceReportListState extends State<EmployeeAttendanceReportList> {


  late final List<Attendance> _attendances = [];
  late Account _currentAccount;
  int _currentPage = 0, _maxPages = 0;
  int? _periodOfDayId, _attendanceStatusId, _periodOfDayNowLocal;
  String _fromDateToDateString = 'Ngày';
  DateTime? _fromDate, _toDate;
  late DateTime _currentTime;
  late double _timeHmsNow;
  late final DateTime _today;

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCurrentTime();
    _getSelfAttendanceList(isRefresh: true);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Card(
        elevation: 10.0,
        child: _maxPages > 0 ? NumberPaginator(
          numberPages: _maxPages,
          buttonSelectedBackgroundColor: mainBgColor,
          onPageChange: (int index) {
            setState(() {
              _currentPage = index;
              _attendances.clear();
            });
            _getSelfAttendanceList(isRefresh: false);
          },
        ) : null,
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
              margin: const EdgeInsets.only(top: 80.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10, right: 10.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text('Lọc theo:', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                          ),
                          const SizedBox(width: 10.0,),
                          // CustomDropdownFormField2(
                          //     label: 'Trạng thái',
                          //     hintText: const Text(''),
                          //     items: attendanceStatusNames,
                          //     onChanged: null
                          // ),
                          CustomOutlinedButton(
                              title: 'Trạng thái',
                              radius: 10,
                              color: mainBgColor,
                              onPressed: (){},
                          ),
                          CustomOutlinedButton(
                            title: _fromDateToDateString,
                            radius: 10,
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
                                  _fromDateToDateString = '${fromDateToDate.fromDateString} → ${fromDateToDate.toDateString}';
                                  _attendances.clear();
                                });
                                _refreshController.resetNoData();
                              }
                            },
                          ),
                          IconButton(
                              onPressed: (){
                                setState(() {
                                  _attendances.clear();
                                  _fromDate = null;
                                  _toDate = null;
                                  _fromDateToDateString = 'Ngày';
                                });
                                _refreshController.resetNoData();
                              },
                              icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              )
          ),

          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.19),
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
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                child: _attendances.isNotEmpty ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0, right: 30.0),
                      child: Row(
                        children: const <Widget>[
                          Expanded(child: Text('Ngày', style: TextStyle(color: defaultFontColor),), flex: 1,),
                          Spacer(),
                          Expanded(child: Text('Ca làm việc', style: TextStyle(color: defaultFontColor),), flex: 0,),
                          Spacer(),
                          Expanded(child: Text('Trạng thái', style: TextStyle(color: defaultFontColor),), flex: 0,)
                        ],
                      ),
                    ),
                    Expanded(
                      child: SmartRefresher(
                        controller: _refreshController,
                        enablePullUp: true,
                        onRefresh: () async {
                          setState(() {
                            _attendances.clear();
                          });
                          _getSelfAttendanceList(isRefresh: false);


                          if(_attendances.isNotEmpty){
                            _refreshController.refreshCompleted();
                          }else{
                            _refreshController.refreshFailed();
                          }
                        },
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              final _attendance = _attendances[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0, left: 5.0, right: 5.0),
                                child: Card(
                                  elevation: 5,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0, top: 15.0, bottom: 15.0, right: 5.0),
                                    child: Row(
                                      children: [
                                        Text(DateFormat('dd-MM-yyyy').format(_attendance.date)),
                                        const Spacer(),
                                        Expanded(child: Text(periodOfDayNames[_attendance.periodOfDayId])),
                                        const Spacer(),
                                        if(_attendance.attendanceStatusId == 4 && ( _periodOfDayNowLocal == _attendance.periodOfDayId ) && _attendance.date == _today)
                                          const Expanded(child: Text('Chưa điểm danh', style: TextStyle(color: Colors.grey),),),
                                        if(_periodOfDayNowLocal != _attendance.periodOfDayId || _attendance.date != _today)
                                          Expanded(child: Text(attendanceStatusNames[_attendance.attendanceStatusId]),),
                                      ],
                                    ),
                                  )
                                ),
                              );
                            },
                            itemCount: _attendances.length
                        ),
                      ),
                    ),
                  ],
                ) : const Center(child: CircularProgressIndicator())
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),
              // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                'Báo cáo điểm danh',
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

  void _getSelfAttendanceList({required bool isRefresh}) async {
    List<Attendance>? listAttendance = await AttendanceListViewModel().getSelfAttendanceList(
      accountId: _currentAccount.accountId!, currentPage: _currentPage, isRefresh: isRefresh,
      periodOfDayId: _periodOfDayId, fromDate: _fromDate, toDate: _toDate, attendanceStatusId: _attendanceStatusId,
    );

    _attendances.clear();
    if(listAttendance != null){
      setState(() {
        _attendances.addAll(listAttendance);
        _maxPages = _attendances[0].maxPage!;
      });
    }else{
      setState(() {
        _refreshController.loadNoData();
      });
    }
  }

  void _getCurrentTime() async {
    _currentTime = DateTime.now();
    _timeHmsNow = _currentTime.toLocal().hour + (_currentTime.toLocal().minute/100);
    _today = DateTime.parse( DateFormat('yyyy-MM-dd').format(_currentTime) );
    if(_timeHmsNow <= 10.30) _periodOfDayNowLocal = 0;
    if(_timeHmsNow > 12 && _timeHmsNow < 17.30) _periodOfDayNowLocal = 1;
  }
}