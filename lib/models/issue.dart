import 'dart:convert';

Issue issueFromJson(String str) => Issue.fromJson(json.decode(str));

String issueToJson(Issue data) => json.encode(data.toJson());

class Issue {
  Issue({
    required this.issueId,
    required this.ownerId,
    required this.dealId,
    required this.title,
    required this.taggedAccountId,
    required this.description,
    required this.createdDate,
    required this.dealineDate,
    required this.maxPage,
  });

  int issueId;
  int ownerId;
  int dealId;
  String title;
  int taggedAccountId;
  String description;
  DateTime createdDate;
  DateTime dealineDate;
  int maxPage;

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
    issueId: json["issueId"],
    ownerId: json["ownerId"],
    dealId: json["dealId"],
    title: json["title"],
    taggedAccountId: json["taggedAccountId"],
    description: json["description"],
    createdDate: DateTime.parse(json["createdDate"]),
    dealineDate: DateTime.parse(json["dealineDate"]),
    maxPage: json["maxPage"],
  );

  Map<String, dynamic> toJson() => {
    "issueId": issueId,
    "ownerId": ownerId,
    "dealId": dealId,
    "title": title,
    "taggedAccountId": taggedAccountId,
    "description": description,
    "createdDate": createdDate.toIso8601String(),
    "dealineDate": dealineDate.toIso8601String(),
    "maxPage": maxPage,
  };
}