import 'dart:convert';

ApplicationType applicationTypeFromJson(String str) => ApplicationType.fromJson(json.decode(str));

String applicationTypeToJson(ApplicationType data) => json.encode(data.toJson());

class ApplicationType {
  ApplicationType({
    required this.applicationTypeId,
    required this.name,
  });

  int applicationTypeId;
  String name;

  factory ApplicationType.fromJson(Map<String, dynamic> json) => ApplicationType(
    applicationTypeId: json["applicationTypeId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "applicationTypeId": applicationTypeId,
    "name": name,
  };
}