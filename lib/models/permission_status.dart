import 'dart:convert';

PermissionStatus permissionStatusFromJson(String str) => PermissionStatus.fromJson(json.decode(str));

String permissionStatusToJson(PermissionStatus data) => json.encode(data.toJson());

class PermissionStatus {
  PermissionStatus({
    required this.permissionStatusId,
    required this.name,
  });

  int permissionStatusId;
  String name;

  factory PermissionStatus.fromJson(Map<String, dynamic> json) => PermissionStatus(
    permissionStatusId: json["permissionStatusId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "permissionStatusId": permissionStatusId,
    "name": name,
  };
}