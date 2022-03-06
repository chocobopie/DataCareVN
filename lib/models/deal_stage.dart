import 'dart:convert';

DealStage dealStageFromJson(String str) => DealStage.fromJson(json.decode(str));

String dealStageToJson(DealStage data) => json.encode(data.toJson());

class DealStage {
  DealStage({
    required this.dealStageId,
    required this.name,
  });

  int dealStageId;
  String name;

  factory DealStage.fromJson(Map<String, dynamic> json) => DealStage(
    dealStageId: json["dealStageId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "dealStageId": dealStageId,
    "name": name,
  };
}