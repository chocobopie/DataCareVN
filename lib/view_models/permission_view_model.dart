import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:login_sample/models/account_permission.dart';
import 'package:login_sample/models/attendance_permission.dart';
import 'package:login_sample/models/contact_permission.dart';
import 'package:login_sample/models/deal_permission.dart';
import 'package:login_sample/models/issue_permission.dart';
import 'package:login_sample/models/payroll_permission.dart';
import 'package:login_sample/models/permission.dart';
import 'package:login_sample/services/api_service.dart';

class PermissionViewModel with ChangeNotifier{

  //Permission
  Future<Permission> getPermByPermId({required int permId}) async {
    Permission permission = await ApiService().getPermByPermId(permId: permId);

    notifyListeners();

    return permission;
  }

  //AccountPermissionId,
  Future<AccountPermission> getAccountPermissionById({required int accountPermissionId}) async {
    AccountPermission accountPermission = await ApiService().getAccountPermissionById(accountPermissionId: accountPermissionId);

    notifyListeners();

    return accountPermission;
  }

  //AttendancePermissionId,
  Future<AttendancePermission> getAttendancePermissionById({required int attendancePermissionId}) async {
    AttendancePermission attendancePermission = await ApiService().getAttendancePermissionById(attendancePermissionId: attendancePermissionId);

    notifyListeners();

    return attendancePermission;
  }

  //PayrollPermissionId,
  Future<PayrollPermission> getPayrollPermissionById({required int payrollPermissionId}) async {
    PayrollPermission payrollPermission = await ApiService().getPayrollPermissionById(payrollPermissionId: payrollPermissionId);

    notifyListeners();

    return payrollPermission;
  }

  //ContactPermissionId,
  Future<ContactPermission> getContactPermissionById({required int contactPermissionId}) async {
    ContactPermission contactPermission = await ApiService().getContactPermissionById(contactPermissionId: contactPermissionId);

    notifyListeners();

    return contactPermission;
  }

  //DealPermissionId,
  Future<DealPermission> getDealPermissionById({required int dealPermissionId}) async {
    DealPermission dealPermission = await ApiService().getDealPermissionById(dealPermissionId: dealPermissionId);

    notifyListeners();

    return dealPermission;
  }

  //IssuePermissionId,
  Future<IssuePermission> getIssuePermissionById({required int issuePermissionId}) async {
    IssuePermission issuePermission = await ApiService().getIssuePermissionById(issuePermissionId: issuePermissionId);

    notifyListeners();

    return issuePermission;
  }
}