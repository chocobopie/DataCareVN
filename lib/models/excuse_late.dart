import 'dart:convert';

ExcuseLate excuseLateFromJson(String str) => ExcuseLate.fromJson(json.decode(str));

String excuseLateToJson(ExcuseLate data) => json.encode(data.toJson());

class ExcuseLate {
  ExcuseLate({
    required this.attendanceId,
    required this.dateRequest,
    required this.description,
    required this.expectedWorkingTime,
    required this.excuseLateStatusId,
  });

  int attendanceId;
  DateTime dateRequest;
  String description;
  DateTime expectedWorkingTime;
  int excuseLateStatusId;

  factory ExcuseLate.fromJson(Map<String, dynamic> json) => ExcuseLate(
    attendanceId: json["attendanceId"],
    dateRequest: DateTime.parse(json["dateRequest"]),
    description: json["description"],
    expectedWorkingTime: DateTime.parse(json["expectedWorkingTime"]),
    excuseLateStatusId: json["excuseLateStatusId"],
  );

  Map<String, dynamic> toJson() => {
    "attendanceId": attendanceId,
    "dateRequest": dateRequest.toIso8601String(),
    "description": description,
    "expectedWorkingTime": expectedWorkingTime.toIso8601String(),
    "excuseLateStatusId": excuseLateStatusId,
  };
}