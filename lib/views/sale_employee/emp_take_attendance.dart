import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:login_sample/views/sale_employee/emp_attendance_report.dart';
import 'package:login_sample/views/sale_employee/emp_late_excuse.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';

class EmpTakeAttendance extends StatefulWidget {
  const EmpTakeAttendance({Key? key}) : super(key: key);

  @override
  _EmpTakeAttendanceState createState() => _EmpTakeAttendanceState();
}

class _EmpTakeAttendanceState extends State<EmpTakeAttendance> {


  late Position currentPosition;
  var geoLocator = Geolocator();

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
              elevation: 0.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              margin: const EdgeInsets.only(top: 100.0),
              child: ListView(
                padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 5.0),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 10.0,),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25.0),
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
                            width: 200.0,
                            height: 50.0,
                            child: TextButton(
                              onPressed: (){

                              },
                              child: const Text(
                                'Điểm danh hôm nay',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),
                      //Xem báo cáo điểm danh
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: IconTextButtonSmall2(
                            imageUrl: 'assets/images/attendance-report.png',
                            text: 'Xem báo cáo điểm danh',
                            colorsButton: const [Colors.green, Colors.white],
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const EmpAttendanceReport(),
                              ));
                            }
                        ),
                        //Xin đi trễ
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: IconTextButtonSmall2(
                            imageUrl: 'assets/images/late-person.png',
                            text: 'Xin đi trễ',
                            colorsButton: const [Colors.red, Colors.white],
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const EmpLateExcuse(),
                              ));
                            }
                        ),
                      ),
                    ],
                  )
                ],
              ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Điểm danh",
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
}
