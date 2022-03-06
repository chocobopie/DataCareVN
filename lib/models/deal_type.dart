import 'dart:convert';

DealType dealTypeFromJson(String str) => DealType.fromJson(json.decode(str));

String dealTypeToJson(DealType data) => json.encode(data.toJson());

class DealType {
  DealType({
    required this.dealTypeId,
    required this.name,
  });

  int dealTypeId;
  String name;

  factory DealType.fromJson(Map<String, dynamic> json) => DealType(
    dealTypeId: json["dealTypeId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "dealTypeId": dealTypeId,
    "name": name,
  };
}