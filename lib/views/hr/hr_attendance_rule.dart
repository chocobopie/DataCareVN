import 'package:flutter/material.dart';
import 'package:login_sample/models/attendance_rule.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/attendance_rule_view_model.dart';
import 'package:login_sample/widgets/ImageTextButton.dart';

class HrAttendanceRule extends StatefulWidget {
  const HrAttendanceRule({Key? key}) : super(key: key);

  @override
  State<HrAttendanceRule> createState() => _HrAttendanceRuleState();
}

class _HrAttendanceRuleState extends State<HrAttendanceRule> {

  AttendanceRule? _attendanceRule;

  @override
  void initState() {
    super.initState();
    _getAttendanceRule();
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
              margin: const EdgeInsets.only(top: 100.0),
              child: ListView(
                padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      _attendanceRule != null ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                              child: Row(
                                children: <Widget>[
                                  const Text('Số ca cho nghỉ có phép mỗi năm: '),
                                  const Spacer(),
                                  Text('${_attendanceRule!.maximumApprovedAbsenceShiftPerYear}')
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                              child: Row(
                                children: <Widget>[
                                  const Text('Số ca cho nghỉ có phép mỗi tháng: '),
                                  const Spacer(),
                                  Text('${_attendanceRule!.maximumApprovedAbsenceShiftPerMonth}')
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                              child: Row(
                                children: <Widget>[
                                  const Text('Số ca cho đi trễ có phép mỗi tháng: '),
                                  const Spacer(),
                                  Text('${_attendanceRule!.maximumApprovedLateShiftPerMonth}')
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                              child: Row(
                                children: <Widget>[
                                  const Text('Tiền phạt mỗi ca đi trễ: '),
                                  const Spacer(),
                                  Text('${_attendanceRule!.fineForEachLateShift}')
                                ],
                              ),
                            ),
                          ],
                      ),
                        )) : const Center(child: CircularProgressIndicator()),
                    ],
                  )

                ],
              )),

          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.blueGrey,
              ), // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Xem quy định nghỉ phép",
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

  void _getAttendanceRule() async {
    AttendanceRule? result = await AttendanceRuleViewModel().getAttendanceRule();

    if(result != null){
      setState(() {
        _attendanceRule = result;
      });
    }
  }
}
