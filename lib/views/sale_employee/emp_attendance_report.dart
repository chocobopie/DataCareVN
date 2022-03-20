import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/models/fromDateToDate.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/attendance_list_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_date_filter.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EmpAttendanceReport extends StatefulWidget {
  const EmpAttendanceReport({Key? key}) : super(key: key);

  @override
  _EmpAttendanceReportState createState() => _EmpAttendanceReportState();
}

class _EmpAttendanceReportState extends State<EmpAttendanceReport> {


  late final List<Attendance> _attendances = [];
  late Account currentAccount;
  int _currentPage = 0, _maxPages = 0;
  final RefreshController _refreshController = RefreshController();
  String fromDateToDateString = 'Từ trước đến nay';
  DateTime? _fromDate, _toDate;

  @override
  void initState() {
    super.initState();
    currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getAttendanceListByAccountId(isRefresh: true, accountId: currentAccount.accountId!, currentPage: _currentPage);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
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
                  children: [
                    Row(
                      children: <Widget>[
                        const Text('Lọc theo ngày:', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                        const SizedBox(width: 10.0,),
                        Expanded(
                          child: CustomOutlinedButton(
                            title: fromDateToDateString,
                            radius: 30,
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
                                  _attendances.clear();
                                });
                                _refreshController.resetNoData();
                                _getAttendanceListByAccountId(isRefresh: true, accountId: currentAccount.accountId!, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate);
                              }
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: (){
                              setState(() {
                                _attendances.clear();
                                _currentPage = 0;
                                _fromDate = null;
                                _toDate = null;
                                fromDateToDateString = 'Từ trước đến nay';
                              });
                              _refreshController.resetNoData();
                              _getAttendanceListByAccountId(isRefresh: true, accountId: currentAccount.accountId!, currentPage: _currentPage);
                            },
                            icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                        ),
                      ],
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
                child: _attendances.isNotEmpty ? SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: true,
                  onRefresh: () async {
                    setState(() {
                      _attendances.clear();
                    });
                    _currentPage = 0;
                    _refreshController.resetNoData();
                    if(_fromDate == null && _toDate == null){
                      _getAttendanceListByAccountId(isRefresh: true, accountId: currentAccount.accountId!, currentPage: _currentPage);
                    }else if(_toDate != null && _fromDate != null){
                      _getAttendanceListByAccountId(isRefresh: true, accountId: currentAccount.accountId!, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate);
                    }

                    if(_attendances.isNotEmpty){
                      _refreshController.refreshCompleted();
                    }else{
                      _refreshController.refreshFailed();
                    }
                  },

                  onLoading: () async {
                    if(_currentPage < _maxPages){
                      setState(() {
                        _currentPage++;
                      });
                      if(_fromDate == null && _toDate == null){
                        _getAttendanceListByAccountId(isRefresh: false, accountId: currentAccount.accountId!, currentPage: _currentPage);
                      }else if(_toDate != null && _fromDate != null){
                        _getAttendanceListByAccountId(isRefresh: false, accountId: currentAccount.accountId!, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate);
                      }
                    }

                    if(_attendances.isNotEmpty){
                      _refreshController.loadComplete();
                    }else{
                      _refreshController.loadFailed();
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
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                            child: ListTile(
                              title: Text('Ngày ${DateFormat('dd-MM-yyyy').format(_attendance.date)}'),
                              trailing: Text(attendanceStatusUtilities[_attendance.attendanceStatusId]),
                            ),
                          ),
                        );
                      },
                      itemCount: _attendances.length
                  ),
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

  void _getAttendanceListByAccountId({required bool isRefresh, required int accountId, required int currentPage,DateTime? fromDate, DateTime? toDate, int? attendanceStatusId}) async {
    List<Attendance> listAttendance = await AttendanceListViewModel().getAttendanceListByAccountId(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage, fromDate: fromDate, toDate: toDate);

    if(listAttendance.isNotEmpty){
      setState(() {
        _attendances.addAll(listAttendance);
        _maxPages = _attendances[0].maxPage!;
      });
    }else{
      _refreshController.loadNoData();
    }
  }
}
