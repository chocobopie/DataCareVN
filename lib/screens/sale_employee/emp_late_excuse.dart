import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/screens/sale_employee/emp_late_excuse_list.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/screens/hr_manager/hr_manager_attendance_report.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';
import 'package:login_sample/widgets/ImageTextButton.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EmpLateExcuse extends StatefulWidget {
  const EmpLateExcuse({Key? key}) : super(key: key);

  @override
  _EmpLateExcuseState createState() => _EmpLateExcuseState();
}

class _EmpLateExcuseState extends State<EmpLateExcuse> {

  String _lateExcuseDate = '';
  String _lateExcuseTime = '';
  String _lateReason = '';

  final double _panelHeightClosed = 50.0;

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
              margin: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.1),
              child: ListView(
                padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 5.0),
                children: <Widget>[
                  //Ngày xin đi trễ
                  const SizedBox(height: 20.0,),
                  SizedBox(
                    child: TextField(
                      readOnly: true,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final excuseDate = await DatePicker.showDatePicker(
                            context,
                            locale : LocaleType.vi,
                            minTime: DateTime.now(),
                            currentTime: DateTime.now(),
                            maxTime: DateTime.now().add(const Duration(days: 36500)),
                        );
                        if(excuseDate != null){
                          _lateExcuseDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(excuseDate)}';
                          print('Ngày xin đi trễ $excuseDate');
                        }
                      },
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.only(left: 20.0),
                        labelText: 'Ngày xin đi trễ',
                        hintText: _lateExcuseDate.isNotEmpty ? _lateExcuseDate : 'Ngày ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
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
                    width: 150.0,
                  ),

                  //Thời gian dự kiến đến công ty
                  const SizedBox(height: 20.0,),
                  SizedBox(
                    child: TextField(
                      readOnly: true,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DatePicker.showTime12hPicker(context,
                            showTitleActions: true,
                            onConfirm: (date){
                              _lateExcuseTime = DateFormat.jm().format(date);
                            },
                            locale: LocaleType.vi
                        );
                      },
                      showCursor: false,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.only(left: 20.0),
                        labelText: 'Thời gian dự kiến đến công ty',
                        hintText: _lateExcuseTime.isEmpty ? 'Chỉ được xin đi trễ trước [Số giờ]' : _lateExcuseTime,
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
                    width: 150.0,
                  ),

                  //Lý do
                  const SizedBox(height: 20.0,),
                  SizedBox(
                    child: TextField(
                      maxLines: null,
                      onChanged: (val) {
                        _lateReason = val;
                      },
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0, right: 10.0),
                        labelText: 'Lý do',
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
                    width: 150.0,
                  ),

                  //Nút gửi đơn xin phép đi trễ
                  const SizedBox(height: 20.0,),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: TextButton(onPressed: (){},
                        child: const Text('Gửi', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  IconTextButtonSmall2(
                      imageUrl: 'assets/images/attendance-report.png',
                      text: 'Danh sách đơn xin đi trễ',
                      colorsButton: const [Colors.green, Colors.white],
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const EmpLateExcuseList()
                        ));
                      }
                  ),
                ],
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
                "Xin đi trễ",
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

  Widget _buildSlideUpPanel(){
    return SlidingUpPanel(
      parallaxEnabled: true,
      parallaxOffset: .5,
      maxHeight: MediaQuery.of(context).size.height * 0.9,
      minHeight: _panelHeightClosed,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      header: Padding(
        padding: const EdgeInsets.only(left: 70.0),
        child: TextButton.icon(
            onPressed: (){},
            icon: const Icon(Icons.arrow_upward),
            label: const Text('Danh sách đơn xin phép đi trễ')
        ),
      ),
      panel: Card(
        elevation: 20.0,
        color: mainBgColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 50.0),
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
    );
  }
}

