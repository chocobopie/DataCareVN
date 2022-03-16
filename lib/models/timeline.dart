import 'dart:convert';

Timeline timelineFromJson(String str) => Timeline.fromJson(json.decode(str));

String timelineToJson(Timeline data) => json.encode(data.toJson());

class Timeline {
  Timeline({
    required this.timelineId,
    required this.dealId,
    required this.line,
    required this.maxPage,
  });

  int timelineId;
  int dealId;
  String line;
  int maxPage;

  factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
    timelineId: json["timelineId"],
    dealId: json["dealId"],
    line: json["line"],
    maxPage: json["maxPage"],
  );

  Map<String, dynamic> toJson() => {
    "timelineId": timelineId,
    "dealId": dealId,
    "line": line,
    "maxPage": maxPage,
  };
}