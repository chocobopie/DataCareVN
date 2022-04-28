import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/models/fromDateToDate.dart';
import 'package:login_sample/models/sort_item.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/attendance_list_view_model.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_date_filter.dart';
import 'package:login_sample/widgets/CustomDropDownFormField2Filter.dart';
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
  int? _periodOfDayId, _attendanceStatusId;
  String _fromDateToDateString = 'Ngày';
  DateTime? _fromDate, _toDate;
  late DateTime _currentTime, _today;
  late double _timeHmsNow;

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getSelfAttendanceList(isRefresh: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCurrentTime();
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
          initialPage: 0,
          buttonSelectedBackgroundColor: mainBgColor,
          onPageChange: (int index) {
            setState(() {
              if(index >= _maxPages){
                index = 0;
                _currentPage = index;
              }else{
                _currentPage = index;
              }
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
              margin: const EdgeInsets.only(top: 90.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 2.0,),
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
                          const SizedBox(width: 5.0,),
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
                                  _fromDateToDateString = 'Ngày ${fromDateToDate.fromDateString} → ${fromDateToDate.toDateString}';
                                  _attendances.clear();
                                  _maxPages = _currentPage = 0;
                                });
                                _refreshController.resetNoData();
                                _getSelfAttendanceList(isRefresh: true);
                              }
                            },
                          ),
                          const SizedBox(width: 5.0,),
                          SizedBox(
                            width: 110.0,
                            child: CustomDropdownFormField2Filter(
                              value: _periodOfDayId == null ? null : periodOfDayNamesFilter[_periodOfDayId!],
                              borderColor: mainBgColor,
                              items: periodOfDayNamesFilter,
                              label: 'Ca làm việc',
                              onChanged: (value){
                                for(int i = 0; i < periodOfDay.length; i++){
                                  if(value.toString() == periodOfDay[i].name){
                                    _periodOfDayId = periodOfDay[i].periodOfDayId;
                                    setState(() {
                                      _maxPages = _currentPage = 0;
                                      _attendances.clear();
                                    });
                                  }
                                }
                                _getSelfAttendanceList(isRefresh: true);
                              },
                            ),
                          ),
                          const SizedBox(width: 5.0,),
                          DropdownButton2(
                            underline: const SizedBox(),
                            buttonElevation: 0,
                            customButton: Icon(
                              Icons.timelapse,
                              size: 40,
                              color: _attendanceStatusId != null ? _attendanceStatusId != 4 ? _attendanceStatusId != 3 ? _attendanceStatusId != 2 ? _attendanceStatusId != 1
                                  ? Colors.green : Colors.blue : Colors.purple : Colors.brown : Colors.red
                                  : mainBgColor,
                            ),
                            items: [
                              ...SortItems.firstItems.map(
                                    (item) =>
                                    DropdownMenuItem<SortItem>(
                                      value: item,
                                      child: SortItems.buildItem(item),
                                    ),
                              ),
                            ],
                            onChanged: (value) {
                              _attendanceStatusId = SortItems.onChanged(context, value as SortItem);
                              setState(() {
                                _maxPages = _currentPage = 0;
                                _attendances.clear();
                              });
                              _getSelfAttendanceList(isRefresh: true);
                            },
                            itemHeight: 40,
                            itemPadding: const EdgeInsets.only(left: 5, right: 5),
                            dropdownWidth: 200,
                            dropdownPadding: const EdgeInsets.symmetric(vertical: 5),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            dropdownElevation: 8,
                            offset: const Offset(0, 8),
                          ),
                          IconButton(
                              onPressed: (){
                                setState(() {
                                  _attendances.clear();
                                  _fromDate = null;
                                  _toDate = null;
                                  _attendanceStatusId = null;
                                  _fromDateToDateString = 'Ngày';
                                  _periodOfDayId = null;
                                  _maxPages = _currentPage = 0;
                                });
                                _refreshController.resetNoData();
                                _getSelfAttendanceList(isRefresh: true);
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
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.18),
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
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0, top: 15.0, bottom: 15.0, right: 5.0),
                                    child: Row(
                                      children: [
                                        Text(DateFormat('dd-MM-yyyy').format(_attendance.date)),
                                        const Spacer(),
                                        Expanded(child: Text(periodOfDayNames[_attendance.periodOfDayId])),
                                        const Spacer(),
                                        if(_attendance.attendanceStatusId == 4 && ( (_timeHmsNow <= 9.30 && _timeHmsNow > 0 && _attendance.periodOfDayId == 0) || (_timeHmsNow <= 13.30 && _timeHmsNow > 0 && _attendance.periodOfDayId == 1) ) && _attendance.date == _today)
                                          const Expanded(child: Text('Chưa điểm danh', style: TextStyle(color: Colors.grey),),),
                                        if(_attendance.attendanceStatusId != 4 && ( (_timeHmsNow <= 9.30 && _timeHmsNow > 0 && _attendance.periodOfDayId == 0) || (_timeHmsNow <= 13.30 && _timeHmsNow > 0 && _attendance.periodOfDayId == 1) ) && _attendance.date == _today)
                                          Expanded(child: Text(attendanceStatusNames[_attendance.attendanceStatusId],
                                            style: TextStyle(color: _attendance.attendanceStatusId != 4
                                                ? _attendance.attendanceStatusId != 3
                                                ? _attendance.attendanceStatusId != 2
                                                ? _attendance.attendanceStatusId != 1 ? Colors.green
                                                : Colors.blue : Colors.purple : Colors.brown : Colors.red,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0
                                            ),
                                          ),),
                                        if( ( (_timeHmsNow > 9.30 && _attendance.periodOfDayId == 0 ) || (_timeHmsNow > 13.30 && _attendance.periodOfDayId == 1) ) && _attendance.date == _today)
                                          Expanded(child: Text(attendanceStatusNames[_attendance.attendanceStatusId],
                                            style: TextStyle(color: _attendance.attendanceStatusId != 4
                                                ? _attendance.attendanceStatusId != 3
                                                ? _attendance.attendanceStatusId != 2
                                                ? _attendance.attendanceStatusId != 1 ? Colors.green
                                                : Colors.blue : Colors.purple : Colors.brown : Colors.red,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0
                                            ),
                                          ),),
                                        if(_attendance.date != _today)
                                          Expanded(child: Text(attendanceStatusNames[_attendance.attendanceStatusId],
                                            style: TextStyle(color: _attendance.attendanceStatusId != 4
                                                ? _attendance.attendanceStatusId != 3
                                                ? _attendance.attendanceStatusId != 2
                                                ? _attendance.attendanceStatusId != 1 ? Colors.green
                                                : Colors.blue : Colors.purple : Colors.brown : Colors.red,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0
                                            ),
                                          ),),
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
  }
}

class SortItems {
  static const List<SortItem> firstItems = [onTime, lateAccepted, dayOffAccepted, late, absent];

  static const onTime = SortItem(text: 'Đúng giờ', icon: Icon(Icons.access_time_filled, color: Colors.green));
  static const lateAccepted = SortItem(text: 'Cho phép trễ', icon: Icon(Icons.access_time_filled, color: Colors.blue));
  static const dayOffAccepted = SortItem(text: 'Cho phép nghỉ', icon: Icon(Icons.access_time_filled, color: Colors.purple));
  static const late = SortItem(text: 'Trễ', icon: Icon(Icons.access_time_filled, color: Colors.brown));
  static const absent = SortItem(text: 'Vắng', icon: Icon(Icons.access_time_filled, color: Colors.red));


  static Widget buildItem(SortItem item) {
    return Row(
      children: [
        item.icon,
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: defaultFontColor,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, SortItem item) {
    switch (item) {
      case SortItems.onTime:
        return 0;
      case SortItems.lateAccepted:
        return 1;
      case SortItems.dayOffAccepted:
        return 2;
      case SortItems.late:
        return 3;
      case SortItems.absent:
        return 4;
    }
  }
}