import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/hr_manager/hr_manager_attendance_list.dart';
import 'package:login_sample/views/hr_manager/hr_manager_late_excuse_list.dart';
import 'package:table_calendar/table_calendar.dart';

class HrManagerAttendanceReport extends StatefulWidget {
  const HrManagerAttendanceReport({Key? key}) : super(key: key);

  @override
  _HrManagerAttendanceReportState createState() => _HrManagerAttendanceReportState();
}

class _HrManagerAttendanceReportState extends State<HrManagerAttendanceReport> {

  late DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<UserAttendance> userAttendances = [
    UserAttendance(id: '1', name: 'Nguyễn Văn A', team: 'Nhóm 1', department: 'Đào tạo', attendance: 'Đúng giờ'),
    UserAttendance(id: '2', name: 'Nguyễn Văn B', team: 'Nhóm 2', department: 'Đào tạo', attendance: 'Đúng giờ'),
    UserAttendance(id: '3', name: 'Nguyễn Văn C', team: 'Nhóm 3', department: 'Đào tạo', attendance: 'Đúng giờ'),
    UserAttendance(id: '4', name: 'Nguyễn Văn D', team: 'Nhóm 4', department: 'Đào tạo', attendance: 'Đúng giờ'),
    UserAttendance(id: '5', name: 'Nguyễn Văn E', team: 'Nhóm 5', department: 'Đào tạo', attendance: 'Đúng giờ'),
    UserAttendance(id: '6', name: 'Nguyễn Văn F', team: 'Nhóm 6', department: 'Đào tạo', attendance: 'Trễ'),
    UserAttendance(id: '7', name: 'Nguyễn Văn G', team: 'Nhóm 7', department: 'Đào tạo', attendance: 'Trễ'),
    UserAttendance(id: '8', name: 'Nguyễn Văn H', team: 'Nhóm 8', department: 'Đào tạo', attendance: 'Trễ'),
    UserAttendance(id: '9', name: 'Nguyễn Văn I', team: 'Nhóm 9', department: 'Đào tạo', attendance: 'Trễ'),
    UserAttendance(id: '10', name: 'Nguyễn Văn K', team: 'Nhóm 10', department: 'Đào tạo', attendance: 'Trễ'),
    UserAttendance(id: '11', name: 'Nguyễn Văn L', team: 'Nhóm 11', department: 'Đào tạo', attendance: 'Vắng'),
    UserAttendance(id: '12', name: 'Nguyễn Văn M', team: 'Nhóm 12', department: 'Đào tạo', attendance: 'Vắng'),
    UserAttendance(id: '13', name: 'Nguyễn Văn N', team: 'Nhóm 13', department: 'Đào tạo', attendance: 'Vắng'),
    UserAttendance(id: '14', name: 'Nguyễn Văn O', team: 'Nhóm 14', department: 'Đào tạo', attendance: 'Vắng'),
    UserAttendance(id: '15', name: 'Nguyễn Văn P', team: 'Nhóm 15', department: 'Đào tạo', attendance: 'Vắng'),
    UserAttendance(id: '16', name: 'Nguyễn Văn L', team: 'Nhóm 11', department: 'Đào tạo', attendance: 'Được đi trễ'),
    UserAttendance(id: '17', name: 'Nguyễn Văn M', team: 'Nhóm 12', department: 'Đào tạo', attendance: 'Được đi trễ'),
    UserAttendance(id: '18', name: 'Nguyễn Văn N', team: 'Nhóm 13', department: 'Đào tạo', attendance: 'Được đi trễ'),
    UserAttendance(id: '19', name: 'Nguyễn Văn O', team: 'Nhóm 14', department: 'Đào tạo', attendance: 'Được đi trễ'),
    UserAttendance(id: '20', name: 'Nguyễn Văn P', team: 'Nhóm 15', department: 'Đào tạo', attendance: 'Được đi trễ'),
  ];

  List<UserAttendance> userLateExcuses = [
    UserAttendance(id: '1', name: 'Nguyễn Văn A', team: 'Nhóm 1', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '2', name: 'Nguyễn Văn B', team: 'Nhóm 2', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '3', name: 'Nguyễn Văn C', team: 'Nhóm 3', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '4', name: 'Nguyễn Văn D', team: 'Nhóm 4', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '5', name: 'Nguyễn Văn E', team: 'Nhóm 5', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '6', name: 'Nguyễn Văn F', team: 'Nhóm 6', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '7', name: 'Nguyễn Văn G', team: 'Nhóm 7', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '8', name: 'Nguyễn Văn H', team: 'Nhóm 8', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '9', name: 'Nguyễn Văn I', team: 'Nhóm 9', department: 'Đào tạo', attendance: 'Mới'),
  ];

  @override
  void initState() {
    super.initState();
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
              height: MediaQuery.of(context).size.height * 0.2
          ),
          Card(
              elevation: 0.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 80.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.58,
                child: _buildTableCalendarWithBuilders(),
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
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.6),
            child: ListView(
              children: <Widget>[

                //Báo cáo điểm danh ngày
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04, right: MediaQuery.of(context).size.width * 0.04),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: IconTextButtonSmall2(
                      text: 'Báo cáo điểm danh ngày ${DateFormat('dd-MM-yyyy').format(_selectedDay)}',
                      imageUrl: 'assets/images/attended-person.png',
                      colorsButton: const [Colors.blue, Colors.white],
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => HrManagerAttendanceList(
                              attendanceType:  'Ngày ${DateFormat('dd-MM-yyyy').format(_selectedDay)}',
                              userAttendances: userAttendances,
                            ),
                        ));
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20.0,),

                //Số đơn xin phép đi trễ
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04, right: MediaQuery.of(context).size.width * 0.04),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: IconTextButtonSmall2(
                      text: 'Xin phép đi trễ ngày ${DateFormat('dd-MM-yyyy').format(_selectedDay)}',
                      imageUrl: 'assets/images/late-excuse.png',
                      colorsButton: const [Colors.grey, Colors.white],
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => HrManagerLateExcuseList(
                              attendanceType: 'Xin phép đi trễ',
                              userLateExcuses: userLateExcuses,
                            )
                        ));
                      },
                    ),
                  ),
                ),
              ],
            ),
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
}

class UserAttendance{
  String id;
  String name;
  String team;
  String department;
  String attendance;

  UserAttendance({
    required this.id,
    required this.name,
    required this.team,
    required this.department,
    required this.attendance
  });

  @override
  String toString() {
    return 'id: $id, name: $name, team: $team, department: $department, attendance: $attendance';
  }
}