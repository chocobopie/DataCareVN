import 'dart:convert';

Attendance attendanceFromJson(String str) => Attendance.fromJson(json.decode(str));

String attendanceToJson(Attendance data) => json.encode(data.toJson());

class Attendance {
  Attendance({
    required this.attendanceId,
    required this.accountId,
    required this.date,
    required this.attendanceStatusId,
  });

  final int attendanceId;
  final int accountId;
  final DateTime date;
  final int attendanceStatusId;

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    attendanceId: json["attendanceId"],
    accountId: json["accountId"],
    date: DateTime.parse(json["date"]),
    attendanceStatusId: json["attendanceStatusId"],
  );

  Map<String, dynamic> toJson() => {
    "attendanceId": attendanceId,
    "accountId": accountId,
    "date": date.toIso8601String(),
    "attendanceStatusId": attendanceStatusId,
  };
}