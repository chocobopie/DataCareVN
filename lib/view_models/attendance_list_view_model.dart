import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/services/api_service.dart';

class AttendanceListViewModel with ChangeNotifier{
  Future<List<Attendance>> getAttendanceListByAccountId({required bool isRefresh, required int accountId, required int currentPage,DateTime? fromDate, DateTime? toDate, int? attendanceStatusId}) async {
    List<Attendance> attendanceList = await ApiService().getAttendanceListByAccountId(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage, fromDate: fromDate, toDate: toDate);

    notifyListeners();

    return attendanceList;
  }

  Future<List<Attendance>> getAttendanceListByAccountIdAndStatusId({required int accountId, required int statusId, required bool isRefresh, required DateTime selectedDate, required currentPage}) async {
    List<Attendance> attendanceList = await ApiService().getAttendanceListByAccountIdAndStatusId(accountId: accountId, statusId: statusId, isRefresh: isRefresh, selectedDate: selectedDate, currentPage: currentPage);

    notifyListeners();

    return attendanceList;
  }
}