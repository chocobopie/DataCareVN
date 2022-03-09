import 'dart:convert';

LeadSource leadSourceFromJson(String str) => LeadSource.fromJson(json.decode(str));

String leadSourceToJson(LeadSource data) => json.encode(data.toJson());

class LeadSource {
  LeadSource({
    required this.leadSourceId,
    required this.name,
  });

  int leadSourceId;
  String name;

  factory LeadSource.fromJson(Map<String, dynamic> json) => LeadSource(
    leadSourceId: json["leadSourceId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "leadSourceId": leadSourceId,
    "name": name,
  };
}