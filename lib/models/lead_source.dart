import 'dart:convert';

LeadSource leadSourceFromJson(String str) => LeadSource.fromJson(json.decode(str));

String leadSourceToJson(LeadSource data) => json.encode(data.toJson());

class LeadSource {
  LeadSource({
    required this.dealStageId,
    required this.name,
  });

  int dealStageId;
  String name;

  factory LeadSource.fromJson(Map<String, dynamic> json) => LeadSource(
    dealStageId: json["dealStageId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "dealStageId": dealStageId,
    "name": name,
  };
}