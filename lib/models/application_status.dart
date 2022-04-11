import 'dart:convert';

ApplicationStatus applicationStatusFromJson(String str) => ApplicationStatus.fromJson(json.decode(str));

String applicationStatusToJson(ApplicationStatus data) => json.encode(data.toJson());

class ApplicationStatus {
  ApplicationStatus({
    required this.applicationStatusId,
    required this.name,
  });

  int applicationStatusId;
  String name;

  factory ApplicationStatus.fromJson(Map<String, dynamic> json) => ApplicationStatus(
    applicationStatusId: json["applicationStatusId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "applicationStatusId": applicationStatusId,
    "name": name,
  };
}