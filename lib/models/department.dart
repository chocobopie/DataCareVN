import 'dart:convert';

Department departmentFromJson(String str) => Department.fromJson(json.decode(str));

String departmentToJson(Department data) => json.encode(data.toJson());

class Department {
  Department({
    this.departmentId,
    required this.blockId,
    required this.name,
    this.maxPage,
  });

  int? departmentId;
  int blockId;
  String name;
  int? maxPage;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    departmentId: json["departmentId"],
    blockId: json["blockId"],
    name: json["name"],
    maxPage: json["maxPage"],
  );

  Map<String, dynamic> toJson() => {
    "departmentId": departmentId,
    "blockId": blockId,
    "name": name,
    "maxPage": maxPage,
  };
}