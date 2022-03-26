import 'dart:convert';

AttendancePermission attendancePermissionFromJson(String str) => AttendancePermission.fromJson(json.decode(str));

String attendancePermissionToJson(AttendancePermission data) => json.encode(data.toJson());

class AttendancePermission {
  AttendancePermission({
    this.attendancePermissionId,
    required this.view,
    required this.update,
  });

  int? attendancePermissionId;
  int view;
  int update;

  factory AttendancePermission.fromJson(Map<String, dynamic> json) => AttendancePermission(
    attendancePermissionId: json["attendancePermissionId"],
    view: json["view"],
    update: json["update"],
  );

  Map<String, dynamic> toJson() => {
    "attendancePermissionId": attendancePermissionId,
    "view": view,
    "update": update,
  };
}