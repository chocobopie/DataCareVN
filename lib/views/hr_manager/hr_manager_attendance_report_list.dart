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
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/hr_manager/hr_manager_attendance_list.dart';
import 'package:login_sample/views/hr_manager/hr_manager_late_excuse_list.dart';
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

  late DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final RefreshController _refreshController = RefreshController();
  TextEditingController attendanceController = TextEditingController();
  late final List<Account> _employeeList = [];

  bool isSearching = false;
  bool isUpdatedAttendance = false;
  int currentIndex = 0;
  List<int> listUpdateAttendId = [];

  late Account _currentAccount;
  late final List<Attendance> _attendances = [];
  String _filterDayString = 'Ngày';
  bool _attendanceIsEmpty = false;

  int _currentPage = 0, _maxPages = 0;

  List<UserAttendance> userAttendances = [
    UserAttendance(id: '1', name: 'Thân Quang Nhân', team: 'Nhóm Thúy Anh', department: 'Đào tạo', attendance: 'Đúng giờ'),
    UserAttendance(id: '2', name: 'Vũ Thành Khiêm', team: 'Nhóm Thúy Anh', department: 'Đào tạo', attendance: 'Đúng giờ'),
    UserAttendance(id: '3', name: 'Tiêu Trường Nam', team: 'Nhóm Thúy Anh', department: 'Đào tạo', attendance: 'Đúng giờ'),
    UserAttendance(id: '4', name: 'Phan Trí Hào', team: 'Nhóm Thúy Anh', department: 'Đào tạo', attendance: 'Đúng giờ'),
    UserAttendance(id: '5', name: 'Thủy Minh Dân', team: 'Nhóm Thúy Anh', department: 'Đào tạo', attendance: 'Đúng giờ'),
    UserAttendance(id: '6', name: 'Võ Hiếu Liêm', team: 'Nhóm Thúy Anh', department: 'Đào tạo', attendance: 'Trễ'),
    UserAttendance(id: '7', name: 'Kiều Việt Khang', team: 'Nhóm Phan Minh', department: 'Đào tạo', attendance: 'Trễ'),
    UserAttendance(id: '8', name: 'Mã Hồng Quang', team: 'Nhóm Phan Minh', department: 'Đào tạo', attendance: 'Trễ'),
    UserAttendance(id: '9', name: 'Nguyễn Văn I', team: 'Nhóm Phan Minh', department: 'Đào tạo', attendance: 'Trễ'),
    UserAttendance(id: '10', name: 'Mã Hồng Quang', team: 'Nhóm Phan Minh', department: 'Đào tạo', attendance: 'Trễ'),
    UserAttendance(id: '11', name: 'Trần Dương Anh', team: 'Nhóm Phan Minh', department: 'Đào tạo', attendance: 'Vắng'),
    UserAttendance(id: '12', name: 'An Như Khang', team: 'Nhóm Phan Minh', department: 'Đào tạo', attendance: 'Vắng'),
    UserAttendance(id: '13', name: 'Thảo Thế Phúc', team: 'Nhóm Minh Nhân', department: 'Đào tạo', attendance: 'Vắng'),
    UserAttendance(id: '14', name: 'Đoàn Ðức Toản', team: 'Nhóm Minh Nhân', department: 'Đào tạo', attendance: 'Vắng'),
    UserAttendance(id: '15', name: 'Nguyễn Nguyên Lộc', team: 'Nhóm Minh Nhân', department: 'Đào tạo', attendance: 'Vắng'),
    UserAttendance(id: '16', name: 'Vũ Hoài Tín', team: 'Nhóm Minh Nhân', department: 'Đào tạo', attendance: 'Được đi trễ'),
    UserAttendance(id: '17', name: 'Trần Quốc Hiệp', team: 'Nhóm Minh Nhân', department: 'Đào tạo', attendance: 'Được đi trễ'),
    UserAttendance(id: '18', name: 'Nguyễn Tấn Sinh', team: 'Nhóm Minh Nhân', department: 'Đào tạo', attendance: 'Được đi trễ'),
    UserAttendance(id: '19', name: 'Nguyễn Ánh Dương', team: 'Nhóm Minh Nhân', department: 'Đào tạo', attendance: 'Được đi trễ'),
    UserAttendance(id: '20', name: 'Hồ Phượng Vy', team: 'Nhóm Minh Nhân', department: 'Đào tạo', attendance: 'Được đi trễ'),
  ];

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
    _getOtherAttendanceListByAccountId(isRefresh: true, currentPage: _currentPage, accountId: _currentAccount.roleId != 0 ? _currentAccount.roleId : null);
    _getAllEmployee();
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
                      builder: (context) => HrManagerLateExcuseList(
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
              buttonSelectedBackgroundColor: mainBgColor,
              onPageChange: (int index) {
                setState(() {
                  _currentPage = index;
                  _attendances.clear();
                });
                _getOtherAttendanceListByAccountId(isRefresh: false, currentPage: _currentPage, accountId: _currentAccount.roleId != 0 ? _currentAccount.roleId : null);
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
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              margin: const EdgeInsets.only(top: 90.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Text('Lọc theo', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                        const SizedBox(width: 5.0,),
                        const CustomOutlinedButton(
                            title: 'Trạng thái',
                            radius: 10,
                            color: mainBgColor
                        ),
                        CustomOutlinedButton(
                          title: _filterDayString,
                          radius: 10,
                          color: mainBgColor,
                          onPressed: () async {
                            // _onPressed(context: context);
                            FocusScope.of(context).requestFocus(FocusNode());
                            final date = await DatePicker.showDatePicker(
                              context,
                              locale : LocaleType.vi,
                              minTime: DateTime.now().subtract(const Duration(days: 36500)),
                              currentTime: DateTime.now(),
                              maxTime: DateTime.now(),
                            );

                            if (date != null) {
                              setState(() {
                                _selectedDay = date;
                                _filterDayString = 'Ngày ${DateFormat('dd-MM-yyyy').format(_selectedDay)}';
                                print(_selectedDay);
                              });
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
                            },
                            icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                        ),
                      ],
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
            child: _attendances.isNotEmpty ? SmartRefresher(
              controller: _refreshController,
              enablePullUp: true,
              onRefresh: () async {
                setState(() {
                  _attendances.clear();
                });
                _getOtherAttendanceListByAccountId(isRefresh: false, currentPage: _currentPage, accountId: _currentAccount.roleId != 0 ? _currentAccount.roleId : null);
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
                                    const Text('Tên nhân viên:'),
                                    const Spacer(),
                                    Text(_getEmployeeNamee(attendance.accountId)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                child: Row(
                                  children: <Widget>[
                                    const Text('Ngày:'),
                                    const Spacer(),
                                    Text(DateFormat('dd-MM-yyyy').format(attendance.date)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                child: Row(
                                  children: <Widget>[
                                    const Text('Trạng thái:'),
                                    const Spacer(),
                                    _customDropdownButton(attendance.attendanceStatusId, _attendances.indexOf(attendance)),
                                    if(attendance.attendanceStatusId == 0) const Text('Đúng giờ', style: TextStyle(fontSize: 16.0, color: Colors.green),),
                                    if(attendance.attendanceStatusId == 1) const Text('Cho phép trễ', style: TextStyle(fontSize: 16.0, color: Colors.blue),),
                                    if(attendance.attendanceStatusId == 2) const Text('Trễ', style: TextStyle(fontSize: 16.0, color: Colors.yellow),),
                                    if(attendance.attendanceStatusId == 3) const Text('Vắng', style: TextStyle(fontSize: 16.0, color: Colors.red,),),
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

  String _getEmployeeNamee(int accountId){
    String name = '';
    for(int i = 0; i < _employeeList.length; i++){
      if(accountId == _employeeList[i].accountId){
        name = _employeeList[i].fullname!;
      }
    }
    return name;
  }

  void _getAllEmployee() async {
    List<Account> accountList = await AccountListViewModel().getAllAccount(isRefresh: true, currentPage: 0, accountId: 0, limit: 100000);

    setState(() {
      _employeeList.addAll(accountList);
    });
  }

  void _getOtherAttendanceListByAccountId({required bool isRefresh, int? accountId, required int currentPage, DateTime? date, int? attendanceStatusId}) async {
    List<Attendance>? attendanceList = await AttendanceListViewModel().getOtherAttendanceListByAccountId(isRefresh: isRefresh, currentPage: currentPage, accountId: accountId, attendanceStatusId: attendanceStatusId, date: date);

    if(attendanceList != null){
      setState(() {
        _attendances.clear();
        _attendances.addAll(attendanceList);
        _maxPages = _attendances[0].maxPage!;
      });
    }else{
      setState(() {
        _attendanceIsEmpty = true;
      });
    }

  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime.now().subtract(const Duration(days: 31)),
      lastDay: DateTime.now(),
      locale: 'vi_VI',
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarFormat: CalendarFormat.month,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      selectedDayPredicate: (DateTime date) {
        return isSameDay(_selectedDay, date);
      },
      onDaySelected: (DateTime selectDay, DateTime focusDay) {
        setState(() {
          _selectedDay = selectDay;
          _focusedDay = focusDay;
        });
      },
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        outsideDaysVisible: false,
        weekendTextStyle:
        const TextStyle().copyWith(color: Colors.blue[800]),
        holidayTextStyle:
        const TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: const TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
      ),
    );
  }

  Widget _customDropdownButton(int attendanceStatusId, int index){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: attendanceStatusId == 0 ? const Icon(Icons.access_time_filled, size: 30, color: Colors.green,)
            : attendanceStatusId == 2 ? const Icon(Icons.access_time_filled, size: 30, color: Colors.yellow,)
            : attendanceStatusId == 3 ? const Icon(Icons.access_time_filled, size: 30, color: Colors.red,)
            : const Icon(Icons.access_time_filled, size: 30, color: Colors.blue,),
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
          String _attendanceType = MenuItems.onChanged(context, value as MenuItem);
          if(_attendanceType.isNotEmpty){
            if(_attendanceType == 'Đúng giờ'){
              setState(() {
                currentIndex = index;
                attendanceController.text = _attendanceType;
                listUpdateAttendId.add(currentIndex);
                _updateAttendances(attendanceStatusId);
                print(currentIndex);
                print(attendanceController.text);
              });
            }else if(_attendanceType == 'Vắng'){
              setState(() {
                currentIndex = index;
                attendanceController.text = _attendanceType;
                listUpdateAttendId.add(currentIndex);
                _updateAttendances(attendanceStatusId);
                print(currentIndex);
                print(attendanceController.text);
              });
            }else if(_attendanceType == 'Cho phép trễ'){
              setState(() {
                currentIndex = index;
                attendanceController.text = _attendanceType;
                listUpdateAttendId.add(currentIndex);
                _updateAttendances(attendanceStatusId);
                print(currentIndex);
                print(attendanceController.text);
              });
            }else{
              setState(() {
                currentIndex = index;
                attendanceController.text = _attendanceType;
                listUpdateAttendId.add(currentIndex);
                _updateAttendances(attendanceStatusId);
                print(currentIndex);
                print(attendanceController.text);
              });
            }
          }
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

  void _updateAttendances(int attendanceStatusId){
    if(attendanceStatusUtilities[attendanceStatusId] != attendanceController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Thay đổi trạng thái từ ${attendanceStatusUtilities[attendanceStatusId]} thành ${attendanceController.text}',
            style: const TextStyle(fontSize: 18.0, color: defaultFontColor),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Huỷ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Lưu"),
              onPressed: () {
                setState(() {
                  userAttendances[currentIndex].attendance = attendanceController.text;
                  Navigator.pop(context);
                });
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
  static const List<MenuItem> firstItems = [attend, late, absent, lateAccepted];

  static const attend = MenuItem(text: 'Có mặt', icon: Icon(Icons.access_time_filled, color: Colors.green));
  static const absent = MenuItem(text: 'Vắng', icon: Icon(Icons.access_time_filled, color: Colors.red));
  static const late = MenuItem(text: 'Trễ', icon: Icon(Icons.access_time_filled, color: Colors.yellow));
  static const lateAccepted = MenuItem(text: 'Được đi trễ', icon: Icon(Icons.access_time_filled, color: Colors.blue));

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
      case MenuItems.attend:
        return 'Đúng giờ';
      case MenuItems.late:
        return 'Trễ';
      case MenuItems.absent:
        return 'Vắng';
      case MenuItems.lateAccepted:
        return 'Cho phép trễ';
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