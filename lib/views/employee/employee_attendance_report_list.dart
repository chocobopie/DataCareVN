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
  final RefreshController _refreshController = RefreshController();
  String _fromDateToDateString = 'Ngày';
  DateTime? _fromDate, _toDate;
  bool _isAsc = true;
  late DateTime _currentTime;
  late double _timeHms;
  late final DateTime _today;

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getSelfAttendanceListByAccountId(isRefresh: true, accountId: _currentAccount.accountId!, currentPage: _currentPage);
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
          buttonSelectedBackgroundColor: mainBgColor,
          onPageChange: (int index) {

            setState(() {
              _currentPage = index;
              _attendances.clear();
            });
            if(_fromDate == null && _toDate == null){
              _getSelfAttendanceListByAccountId(isRefresh: false, accountId: _currentAccount.accountId!, currentPage: _currentPage);
            }else if(_toDate != null && _fromDate != null){
              _getSelfAttendanceListByAccountId(isRefresh: false, accountId: _currentAccount.accountId!, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate);
            }
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
                padding: const EdgeInsets.only(left: 15.0, top: 20, right: 15.0),
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
                                _getSelfAttendanceListByAccountId(isRefresh: true, accountId: _currentAccount.accountId!, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate);
                              }
                            },
                          ),
                          DropdownButton2(
                            customButton: const Icon(
                              Icons.sort,
                              size: 40,
                              color: mainBgColor,
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
                              _isAsc = SortItems.onChanged(context, value as SortItem);
                              setState(() {
                                if(_isAsc == true ){
                                  _attendances.sort( (a,b) => a.date.compareTo(b.date) );
                                  _isAsc = false;
                                }else{
                                  _attendances.sort( (a,b) => b.date.compareTo(a.date) );
                                  _isAsc = true;
                                }
                              });
                            },
                            itemHeight: 40,
                            itemPadding: const EdgeInsets.only(left: 5, right: 5),
                            dropdownWidth: 160,
                            dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: mainBgColor,
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
                                  _fromDateToDateString = 'Ngày';
                                });
                                _refreshController.resetNoData();
                                _getSelfAttendanceListByAccountId(isRefresh: false, accountId: _currentAccount.accountId!, currentPage: _currentPage);
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
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.21),
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
                child: _attendances.isNotEmpty ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0, right: 30.0),
                      child: Row(
                        children: const <Widget>[
                          Text('Ngày', style: TextStyle(color: defaultFontColor),),
                          Spacer(),
                          Text('Trạng thái', style: TextStyle(color: defaultFontColor),)
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
                          _refreshController.resetNoData();
                          if(_fromDate == null && _toDate == null){
                            _getSelfAttendanceListByAccountId(isRefresh: false, accountId: _currentAccount.accountId!, currentPage: _currentPage);
                          }else if(_toDate != null && _fromDate != null){
                            _getSelfAttendanceListByAccountId(isRefresh: false, accountId: _currentAccount.accountId!, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate);
                          }

                          if(_attendances.isNotEmpty){
                            _refreshController.refreshCompleted();
                          }else{
                            _refreshController.refreshFailed();
                          }
                        },
                        // onLoading: () async {
                        //   if(_currentPage < _maxPages){
                        //     setState(() {
                        //       _currentPage++;
                        //     });
                        //     if(_fromDate == null && _toDate == null){
                        //       _getAttendanceListByAccountId(isRefresh: false, accountId: currentAccount.accountId!, currentPage: _currentPage);
                        //     }else if(_toDate != null && _fromDate != null){
                        //       _getAttendanceListByAccountId(isRefresh: false, accountId: currentAccount.accountId!, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate);
                        //     }
                        //   }
                        //
                        //   if(_attendances.isNotEmpty){
                        //     _refreshController.loadComplete();
                        //   }else{
                        //     _refreshController.loadFailed();
                        //   }
                        // },

                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              final _attendance = _attendances[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0, left: 5.0, right: 5.0),
                                child: Card(
                                  elevation: 5,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                  ),
                                  child: ListTile(
                                    title: Text(DateFormat('dd-MM-yyyy').format(_attendance.date)),
                                    trailing: ( _today.isAtSameMomentAs(_attendance.date) && _timeHms <= 17 && _attendance.attendanceStatusId == 3) ? const Text('Chưa điểm danh', style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                    ),) : Text(attendanceStatusUtilities[_attendance.attendanceStatusId],
                                      style: TextStyle(
                                        color: _attendance.attendanceStatusId != 0
                                            ? _attendance.attendanceStatusId == 1
                                            ?  Colors.blue : _attendance.attendanceStatusId == 2
                                            ?  Colors.amber : Colors.red : Colors.green,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
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

  void _getSelfAttendanceListByAccountId({required bool isRefresh, required int accountId, required int currentPage,DateTime? fromDate, DateTime? toDate, int? attendanceStatusId}) async {
    List<Attendance> listAttendance = await AttendanceListViewModel().getSelfAttendanceListByAccountId(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage, fromDate: fromDate, toDate: toDate);

    _attendances.clear();
    if(listAttendance.isNotEmpty){
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
    _timeHms = _currentTime.toLocal().hour + (_currentTime.toLocal().minute/100);
    _today = DateTime.parse( DateFormat('yyyy-MM-dd').format(_currentTime) );
  }
}

class SortItems {
  static const List<SortItem> firstItems = [asc, des];

  static const asc = SortItem(text: 'Ngày tăng dần', icon: Icons.arrow_drop_up);
  static const des = SortItem(text: 'Ngày giảm dần', icon: Icons.arrow_drop_down);


  static Widget buildItem(SortItem item) {
    return Row(
      children: [
        Icon(
            item.icon,
            color: Colors.white,
            size: 22
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, SortItem item) {
    switch (item) {
      case SortItems.asc:
        return true;
      case SortItems.des:
      //Do something
        return false;
    }
  }
}