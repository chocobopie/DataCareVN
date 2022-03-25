import 'dart:convert';

DealPermission dealPermissionFromJson(String str) => DealPermission.fromJson(json.decode(str));

String dealPermissionToJson(DealPermission data) => json.encode(data.toJson());

class DealPermission {
  DealPermission({
    required this.dealPermissionId,
    required this.create,
    required this.view,
    required this.update,
    required this.delete,
  });

  int dealPermissionId;
  int create;
  int view;
  int update;
  int delete;

  factory DealPermission.fromJson(Map<String, dynamic> json) => DealPermission(
    dealPermissionId: json["dealPermissionId"],
    create: json["create"],
    view: json["view"],
    update: json["update"],
    delete: json["delete"],
  );

  Map<String, dynamic> toJson() => {
    "dealPermissionId": dealPermissionId,
    "create": create,
    "view": view,
    "update": update,
    "delete": delete,
  };
}