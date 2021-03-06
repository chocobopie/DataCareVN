import 'dart:convert';

Issue issueFromJson(String str) => Issue.fromJson(json.decode(str));

String issueToJson(Issue data) => json.encode(data.toJson());

class Issue {
  Issue({
    this.issueId,
    required this.ownerId,
    required this.dealId,
    required this.title,
    required this.taggedAccountId,
    required this.description,
    this.createdDate,
    required this.deadlineDate,
    this.maxPage,
  });

  int? issueId;
  int ownerId;
  int dealId;
  String title;
  int taggedAccountId;
  String description;
  DateTime? createdDate;
  DateTime deadlineDate;
  int? maxPage;

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
    issueId: json["issueId"],
    ownerId: json["ownerId"],
    dealId: json["dealId"],
    title: json["title"],
    taggedAccountId: json["taggedAccountId"],
    description: json["description"],
    createdDate: DateTime.parse(json["createdDate"]),
    deadlineDate: DateTime.parse(json["deadlineDate"]),
    maxPage: json["maxPage"],
  );

  Map<String, dynamic> toJson() => {
    "issueId": issueId,
    "ownerId": ownerId,
    "dealId": dealId,
    "title": title,
    "taggedAccountId": taggedAccountId,
    "description": description,
    "createdDate": createdDate?.toIso8601String(),
    "deadlineDate": deadlineDate.toIso8601String(),
    "maxPage": maxPage,
  };
}