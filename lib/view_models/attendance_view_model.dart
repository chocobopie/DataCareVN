import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/services/api_service.dart';

class AttendanceViewModel with ChangeNotifier{

  Future<Attendance?> takeAttendance({required Account account}) async {
    Attendance? takeAttend = await ApiService().takeAttendance(account: account);

    notifyListeners();

    return takeAttend;
  }

  Future<bool> updateAnAttendance({required Attendance attendance}) async {
    bool result = await ApiService().updateAnAttendance(attendance: attendance);

    notifyListeners();

    return result;
  }

  Future<int?> getCountAttendance({required int accountId, required DateTime fromDate, required DateTime toDate, required int attendanceStatusId}) async {
    int? result = await ApiService().getCountAttendance(accountId: accountId, fromDate: fromDate, toDate: toDate, attendanceStatusId: attendanceStatusId);

    notifyListeners();

    return result;
  }

  Future<int?> getCountAvailableApprovedAbsence({required int accountId, required DateTime fromDate}) async {
    int? result = await ApiService().getCountAvailableApprovedAbsence(accountId: accountId, fromDate: fromDate);

    notifyListeners();

    return result;
  }
}