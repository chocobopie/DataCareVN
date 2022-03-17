import 'dart:convert';

Attendance attendanceFromJson(String str) => Attendance.fromJson(json.decode(str));

String attendanceToJson(Attendance data) => json.encode(data.toJson());

class Attendance {
  Attendance({
    required this.attendanceId,
    required this.accountId,
    required this.date,
    required this.attendanceStatusId,
    required this.maxPage,
  });

  int attendanceId;
  int accountId;
  DateTime date;
  int attendanceStatusId;
  int maxPage;

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    attendanceId: json["attendanceId"],
    accountId: json["accountId"],
    date: DateTime.parse(json["date"]),
    attendanceStatusId: json["attendanceStatusId"],
    maxPage: json["maxPage"],
  );

  Map<String, dynamic> toJson() => {
    "attendanceId": attendanceId,
    "accountId": accountId,
    "date": date.toIso8601String(),
    "attendanceStatusId": attendanceStatusId,
    "maxPage": maxPage,
  };
}