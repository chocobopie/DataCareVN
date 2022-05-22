import 'package:flutter/material.dart';
import 'package:login_sample/models/attendance_rule.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/attendance_rule_view_model.dart';
import 'package:login_sample/widgets/CustomListTile.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';

class HrAttendanceRule extends StatefulWidget {
  const HrAttendanceRule({Key? key}) : super(key: key);

  @override
  State<HrAttendanceRule> createState() => _HrAttendanceRuleState();
}

class _HrAttendanceRuleState extends State<HrAttendanceRule> {

  AttendanceRule? _attendanceRule;

  final TextEditingController _maximumApprovedLateShiftPerMonthController = TextEditingController();
  final TextEditingController _maximumApprovedAbsenceShiftPerMonthController = TextEditingController();
  final TextEditingController _maximumApprovedAbsenceShiftPerYearController = TextEditingController();
  final TextEditingController _fineForEachLateShiftController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAttendanceRule();
  }

  @override
  void dispose() {
    super.dispose();
    _maximumApprovedLateShiftPerMonthController.dispose();
    _maximumApprovedAbsenceShiftPerMonthController.dispose();
    _maximumApprovedAbsenceShiftPerYearController.dispose();
    _fineForEachLateShiftController.dispose();
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
                padding: const EdgeInsets.only(top: 20.0, left: 2.0, right: 2.0),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      _attendanceRule != null ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                          children: <Widget>[
                            CustomListTile(listTileLabel: 'Số ca cho nghỉ có phép mỗi năm', alertDialogLabel: 'Cập nhật số ca cho nghỉ có phép mỗi năm', value: _maximumApprovedAbsenceShiftPerYearController.text.isEmpty ? _attendanceRule!.maximumApprovedAbsenceShiftPerYear.toString() : _maximumApprovedAbsenceShiftPerYearController.text ,numberEditController: _maximumApprovedAbsenceShiftPerYearController, readOnly: false, numberFormat: false,),
                            CustomListTile(listTileLabel: 'Số ca cho nghỉ có phép mỗi tháng', alertDialogLabel: 'Cập nhật số ca cho nghỉ có phép mỗi tháng', value: _maximumApprovedAbsenceShiftPerMonthController.text.isEmpty ? _attendanceRule!.maximumApprovedAbsenceShiftPerMonth.toString() : _maximumApprovedAbsenceShiftPerMonthController.text ,numberEditController: _maximumApprovedAbsenceShiftPerMonthController, readOnly: false, numberFormat: false,),
                            CustomListTile(listTileLabel: 'Số ca cho đi trễ có phép mỗi tháng', alertDialogLabel: 'Cập nhật số ca cho đi trễ có phép mỗi tháng:', value: _maximumApprovedLateShiftPerMonthController.text.isEmpty ? _attendanceRule!.maximumApprovedLateShiftPerMonth.toString() : _maximumApprovedLateShiftPerMonthController.text ,numberEditController: _maximumApprovedLateShiftPerMonthController, readOnly: false, numberFormat: false,),
                            CustomListTile(listTileLabel: 'Tiền phạt mỗi ca đi trễ', alertDialogLabel: 'Cập nhật tiền phạt mỗi ca đi trễ:', value: _fineForEachLateShiftController.text.isEmpty ? _attendanceRule!.fineForEachLateShift.toString() : _fineForEachLateShiftController.text ,numberEditController: _fineForEachLateShiftController, readOnly: false, numberFormat: true,),

                            if(_maximumApprovedAbsenceShiftPerYearController.text.isNotEmpty || _maximumApprovedAbsenceShiftPerMonthController.text.isNotEmpty || _maximumApprovedLateShiftPerMonthController.text.isNotEmpty || _fineForEachLateShiftController.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextButton(
                                      color: mainBgColor,
                                      text: 'Lưu',
                                      onPressed: () async {
                                        showLoaderDialog(context);
                                        bool result = await _updateAttendanceRule();
                                        if(result == true){
                                          _getAttendanceRule();
                                          _resetAttendanceRuleController();
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Cập nhật quy định nghỉ phép thành công')),
                                          );
                                        }else{
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Cập nhật quy định nghỉ phép thất bại')),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
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
                "Quy định của công ty",
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

  Future<bool> _updateAttendanceRule() async {
    if(_fineForEachLateShiftController.text.isNotEmpty){
      _fineForEachLateShiftController.text = _fineForEachLateShiftController.text.replaceAll('.', '');
    }

    AttendanceRule attendanceRule = AttendanceRule(
        attendanceRuleId: _attendanceRule!.attendanceRuleId,
        maximumApprovedLateShiftPerMonth: _maximumApprovedAbsenceShiftPerMonthController.text.isEmpty ? _attendanceRule!.maximumApprovedLateShiftPerMonth : int.tryParse(_maximumApprovedAbsenceShiftPerMonthController.text)!,
        maximumApprovedAbsenceShiftPerMonth: _maximumApprovedAbsenceShiftPerMonthController.text.isEmpty ? _attendanceRule!.maximumApprovedAbsenceShiftPerMonth : int.tryParse(_maximumApprovedAbsenceShiftPerMonthController.text)!,
        maximumApprovedAbsenceShiftPerYear: _maximumApprovedAbsenceShiftPerYearController.text.isEmpty ? _attendanceRule!.maximumApprovedAbsenceShiftPerYear : int.tryParse(_maximumApprovedAbsenceShiftPerYearController.text)!,
        fineForEachLateShift: _fineForEachLateShiftController.text.isEmpty ? _attendanceRule!.fineForEachLateShift : num.tryParse(_fineForEachLateShiftController.text)!,
    );

    bool result = await AttendanceRuleViewModel().updateAttendanceRule(attendanceRule);

    return result;
  }

  void _resetAttendanceRuleController() async {
    _maximumApprovedLateShiftPerMonthController.clear();
    _maximumApprovedAbsenceShiftPerMonthController.clear();
    _maximumApprovedAbsenceShiftPerYearController.clear();
    _fineForEachLateShiftController.clear();
  }
}
