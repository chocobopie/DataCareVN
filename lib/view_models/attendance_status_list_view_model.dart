import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/attendance_status.dart';
import 'package:login_sample/services/api_service.dart';

class AttendanceStatusListViewModel with ChangeNotifier{
  Future<List<AttendanceStatus>> getAttendanceStatus() async {
    List<AttendanceStatus> result = await ApiService().getAttendanceStatus();

    notifyListeners();

    return result;
  }
}