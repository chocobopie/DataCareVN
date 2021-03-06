import 'dart:convert';

Application applicationFromJson(String str) => Application.fromJson(json.decode(str));

String applicationToJson(Application data) => json.encode(data.toJson());

class Application {
  Application({
    this.applicationId,
    required this.accountId,
    this.createdDate,
    required this.assignedDate,
    required this.description,
    this.expectedWorkingTime,
    this.applicationStatusId,
    required this.applicationTypeId,
    this.periodOfDayId,
    this.maxPage,
  });

  int? applicationId;
  int accountId;
  DateTime? createdDate;
  DateTime assignedDate;
  String description;
  DateTime? expectedWorkingTime;
  int? applicationStatusId;
  int applicationTypeId;
  int? periodOfDayId;
  int? maxPage;

  factory Application.fromJson(Map<String, dynamic> json) => Application(
    applicationId: json["applicationId"],
    accountId: json["accountId"],
    createdDate: DateTime.parse(json["createdDate"]),
    assignedDate: DateTime.parse(json["assignedDate"]),
    description: json["description"],
    expectedWorkingTime: DateTime?.tryParse(json["expectedWorkingTime"].toString()),
    applicationStatusId: json["applicationStatusId"],
    applicationTypeId: json["applicationTypeId"],
    periodOfDayId: json["periodOfDayId"],
    maxPage: json["maxPage"],
  );

  Map<String, dynamic> toJson() => {
    "applicationId": applicationId,
    "accountId": accountId,
    "createdDate": createdDate?.toIso8601String(),
    "assignedDate": assignedDate.toIso8601String(),
    "description": description,
    "expectedWorkingTime": expectedWorkingTime?.toIso8601String(),
    "applicationStatusId": applicationStatusId,
    "applicationTypeId": applicationTypeId,
    "periodOfDayId": periodOfDayId,
    "maxPage": maxPage,
  };
}