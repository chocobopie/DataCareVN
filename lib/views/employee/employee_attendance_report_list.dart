import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/models/sort_item.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/attendance_list_view_model.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/view_models/attendance_view_model.dart';
import 'package:login_sample/widgets/CustomDropDownFormField2Filter.dart';
import 'package:login_sample/widgets/CustomMonthPicker.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EmployeeAttendanceReportList extends StatefulWidget {
  const EmployeeAttendanceReportList({Key? key}) : super(key: key);

  @override
  _EmployeeAttendanceReportListState createState() => _EmployeeAttendanceReportListState();
}

class _EmployeeAttendanceReportListState extends State<EmployeeAttendanceReportList> {

  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  late final List<Attendance> _attendances = [];
  late Account _currentAccount;
  int _currentPage = 0, _maxPages = 0;
  int? _periodOfDayId, _attendanceStatusId, _ontTimeCount, _lateAcceptedCount, _dayOffAcceptedCount, _lateCount, _absentCount, _availableApprovedAbsenceCount;
  late String _selectMonthString;
  DateTime? _fromDate, _toDate;
  late DateTime _currentTime, _today;
  late double _timeHmsNow;

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _fromDate = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    _toDate = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    _selectMonthString = 'Tháng ${DateFormat('MM-yyyy').format(_selectedMonth)}';
    _getCountAttendance();
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Card(
      //   elevation: 10.0,
      //   child: _maxPages > 0 ? NumberPaginator(
      //     numberPages: _maxPages,
      //     initialPage: 0,
      //     buttonSelectedBackgroundColor: mainBgColor,
      //     onPageChange: (int index) {
      //       setState(() {
      //         if(index >= _maxPages){
      //           index = 0;
      //           _currentPage = index;
      //         }else{
      //           _currentPage = index;
      //         }
      //         _attendances.clear();
      //         _getSelfAttendanceList(isRefresh: false);
      //       });
      //     },
      //   ) : null,
      // ),
      body: Stack(
        children: <Widget>[
          Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomCenter,
                      colors: [mainBgColor, mainBgColor])),
              height: MediaQuery.of(context).size.height * 0.3),
          Card(
              elevation: 20.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25))
              ),
              margin: const EdgeInsets.only(top: 90.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 2.0,),
                child: SingleChildScrollView(
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
                              title: _selectMonthString,
                              radius: 10,
                              color: mainBgColor,
                              onPressed: () async {
                                final date = await DatePicker.showPicker(context,
                                  pickerModel: CustomMonthPicker(
                                    currentTime: DateTime.now(),
                                    minTime: DateTime(2016),
                                    maxTime: DateTime.now(),
                                    locale: LocaleType.vi,
                                  ),
                                );
                                if(date != null){
                                  setState(() {
                                    _selectedMonth = date;
                                    _fromDate = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
                                    _toDate = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
                                    _selectMonthString = 'Tháng ${DateFormat('MM-yyyy').format(_selectedMonth)}';
                                    _attendances.clear();
                                    _maxPages = _currentPage = 0;
                                  });
                                  _refreshController.resetNoData();
                                  _getCountAttendance();
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
                                    _attendanceStatusId = null;
                                    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
                                    _fromDate = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
                                    _toDate = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
                                    _selectMonthString = 'Tháng ${DateFormat('MM-yyyy').format(_selectedMonth)}';
                                    _periodOfDayId = null;
                                    _maxPages = _currentPage = 0;
                                    _refreshController.resetNoData();
                                  });
                                  _getCountAttendance();
                                  _getSelfAttendanceList(isRefresh: true);
                                },
                                icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                            ),
                          ],
                        ),
                      ),
                      ExpansionTile(
                          title: const Text('Báo cáo điểm danh', style: TextStyle(color: defaultFontColor),),
                          children: <Widget>[
                            _maxPages >= 0 ? _attendances.isNotEmpty ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: Column(
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
                                          _refreshController.resetNoData();
                                        });
                                        _currentPage = 0;
                                        _getSelfAttendanceList(isRefresh: true);


                                        if(_attendances.isNotEmpty){
                                          _refreshController.refreshCompleted();
                                        }else{
                                          _refreshController.refreshFailed();
                                        }
                                      },
                                      onLoading: () async {
                                        _currentPage++;
                                        _getSelfAttendanceList(isRefresh: false);

                                        if(_attendances.isNotEmpty){
                                          _refreshController.isLoading;
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
                              ),
                            ) : const Center(child: CircularProgressIndicator())
                                : const Center(child: Text('Không có dữ liệu')),
                          ],
                      ),

                      ExpansionTile(
                        title: const Text('Thống kê điểm danh trong tháng', style: TextStyle(color: defaultFontColor),),
                        children: <Widget>[
                          (_ontTimeCount != null && _lateAcceptedCount != null && _dayOffAcceptedCount != null && _lateCount != null && _absentCount != null && _availableApprovedAbsenceCount != null) ? Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      const Text('Đúng giờ'),
                                      const Spacer(),
                                      Text('$_ontTimeCount'),
                                    ],
                                  ),
                                ),
                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      const Text('Vắng không phép'),
                                      const Spacer(),
                                      Text('$_absentCount'),
                                    ],
                                  ),
                                ),
                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      const Text('Trễ không phép'),
                                      const Spacer(),
                                      Text('$_lateCount'),
                                    ],
                                  ),
                                ),
                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      const Text('Vắng có phép'),
                                      const Spacer(),
                                      Text('$_dayOffAcceptedCount'),
                                    ],
                                  ),
                                ),
                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      const Text('Trễ có phép'),
                                      const Spacer(),
                                      Text('$_lateAcceptedCount'),
                                    ],
                                  ),
                                ),
                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      const Expanded(flex: 4, child: Text('Số ca vắng có phép còn khả dụng')),
                                      const Spacer(),
                                      Text('$_availableApprovedAbsenceCount'),
                                    ],
                                  ),
                                ),
                                const Divider(color: Colors.grey,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: [
                                      const Expanded(flex: 4,child: Text('Số ca đi trễ có phép còn khả dụng')),
                                      const Spacer(),
                                      Text('$_lateAcceptedCount'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ) : const Center(child: CircularProgressIndicator()),

                        ],
                      ),
                      const SizedBox(height: 40,),
                    ],
                  ),
                )
              ),
          ),

          // _maxPages >= 0 ? Padding(
          //   padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: const BorderRadius.only(
          //         topLeft: Radius.circular(25),
          //         topRight: Radius.circular(25),
          //       ),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.grey.withOpacity(0.5),
          //           spreadRadius: 2,
          //           blurRadius: 8,
          //           offset: const Offset(0, 3), // changes position of shadow
          //         ),
          //       ],
          //     ),
          //     child: Card(
          //       elevation: 100.0,
          //       shape: const RoundedRectangleBorder(
          //         borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(25),
          //           topRight: Radius.circular(25),
          //         ),
          //       ),
          //       margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
          //       child: _attendances.isNotEmpty ? Column(
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.only(left: 40.0, right: 30.0),
          //             child: Row(
          //               children: const <Widget>[
          //                 Expanded(child: Text('Ngày', style: TextStyle(color: defaultFontColor),), flex: 1,),
          //                 Spacer(),
          //                 Expanded(child: Text('Ca làm việc', style: TextStyle(color: defaultFontColor),), flex: 0,),
          //                 Spacer(),
          //                 Expanded(child: Text('Trạng thái', style: TextStyle(color: defaultFontColor),), flex: 0,)
          //               ],
          //             ),
          //           ),
          //           Expanded(
          //             child: SmartRefresher(
          //               controller: _refreshController,
          //               enablePullUp: true,
          //               onRefresh: () async {
          //                 setState(() {
          //                   _attendances.clear();
          //                 });
          //                 _getSelfAttendanceList(isRefresh: false);
          //
          //
          //                 if(_attendances.isNotEmpty){
          //                   _refreshController.refreshCompleted();
          //                 }else{
          //                   _refreshController.refreshFailed();
          //                 }
          //               },
          //               child: ListView.builder(
          //                   itemBuilder: (context, index) {
          //                     final _attendance = _attendances[index];
          //                     return Padding(
          //                       padding: const EdgeInsets.only(bottom: 20.0, left: 5.0, right: 5.0),
          //                       child: Card(
          //                         elevation: 5,
          //                         shape: const RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.all(Radius.circular(15)),
          //                         ),
          //                         child: Padding(
          //                           padding: const EdgeInsets.only(left: 20.0, top: 15.0, bottom: 15.0, right: 5.0),
          //                           child: Row(
          //                             children: [
          //                               Text(DateFormat('dd-MM-yyyy').format(_attendance.date)),
          //                               const Spacer(),
          //                               Expanded(child: Text(periodOfDayNames[_attendance.periodOfDayId])),
          //                               const Spacer(),
          //                               if(_attendance.attendanceStatusId == 4 && ( (_timeHmsNow <= 9.30 && _timeHmsNow > 0 && _attendance.periodOfDayId == 0) || (_timeHmsNow <= 13.30 && _timeHmsNow > 0 && _attendance.periodOfDayId == 1) ) && _attendance.date == _today)
          //                                 const Expanded(child: Text('Chưa điểm danh', style: TextStyle(color: Colors.grey),),),
          //                               if(_attendance.attendanceStatusId != 4 && ( (_timeHmsNow <= 9.30 && _timeHmsNow > 0 && _attendance.periodOfDayId == 0) || (_timeHmsNow <= 13.30 && _timeHmsNow > 0 && _attendance.periodOfDayId == 1) ) && _attendance.date == _today)
          //                                 Expanded(child: Text(attendanceStatusNames[_attendance.attendanceStatusId],
          //                                   style: TextStyle(color: _attendance.attendanceStatusId != 4
          //                                       ? _attendance.attendanceStatusId != 3
          //                                       ? _attendance.attendanceStatusId != 2
          //                                       ? _attendance.attendanceStatusId != 1 ? Colors.green
          //                                       : Colors.blue : Colors.purple : Colors.brown : Colors.red,
          //                                       fontWeight: FontWeight.w600,
          //                                       fontSize: 16.0
          //                                   ),
          //                                 ),),
          //                               if( ( (_timeHmsNow > 9.30 && _attendance.periodOfDayId == 0 ) || (_timeHmsNow > 13.30 && _attendance.periodOfDayId == 1) ) && _attendance.date == _today)
          //                                 Expanded(child: Text(attendanceStatusNames[_attendance.attendanceStatusId],
          //                                   style: TextStyle(color: _attendance.attendanceStatusId != 4
          //                                       ? _attendance.attendanceStatusId != 3
          //                                       ? _attendance.attendanceStatusId != 2
          //                                       ? _attendance.attendanceStatusId != 1 ? Colors.green
          //                                       : Colors.blue : Colors.purple : Colors.brown : Colors.red,
          //                                       fontWeight: FontWeight.w600,
          //                                       fontSize: 16.0
          //                                   ),
          //                                 ),),
          //                               if(_attendance.date != _today)
          //                                 Expanded(child: Text(attendanceStatusNames[_attendance.attendanceStatusId],
          //                                   style: TextStyle(color: _attendance.attendanceStatusId != 4
          //                                       ? _attendance.attendanceStatusId != 3
          //                                       ? _attendance.attendanceStatusId != 2
          //                                       ? _attendance.attendanceStatusId != 1 ? Colors.green
          //                                       : Colors.blue : Colors.purple : Colors.brown : Colors.red,
          //                                     fontWeight: FontWeight.w600,
          //                                     fontSize: 16.0
          //                                   ),
          //                                 ),),
          //                             ],
          //                           ),
          //                         )
          //                       ),
          //                     );
          //                   },
          //                   itemCount: _attendances.length
          //               ),
          //             ),
          //           ),
          //         ],
          //       ) : const Center(child: CircularProgressIndicator())
          //     ),
          //   ),
          // ) : const Center(child: Text('Không có dữ liệu')),
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
      periodOfDayId: _periodOfDayId, fromDate: _fromDate, toDate: _toDate, attendanceStatusId: _attendanceStatusId, limit: 10,
    );

    if(listAttendance!.isNotEmpty){
      setState(() {
        _attendances.addAll(listAttendance);
        _maxPages = _attendances[0].maxPage!;
      });
    }else{
      setState(() {
        _refreshController.loadNoData();
      });
      if(_attendances.isEmpty){
        setState(() {
          _maxPages = -1;
        });
      }
    }
  }
  
  void _getCountAttendance() async {
    setState(() {
      _ontTimeCount = null;
      _lateAcceptedCount = null;
      _dayOffAcceptedCount = null;
      _lateCount = null;
      _absentCount = null;
    });

    _getCountAvailableApprovedAbsence();

    for(int i = 0; i < 5; i++){
      int? result = await AttendanceViewModel().getCountAttendance(accountId: _currentAccount.accountId!, fromDate: _fromDate!, toDate: _toDate!, attendanceStatusId: i);
      setState(() {
        if(i == 0){_ontTimeCount = result;}
        if(i == 1){_lateAcceptedCount = result;}
        if(i == 2){_dayOffAcceptedCount = result;}
        if(i == 3){_lateCount = result;}
        if(i == 4){_absentCount = result;}
      });
    }

  }

  void _getCountAvailableApprovedAbsence() async {
    setState(() {
      _availableApprovedAbsenceCount = null;
    });

    int? result = await AttendanceViewModel().getCountAvailableApprovedAbsence(accountId: _currentAccount.accountId!, fromDate: _fromDate!);

    setState(() {
      _availableApprovedAbsenceCount = result;
    });
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