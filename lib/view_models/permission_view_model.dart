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
  Future<AccountPermission> updateAccountPermission({required AccountPermission accountPermission}) async {
    AccountPermission accountPerm = await ApiService().updateAccountPermission(accountPermission: accountPermission);

    notifyListeners();

    return accountPerm;
  }

  //AttendancePermissionId,
  Future<AttendancePermission> getAttendancePermissionById({required int attendancePermissionId}) async {
    AttendancePermission attendancePermission = await ApiService().getAttendancePermissionById(attendancePermissionId: attendancePermissionId);

    notifyListeners();

    return attendancePermission;
  }
  Future<AttendancePermission> updateAttendancePermission({required AttendancePermission attendancePermission}) async {
    AttendancePermission attendancePerm = await ApiService().updateAttendancePermission(attendancePermission: attendancePermission);

    notifyListeners();

    return attendancePerm;
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
  Future<ContactPermission> updateContactPermission({required ContactPermission contactPermission}) async {
    ContactPermission contactPerm = await ApiService().updateContactPermission(contactPermission: contactPermission);

    notifyListeners();

    return contactPerm;
  }

  //DealPermissionId,
  Future<DealPermission> getDealPermissionById({required int dealPermissionId}) async {
    DealPermission dealPermission = await ApiService().getDealPermissionById(dealPermissionId: dealPermissionId);

    notifyListeners();

    return dealPermission;
  }
  Future<DealPermission> updateDealPermission({required DealPermission dealPermission}) async {
    DealPermission dealPerm = await ApiService().updateDealPermission(dealPermission: dealPermission);

    notifyListeners();

    return dealPerm;
  }

  //IssuePermissionId,
  Future<IssuePermission> getIssuePermissionById({required int issuePermissionId}) async {
    IssuePermission issuePermission = await ApiService().getIssuePermissionById(issuePermissionId: issuePermissionId);

    notifyListeners();

    return issuePermission;
  }
  Future<IssuePermission> updateIssuePermission({required IssuePermission issuePermission}) async {
    IssuePermission issuePerm = await ApiService().updateIssuePermission(issuePermission: issuePermission);

    notifyListeners();

    return issuePerm;
  }

}