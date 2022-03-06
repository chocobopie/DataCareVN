import 'dart:convert';

ExcuseLateStatus excuseLateStatusFromJson(String str) => ExcuseLateStatus.fromJson(json.decode(str));

String excuseLateStatusToJson(ExcuseLateStatus data) => json.encode(data.toJson());

class ExcuseLateStatus {
  ExcuseLateStatus({
    required this.excuseLateStatusId,
    required this.name,
  });

  int excuseLateStatusId;
  String name;

  factory ExcuseLateStatus.fromJson(Map<String, dynamic> json) => ExcuseLateStatus(
    excuseLateStatusId: json["excuseLateStatusId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "excuseLateStatusId": excuseLateStatusId,
    "name": name,
  };
}