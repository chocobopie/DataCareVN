import 'package:flutter/material.dart';
import 'package:login_sample/models/attendance_rule.dart';
import 'package:login_sample/services/api_service.dart';

class AttendanceRuleViewModel with ChangeNotifier{

  Future<AttendanceRule?> getAttendanceRule() async {
    AttendanceRule? result = await ApiService().getAttendanceRule();

    notifyListeners();

    return result;
  }

  Future<bool> updateAttendanceRule(AttendanceRule attendanceRule) async {
    bool result = await ApiService().updateAttendanceRule(attendanceRule);

    notifyListeners();

    return result;
  }
}