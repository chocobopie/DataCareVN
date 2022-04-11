import 'dart:convert';

Attendance attendanceFromJson(String str) => Attendance.fromJson(json.decode(str));

String attendanceToJson(Attendance data) => json.encode(data.toJson());

class Attendance {
  Attendance({
    required this.attendanceId,
    required this.accountId,
    required this.date,
    required this.attendanceStatusId,
    required this.periodOfDayId,
    this.maxPage,
  });

  int attendanceId;
  int accountId;
  DateTime date;
  int attendanceStatusId;
  int periodOfDayId;
  int? maxPage;

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    attendanceId: json["attendanceId"],
    accountId: json["accountId"],
    date: DateTime.parse(json["date"]),
    attendanceStatusId: json["attendanceStatusId"],
    periodOfDayId: json["periodOfDayId"],
    maxPage: json["maxPage"],
  );

  Map<String, dynamic> toJson() => {
    "attendanceId": attendanceId,
    "accountId": accountId,
    "date": date.toIso8601String(),
    "attendanceStatusId": attendanceStatusId,
    "periodOfDayId": periodOfDayId,
    "maxPage": maxPage,
  };
}