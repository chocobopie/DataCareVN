import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/services/api_service.dart';

class AttendanceViewModel with ChangeNotifier{

  Future<Attendance> takeAttendance({required Attendance attendance}) async {
    Attendance takeAttend = await ApiService().takeAttendance(attendance: attendance);

    notifyListeners();

    return takeAttend;
  }
}