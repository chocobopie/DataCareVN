import 'dart:convert';

IssuePermission issuePermissionFromJson(String str) => IssuePermission.fromJson(json.decode(str));

String issuePermissionToJson(IssuePermission data) => json.encode(data.toJson());

class IssuePermission {
  IssuePermission({
    this.issuePermissionId,
    this.create,
    this.view,
    this.update,
    this.delete,
  });

  int? issuePermissionId;
  int? create;
  int? view;
  int? update;
  int? delete;

  factory IssuePermission.fromJson(Map<String, dynamic> json) => IssuePermission(
    issuePermissionId: json["issuePermissionId"],
    create: json["create"],
    view: json["view"],
    update: json["update"],
    delete: json["delete"],
  );

  Map<String, dynamic> toJson() => {
    "issuePermissionId": issuePermissionId,
    "create": create,
    "view": view,
    "update": update,
    "delete": delete,
  };
}