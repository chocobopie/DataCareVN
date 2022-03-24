import 'dart:convert';

Permission permissionFromJson(String str) => Permission.fromJson(json.decode(str));

String permissionToJson(Permission data) => json.encode(data.toJson());

class Permission {
  Permission({
    required this.permissionId,
    required this.accountPermissionId,
    required this.attendancePermissionId,
    required this.payrollPermissionId,
    required this.contactPermissionId,
    required this.dealPermissionId,
    required this.issuePermissionId,
    required this.departmentId,
    required this.teamId,
  });

  int permissionId;
  int accountPermissionId;
  int attendancePermissionId;
  int payrollPermissionId;
  int contactPermissionId;
  int dealPermissionId;
  int issuePermissionId;
  int departmentId;
  int teamId;

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
    permissionId: json["permissionId"],
    accountPermissionId: json["accountPermissionId"],
    attendancePermissionId: json["attendancePermissionId"],
    payrollPermissionId: json["payrollPermissionId"],
    contactPermissionId: json["contactPermissionId"],
    dealPermissionId: json["dealPermissionId"],
    issuePermissionId: json["issuePermissionId"],
    departmentId: json["departmentId"],
    teamId: json["teamId"],
  );

  Map<String, dynamic> toJson() => {
    "permissionId": permissionId,
    "accountPermissionId": accountPermissionId,
    "attendancePermissionId": attendancePermissionId,
    "payrollPermissionId": payrollPermissionId,
    "contactPermissionId": contactPermissionId,
    "dealPermissionId": dealPermissionId,
    "issuePermissionId": issuePermissionId,
    "departmentId": departmentId,
    "teamId": teamId,
  };
}