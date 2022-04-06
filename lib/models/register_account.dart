import 'dart:convert';

RegisterAccount registerAccountFromJson(String str) => RegisterAccount.fromJson(json.decode(str));

String registerAccountToJson(RegisterAccount data) => json.encode(data.toJson());

class RegisterAccount {
  RegisterAccount({
    required this.email,
    required this.roleId,
    required this.blockId,
    required this.departmentId,
    required this.teamId,
    required this.manageDepartmentId,
    required this.manageTeamId,
    required this.viewAccountPermissionId,
    required this.viewAttendancePermissionId,
    required this.updateAttendancePermissionId,
    required this.createContactPermissionId,
    required this.viewContactPermissionId,
    required this.updateContactPermissionId,
    required this.deleteContactPermissionId,
    required this.createDealPermissionId,
    required this.viewDealPermissionId,
    required this.updateDealPermissionId,
    required this.deleteDealPermissionId,
    required this.createIssuePermissionId,
    required this.viewIssuePermissionId,
    required this.updateIssuePermissionId,
    required this.deleteIssuePermissionId,
  });

  String email;
  int roleId;
  int blockId;
  int? departmentId;
  int? teamId;
  int? manageDepartmentId;
  int? manageTeamId;
  int? viewAccountPermissionId;
  int? viewAttendancePermissionId;
  int? updateAttendancePermissionId;
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
    manageDepartmentId: json["manageDepartmentId"],
    manageTeamId: json["manageTeamId"],
    viewAccountPermissionId: json["viewAccountPermissionId"],
    viewAttendancePermissionId: json["viewAttendancePermissionId"],
    updateAttendancePermissionId: json["updateAttendancePermissionId"],
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
    "manageDepartmentId": manageDepartmentId,
    "manageTeamId": manageTeamId,
    "viewAccountPermissionId": viewAccountPermissionId,
    "viewAttendancePermissionId": viewAttendancePermissionId,
    "updateAttendancePermissionId": updateAttendancePermissionId,
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