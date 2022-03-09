import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/views/hr_manager/hr_manager_attendance_report.dart';
import 'package:login_sample/utilities/utils.dart';

class EmpLateExcuseList extends StatefulWidget {
  const EmpLateExcuseList({Key? key}) : super(key: key);

  @override
  _EmpLateExcuseListState createState() => _EmpLateExcuseListState();
}

class _EmpLateExcuseListState extends State<EmpLateExcuseList> {

  String _fromDate = '';
  String _toDate = '';

  List<UserAttendance> userLateExcuses = [
    UserAttendance(id: '1', name: 'Nguyễn Văn A', team: 'Nhóm 1', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '2', name: 'Nguyễn Văn B', team: 'Nhóm 2', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '3', name: 'Nguyễn Văn C', team: 'Nhóm 3', department: 'Đào tạo', attendance: 'Chấp nhận'),
    UserAttendance(id: '4', name: 'Nguyễn Văn D', team: 'Nhóm 4', department: 'Đào tạo', attendance: 'Chấp nhận'),
    UserAttendance(id: '5', name: 'Nguyễn Văn E', team: 'Nhóm 5', department: 'Đào tạo', attendance: 'Chấp nhận'),
    UserAttendance(id: '6', name: 'Nguyễn Văn F', team: 'Nhóm 6', department: 'Đào tạo', attendance: 'Chấp nhận'),
    UserAttendance(id: '7', name: 'Nguyễn Văn G', team: 'Nhóm 7', department: 'Đào tạo', attendance: 'Từ chối'),
    UserAttendance(id: '8', name: 'Nguyễn Văn H', team: 'Nhóm 8', department: 'Đào tạo', attendance: 'Từ chối'),
    UserAttendance(id: '9', name: 'Nguyễn Văn I', team: 'Nhóm 9', department: 'Đào tạo', attendance: 'Từ chối'),
  ];

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
            elevation: 20.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
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
            ),
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
                child: ListView.builder(
                    itemCount: userLateExcuses.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                        child: ListTile(
                          selected: true,
                          selectedTileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          trailing: Text(userLateExcuses[index].attendance),
                          leading: SizedBox(
                            height: 50.0,
                            width: 200.0,
                            child: Row(
                              children: [
                                Column(
                                  children: <Widget>[
                                    const Text('Ngày gửi', style: TextStyle(color: defaultFontColor),),
                                    Text(DateFormat('dd-MM-yyyy').format(DateTime.now())),
                                  ],
                                ),
                                const SizedBox(width: 40.0,),
                                Column(
                                  children: <Widget>[
                                    const Text('Ngày xin đi trễ', style: TextStyle(color: defaultFontColor),),
                                    Text(DateFormat('dd-MM-yyyy').format(DateTime.now())),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ),
          ),


          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              // Add AppBar here only
              iconTheme: const IconThemeData(color: Colors.blueGrey),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Danh sách đơn xin đi trễ",
                style: TextStyle(
                    letterSpacing: 0.0,
                    fontSize: 20.0,
                    color: Colors.blueGrey
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
