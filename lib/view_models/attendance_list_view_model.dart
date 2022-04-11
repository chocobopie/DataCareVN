import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/services/api_service.dart';

class AttendanceListViewModel with ChangeNotifier{

  Future<List<Attendance>?> getSelfAttendanceList({required bool isRefresh, required int accountId, required int currentPage, DateTime? fromDate, DateTime? toDate, int? attendanceStatusId, int? periodOfDayId, int? limit}) async {
    List<Attendance>? attendanceList = await ApiService().getSelfAttendanceList(
        isRefresh: isRefresh, currentPage: currentPage, accountId: accountId,
        attendanceStatusId: attendanceStatusId, fromDate: fromDate, toDate: toDate,
        periodOfDayId: periodOfDayId, limit: limit
    );

    notifyListeners();

    return attendanceList;
  }

  Future<List<Attendance>?> getOtherAttendanceList({required int accountId, required bool isRefresh, DateTime? selectedDate, required currentPage, int? attendanceStatusId , int? periodOfDay, int? limit}) async {
    List<Attendance>? attendanceList = await ApiService().getOtherAttendanceList(accountId: accountId, isRefresh: isRefresh, currentPage: currentPage, selectedDate: selectedDate, attendanceStatusId: attendanceStatusId, periodOfDay: periodOfDay, limit: limit);

    notifyListeners();

    return attendanceList;
  }
}