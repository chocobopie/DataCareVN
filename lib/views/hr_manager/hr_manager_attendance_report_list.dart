import 'dart:core';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/models/sort_item.dart';
import 'package:login_sample/view_models/account_list_view_model.dart';
import 'package:login_sample/view_models/attendance_list_view_model.dart';
import 'package:login_sample/view_models/attendance_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/widgets/CustomDropDownFormField2Filter.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/hr_manager/hr_manager_attendance_list.dart';
import 'package:login_sample/views/hr_manager/hr_manager_application_list.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';

class HrManagerAttendanceReportList extends StatefulWidget {
  const HrManagerAttendanceReportList({Key? key}) : super(key: key);

  @override
  _HrManagerAttendanceReportListState createState() => _HrManagerAttendanceReportListState();
}

class _HrManagerAttendanceReportListState extends State<HrManagerAttendanceReportList> {

  late Account _currentAccount;
  DateTime? _selectedDay = DateTime.parse( DateFormat('yyyy-MM-dd').format(DateTime.now()));

  final RefreshController _refreshController = RefreshController();
  TextEditingController attendanceController = TextEditingController();

  late final List<Account> _employeeList = [];
  List<int> listUpdateAttendId = [];
  late final List<Attendance> _attendances = [];

  int? _periodOfDayId, _attendanceStatusId;
  int _currentPage = 0, _maxPages = 0, _currentIndex = 0;
  bool isSearching = false, isUpdatedAttendance = false;
  String _filterDayString = 'Ngày ${DateFormat('dd-MM-yyyy').format(DateTime.now())}';

  List<UserAttendance> userLateExcuses = [
    UserAttendance(id: '1', name: 'Hồ Phượng Vy', team: 'Nhóm Kiều Trinh', department: 'Đào tạo', attendance: 'Mới', lateExcuseDate: '2-04-2022', lateReason: 'Sáng nay em bị tắc đường còn gặp rất nhiều sương mù nữa', lateTime: '9:00 AM'),
    UserAttendance(id: '2', name: 'Vĩnh Phương Thảo', team: 'Nhóm Minh Nhân', department: 'Đào tạo', attendance: 'Mới', lateExcuseDate: '2-04-2022', lateReason: 'Em phải đưa con mèo đến phòng khám thú y', lateTime: '8:40 AM'),
    UserAttendance(id: '3', name: 'Đỗ Xuân Phượng', team: 'Nhóm Phan Minh', department: 'Đào tạo', attendance: 'Mới', lateExcuseDate: '2-04-2022', lateReason: 'Em bị cảnh sát giao thông chặn lại', lateTime: '8:30 AM'),
    UserAttendance(id: '4', name: 'Ngư Thanh Hà', team: 'Nhóm Trần An', department: 'Đào tạo', attendance: 'Mới', lateExcuseDate: '2-04-2022', lateReason: 'Đi nhầm đường do công ty mới đổi văn phòng', lateTime: '9:00 AM'),
    UserAttendance(id: '5', name: 'Ngô Thu Nhiên', team: 'Nhóm Trần An', department: 'Đào tạo', attendance: 'Mới', lateExcuseDate: '2-04-2022', lateReason: 'Em không nhớ hôm nay phải đi làm', lateTime: '9:00 AM'),
    UserAttendance(id: '6', name: 'Vũ Hiền Mai', team: 'Nhóm Trần An', department: 'Đào tạo', attendance: 'Mới', lateExcuseDate: '2-04-2022', lateReason: 'Sáng nay chó nhà em đẻ, em phải ở nhà đỡ đẻ cho chó', lateTime: '9:00 AM'),
  ];

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getOtherAttendanceList(isRefresh: true);
    _getAllEmployee();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    attendanceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if(_currentAccount.roleId == 0)
          Align(
            alignment: Alignment.bottomLeft,
            child: SpeedDial(
              switchLabelPosition: true,
              backgroundColor: mainBgColor,
              activeForegroundColor: Colors.black,
              icon: Icons.more_vert,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.check, color: Colors.white,),
                  backgroundColor: mainBgColor,
                  labelStyle: const TextStyle(color: Colors.white, fontSize: 16),
                  labelBackgroundColor: mainBgColor,
                  label: 'Duyệt đơn xin đi trễ',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => HrManagerApplicationList(
                        attendanceType: 'Duyệt đơn xin phép đi trễ',
                        userLateExcuses: userLateExcuses,
                      ),
                    ));
                  },
                ),
              ],
            )
          ),
          Card(
            elevation: 10.0,
            child: _maxPages > 0 ? NumberPaginator(
              numberPages: _maxPages,
              initialPage: 0,
              buttonSelectedBackgroundColor: mainBgColor,
              onPageChange: (int index) {
                setState(() {
                  _currentPage = index;
                  _attendances.clear();
                });
                _getOtherAttendanceList(isRefresh: false);
              },
            ) : null,
          ),
        ],
      ),

      body: Stack(
        children: <Widget>[
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomCenter,
                      colors: [mainBgColor, mainBgColor])),
              height: MediaQuery.of(context).size.height * 0.2
          ),
          Card(
              elevation: 0.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              margin: const EdgeInsets.only(top: 90.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 5.0),
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
                            title: _filterDayString,
                            radius: 10,
                            color: mainBgColor,
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final date = await DatePicker.showDatePicker(
                                context,
                                locale : LocaleType.vi,
                                minTime: DateTime.now().subtract(const Duration(days: 31)),
                                currentTime: DateTime.now(),
                                maxTime: DateTime.now(),
                              );

                              if (date != null) {
                                setState(() {
                                  _selectedDay = DateTime.parse( DateFormat('yyyy-MM-dd').format(date) );
                                  _filterDayString = 'Ngày ${DateFormat('dd-MM-yyyy').format(_selectedDay!)}';
                                  _maxPages = 0;
                                  _attendances.clear();
                                  print(_selectedDay);
                                });

                                _getOtherAttendanceList(isRefresh: true);
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
                                      _maxPages = 0;
                                      _attendances.clear();
                                    });
                                  }
                                }
                                _getOtherAttendanceList(isRefresh: true);
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
                                _maxPages = 0;
                                _attendances.clear();
                              });
                              _getOtherAttendanceList(isRefresh: true);
                            },
                            itemHeight: 40,
                            itemPadding: const EdgeInsets.only(left: 5, right: 5),
                            dropdownWidth: 150,
                            dropdownPadding: const EdgeInsets.symmetric(vertical: 10),
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
                                  _periodOfDayId = null;
                                  _attendanceStatusId = null;
                                  _selectedDay = DateTime.parse( DateFormat('yyyy-MM-dd').format(DateTime.now()));
                                  _filterDayString = 'Ngày ${DateFormat('dd-MM-yyyy').format(DateTime.now())}';
                                });
                                _attendances.clear();
                                _getAllEmployee();
                                _getOtherAttendanceList(isRefresh: true);
                              },
                              icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ),

          //Card dưới
          Card(
            elevation: 20.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
            child: _attendances.isNotEmpty ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 30.0),
                  child: Row(
                    children: const <Widget>[
                      Expanded(child: Text('Tên', style: TextStyle(color: defaultFontColor),), flex: 1,),
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
                      _getOtherAttendanceList(isRefresh: false);
                      _getAllEmployee();

                      if(_attendances.isNotEmpty){
                        _refreshController.refreshCompleted();
                      }else{
                        _refreshController.refreshFailed();
                      }
                    },
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          final attendance = _attendances[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0)
                                )
                              ),
                              elevation: 10.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[

                                          Expanded(child: Text(_getEmployeeName(attendance.accountId)), flex: 2,),
                                          const Spacer(),
                                          
                                          Expanded(child: Text(periodOfDayNames[attendance.periodOfDayId]), flex: 1,),
                                          const Spacer(),
                                          _customDropdownButton(attendance, _attendances.indexOf(attendance)),
                                          if(attendance.attendanceStatusId == 0) const Expanded(child: Text('Đúng giờ', style: TextStyle(fontSize: 16.0, color: Colors.green),)),

                                          if(attendance.attendanceStatusId == 1) const Expanded(child: Text('Cho phép trễ', style: TextStyle(fontSize: 16.0, color: Colors.blue),)),

                                          if(attendance.attendanceStatusId == 2) const Expanded(child: Text('Cho pheps nghỉ', style: TextStyle(fontSize: 16.0, color: Colors.purple),)),

                                          if(attendance.attendanceStatusId == 3) const Expanded(child: Text('Trễ', style: TextStyle(fontSize: 16.0, color: Colors.brown,),)),

                                          if(attendance.attendanceStatusId == 4) const Expanded(child: Text('Vắng', style: TextStyle(fontSize: 16.0, color: Colors.red,),)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: _attendances.length,
                    ),
                  ),
                ),
              ],
            ) : const Center(child: CircularProgressIndicator()),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(// Add AppBar here only
              iconTheme: const IconThemeData(color: Colors.blueGrey),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Báo cáo điểm danh của các nhân viên",
                style: TextStyle(
                  letterSpacing: 0.0,
                  fontSize: 16.0,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getEmployeeName(int accountId){
    String name = '';
    for(int i = 0; i < _employeeList.length; i++){
      if(accountId == _employeeList[i].accountId){
        name = _employeeList[i].fullname!;
      }
    }
    return name;
  }

  Future<bool> _updateAnAttendance(Attendance attendance) async {
    bool result = await AttendanceViewModel().updateAnAttendance(attendance: attendance);
    return result;
  }

  void _getAllEmployee() async {
    List<Account> accountList = await AccountListViewModel().getAllAccount(isRefresh: true, currentPage: 0, accountId: _currentAccount.accountId!, limit: 100000);
    _employeeList.clear();

    setState(() {
      _employeeList.addAll(accountList);
    });
  }

  void _getOtherAttendanceList({required bool isRefresh}) async {
    List<Attendance>? listAttendance = await AttendanceListViewModel().getOtherAttendanceList(
        accountId: _currentAccount.accountId!, isRefresh: isRefresh, currentPage: _currentPage,
      attendanceStatusId: _attendanceStatusId, periodOfDay: _periodOfDayId, selectedDate: _selectedDay
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

  Widget _customDropdownButton(Attendance attendance, int index){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: attendance.attendanceStatusId != 4 ? attendance.attendanceStatusId != 3 ? attendance.attendanceStatusId != 2 ? attendance.attendanceStatusId != 1 ?
        const Icon(Icons.access_time_filled, size: 30, color: Colors.green,)
            : const Icon(Icons.access_time_filled, size: 30, color: Colors.blue,)
            : const Icon(Icons.access_time_filled, size: 30, color: Colors.purple,)
            : const Icon(Icons.access_time_filled, size: 30, color: Colors.brown,)
            : const Icon(Icons.access_time_filled, size: 30, color: Colors.red,),
        customItemsIndexes: const [4],
        customItemsHeight: 8,
        items: [
          ...MenuItems.firstItems.map(
                (item) =>
                DropdownMenuItem<MenuItem>(
                  value: item,
                  child: MenuItems.buildItem(item),
                ),
          ),
        ],
        onChanged: (value) {
          int replaceAttendanceStatusId = MenuItems.onChanged(context, value as MenuItem);
          _updateAttendances(attendance, replaceAttendanceStatusId);
        },
        itemHeight: 48,
        itemPadding: const EdgeInsets.only(left: 10),
        dropdownWidth: 150,
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
        ),
        dropdownElevation: 8,
        offset: const Offset(0, 8),
      ),
    );
  }

  void _updateAttendances(Attendance attendance, int replaceAttendanceStatusId){
    if(attendance.attendanceStatusId != replaceAttendanceStatusId) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: const EdgeInsets.all(5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Thay đổi trạng thái của ${_getEmployeeName(attendance.accountId)} ngày ${DateFormat('dd-MM-yyyy').format(attendance.date)} ca ${periodOfDayNames[attendance.periodOfDayId]}',
                        style: const TextStyle(fontSize: 18.0, color: defaultFontColor),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      attendanceStatusNames[attendance.attendanceStatusId],
                      style: TextStyle(fontSize: 18.0, color: attendance.attendanceStatusId != 4 ? attendance.attendanceStatusId != 3 ? attendance.attendanceStatusId != 0 ? null : Colors.green : Colors.brown : Colors.red),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_outlined, color: defaultFontColor,),
                    const Spacer(),
                    Text(
                      attendanceStatusNames[replaceAttendanceStatusId],
                      style: TextStyle(fontSize: 18.0, color: replaceAttendanceStatusId != 4 ? replaceAttendanceStatusId != 3 ? replaceAttendanceStatusId != 0 ? null : Colors.green : Colors.brown : Colors.red),
                    ),
                    const Spacer(),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Huỷ", style: TextStyle(fontSize: 16.0),),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Lưu", style: TextStyle(fontSize: 16.0)),
              onPressed: () async {
                showLoaderDialog(context);
                  Attendance updateAttendance = Attendance(
                      attendanceId: attendance.attendanceId,
                      accountId: attendance.accountId, 
                      date: attendance.date, 
                      attendanceStatusId: replaceAttendanceStatusId, 
                      periodOfDayId: attendance.periodOfDayId
                  );
                  
                  bool data = await _updateAnAttendance(updateAttendance);
                  if(data == true){
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cập nhật trạng thái cho ${_getEmployeeName(attendance.accountId)} thành công')));
                    _getOtherAttendanceList(isRefresh: false);
                    Navigator.pop(context);
                  }else{
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cập nhật trạng thái cho ${_getEmployeeName(attendance.accountId)} thất bại')));
                  }

              },
            ),
          ],
        ),
      );
    }
  }
}

class MenuItem {
  final String text;
  final Icon icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [onTime, late, absent];

  static const onTime = MenuItem(text: 'Đúng giờ', icon: Icon(Icons.access_time_filled, color: Colors.green));
  static const late = MenuItem(text: 'Trễ', icon: Icon(Icons.access_time_filled, color: Colors.brown));
  static const absent = MenuItem(text: 'Vắng', icon: Icon(Icons.access_time_filled, color: Colors.red));
  // static const lateAccepted = MenuItem(text: 'Được đi trễ', icon: Icon(Icons.access_time_filled, color: Colors.blue));

  static Widget buildItem(MenuItem item) {
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

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.onTime:
        return 0;
      case MenuItems.late:
        return 3;
      case MenuItems.absent:
        return 4;
    }
  }
}

class UserAttendance{
  String id;
  String name;
  String team;
  String department;
  String attendance;
  String? lateExcuseDate;
  String? lateReason;
  String? lateTime;


  UserAttendance({
    required this.id,
    required this.name,
    required this.team,
    required this.department,
    required this.attendance,
    this.lateExcuseDate,
    this.lateReason,
    this.lateTime
  });

  @override
  String toString() {
    return 'id: $id, name: $name, team: $team, department: $department, attendance: $attendance';
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