import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/utilities/utils.dart';

class EmpAttendanceReport extends StatefulWidget {
  const EmpAttendanceReport({Key? key}) : super(key: key);

  @override
  _EmpAttendanceReportState createState() => _EmpAttendanceReportState();
}

class _EmpAttendanceReportState extends State<EmpAttendanceReport> {

  final ScrollController _scrollController = ScrollController();
  List<Attendance> attendances = [];
  bool loading = false, allLoaded = false;
  DateTime dateTime = DateTime.now();

  mockFetch() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    List<Attendance> newData = attendances.length >= 100 ? [] : List.generate(20, (index)
    => Attendance(
        attendanceId: index + attendances.length,
        accountId: 1,
        date: dateTime = dateTime.add(const Duration(days: 1)),
        attendanceStatusId: 0
    ));
    if (newData.isNotEmpty) {
      attendances.addAll(newData);
    }
    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    mockFetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent &&
          !loading) {
        mockFetch();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _fromDate = '';
  String _toDate = '';

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
                padding: const EdgeInsets.only(left: 15.0),
                child: ListView(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          child: TextField(
                            readOnly: true,
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final excuseDate = await DatePicker.showDatePicker(
                                context,
                                locale : LocaleType.vi,
                                minTime: DateTime.now().subtract(const Duration(days: 365)),
                                currentTime: DateTime.now(),
                                maxTime: DateTime.now(),
                              );
                              if(excuseDate != null){
                                _fromDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(excuseDate)}';
                                print('Từ ngày $excuseDate');
                              }
                            },
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.only(left: 20.0),
                              labelText: 'Từ ngày',
                              hintText: _fromDate.isNotEmpty ? _fromDate : 'Ngày ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 107, 106, 144),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          width: 160.0,
                        ),
                        const SizedBox(width: 40.0,),
                        SizedBox(
                          child: TextField(
                            readOnly: true,
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final excuseDate = await DatePicker.showDatePicker(
                                context,
                                locale : LocaleType.vi,
                                minTime: DateTime.now().subtract(const Duration(days: 365)),
                                currentTime: DateTime.now(),
                                maxTime: DateTime.now(),
                              );
                              if(excuseDate != null){
                                _toDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(excuseDate)}';
                                print('Đến ngày $excuseDate');
                              }
                            },
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.only(left: 20.0),
                              labelText: 'Đến ngày',
                              hintText: _toDate.isNotEmpty ? _toDate : 'Ngày ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 107, 106, 144),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          width: 160.0,
                        ),
                      ],
                    )
                  ],
                ),
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
                child: attendances.isNotEmpty ? Stack(
                  children: [
                    ListView.separated(
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          if (index < attendances.length) {
                            return ListTile(
                              title: Text('Ngày: ${DateFormat('dd-MM-yyyy').format(attendances[index].date)}'),
                              dense: true,
                              trailing: const Text('Có mặt'),
                            );
                          } else {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: const Center(
                                  child: Text(
                                      'Bạn đã đến cuối danh sách')),
                            );
                          }
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 2,
                            thickness: 2,
                          );
                        },
                        itemCount: attendances.length + (allLoaded ? 1 : 0)),
                    if (loading) ...[
                      Positioned(
                          left: 0,
                          bottom: 0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          )),
                    ]
                  ],
                )
                    : const Center(child: CircularProgressIndicator()),
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

  // Widget _buildTableCalendarWithBuilders() {
  //   return Column(
  //     children: [
  //       TableCalendar(
  //         focusedDay: _focusedDay,
  //         firstDay: DateTime(2016),
  //         lastDay: DateTime.now(),
  //         locale: 'en_US',
  //         startingDayOfWeek: StartingDayOfWeek.monday,
  //         calendarFormat: CalendarFormat.month,
  //         availableGestures: AvailableGestures.all,
  //         availableCalendarFormats: const {
  //           CalendarFormat.month: '',
  //           CalendarFormat.week: '',
  //         },
  //         selectedDayPredicate: (DateTime date) {
  //           return isSameDay(_selectedDay, date);
  //         },
  //         onDaySelected: (DateTime selectDay, DateTime focusDay) {
  //           setState(() {
  //             _selectedDay = selectDay;
  //             _focusedDay = focusDay;
  //           });
  //         },
  //         eventLoader: _getEvents,
  //         calendarStyle: CalendarStyle(
  //           isTodayHighlighted: false,
  //           outsideDaysVisible: false,
  //           weekendTextStyle:
  //               const TextStyle().copyWith(color: Colors.blue[800]),
  //           holidayTextStyle:
  //               const TextStyle().copyWith(color: Colors.blue[800]),
  //         ),
  //         daysOfWeekStyle: DaysOfWeekStyle(
  //           weekendStyle: const TextStyle().copyWith(color: Colors.blue[600]),
  //         ),
  //         headerStyle: const HeaderStyle(
  //           titleCentered: true,
  //           formatButtonVisible: false,
  //         ),
  //       ),
  //       ..._getEvents(_selectedDay).map((Event event) => ListTile(
  //             title: Text(event.title),
  //           ))
  //     ],
  //   );
  // }
}
