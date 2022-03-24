import 'dart:convert';

PayrollPermission payrollPermissionFromJson(String str) => PayrollPermission.fromJson(json.decode(str));

String payrollPermissionToJson(PayrollPermission data) => json.encode(data.toJson());

class PayrollPermission {
  PayrollPermission({
    this.payrollPermissionId,
    this.view,
    this.update,
  });

  int? payrollPermissionId;
  int? view;
  int? update;

  factory PayrollPermission.fromJson(Map<String, dynamic> json) => PayrollPermission(
    payrollPermissionId: json["payrollPermissionId"],
    view: json["view"],
    update: json["update"],
  );

  Map<String, dynamic> toJson() => {
    "payrollPermissionId": payrollPermissionId,
    "view": view,
    "update": update,
  };
}