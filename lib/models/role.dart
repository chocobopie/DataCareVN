import 'dart:convert';

Role roleFromJson(String str) => Role.fromJson(json.decode(str));

String roleToJson(Role data) => json.encode(data.toJson());

class Role {
  Role({
    required this.roleId,
    required this.name,
  });

  int roleId;
  String name;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    roleId: json["roleId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "roleId": roleId,
    "name": name,
  };
}