import 'dart:convert';

AttendanceStatus attendanceStatusFromJson(String str) => AttendanceStatus.fromJson(json.decode(str));

String attendanceStatusToJson(AttendanceStatus data) => json.encode(data.toJson());

class AttendanceStatus {
  AttendanceStatus({
    required this.attendanceStatusId,
    required this.name,
  });

  int attendanceStatusId;
  String name;

  factory AttendanceStatus.fromJson(Map<String, dynamic> json) => AttendanceStatus(
    attendanceStatusId: json["attendanceStatusId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "attendanceStatusId": attendanceStatusId,
    "name": name,
  };
}