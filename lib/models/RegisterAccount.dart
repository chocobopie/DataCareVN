import 'dart:convert';

RegisterAccount registerAccountFromJson(String str) => RegisterAccount.fromJson(json.decode(str));

String registerAccountToJson(RegisterAccount data) => json.encode(data.toJson());

class RegisterAccount {
  RegisterAccount({
    required this.email,
    required this.roleId,
    required this.blockId,
    this.departmentId,
    this.teamId,
    this.viewAccountPermissionId,
    this.viewAttendancePermissionId,
    this.updateAttendancePermissionId,
    this.hrInternManageDepartmentId,
    this.createContactPermissionId,
    this.viewContactPermissionId,
    this.updateContactPermissionId,
    this.deleteContactPermissionId,
    this.createDealPermissionId,
    this.viewDealPermissionId,
    this.updateDealPermissionId,
    this.deleteDealPermissionId,
    this.createIssuePermissionId,
    this.viewIssuePermissionId,
    this.updateIssuePermissionId,
    this.deleteIssuePermissionId,
  });

  String email;
  int roleId;
  int blockId;
  int? departmentId;
  int? teamId;
  int? viewAccountPermissionId;
  int? viewAttendancePermissionId;
  int? updateAttendancePermissionId;
  int? hrInternManageDepartmentId;
  int? createContactPermissionId;
  int? viewContactPermissionId;
  int? updateContactPermissionId;
  int? deleteContactPermissionId;
  int? createDealPermissionId;
  int? viewDealPermissionId;
  int? updateDealPermissionId;
  int? deleteDealPermissionId;
  int? createIssuePermissionId;
  int? viewIssuePermissionId;
  int? updateIssuePermissionId;
  int? deleteIssuePermissionId;

  factory RegisterAccount.fromJson(Map<String, dynamic> json) => RegisterAccount(
    email: json["email"],
    roleId: json["roleId"],
    blockId: json["blockId"],
    departmentId: json["departmentId"],
    teamId: json["teamId"],
    viewAccountPermissionId: json["viewAccountPermissionId"],
    viewAttendancePermissionId: json["viewAttendancePermissionId"],
    updateAttendancePermissionId: json["updateAttendancePermissionId"],
    hrInternManageDepartmentId: json["hrInternManageDepartmentId"],
    createContactPermissionId: json["createContactPermissionId"],
    viewContactPermissionId: json["viewContactPermissionId"],
    updateContactPermissionId: json["updateContactPermissionId"],
    deleteContactPermissionId: json["deleteContactPermissionId"],
    createDealPermissionId: json["createDealPermissionId"],
    viewDealPermissionId: json["viewDealPermissionId"],
    updateDealPermissionId: json["updateDealPermissionId"],
    deleteDealPermissionId: json["deleteDealPermissionId"],
    createIssuePermissionId: json["createIssuePermissionId"],
    viewIssuePermissionId: json["viewIssuePermissionId"],
    updateIssuePermissionId: json["updateIssuePermissionId"],
    deleteIssuePermissionId: json["deleteIssuePermissionId"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "roleId": roleId,
    "blockId": blockId,
    "departmentId": departmentId,
    "teamId": teamId,
    "viewAccountPermissionId": viewAccountPermissionId,
    "viewAttendancePermissionId": viewAttendancePermissionId,
    "updateAttendancePermissionId": updateAttendancePermissionId,
    "hrInternManageDepartmentId": hrInternManageDepartmentId,
    "createContactPermissionId": createContactPermissionId,
    "viewContactPermissionId": viewContactPermissionId,
    "updateContactPermissionId": updateContactPermissionId,
    "deleteContactPermissionId": deleteContactPermissionId,
    "createDealPermissionId": createDealPermissionId,
    "viewDealPermissionId": viewDealPermissionId,
    "updateDealPermissionId": updateDealPermissionId,
    "deleteDealPermissionId": deleteDealPermissionId,
    "createIssuePermissionId": createIssuePermissionId,
    "viewIssuePermissionId": viewIssuePermissionId,
    "updateIssuePermissionId": updateIssuePermissionId,
    "deleteIssuePermissionId": deleteIssuePermissionId,
  };
}
