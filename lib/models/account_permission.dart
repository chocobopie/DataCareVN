import 'dart:convert';

AccountPermission accountPermissionFromJson(String str) => AccountPermission.fromJson(json.decode(str));

String accountPermissionToJson(AccountPermission data) => json.encode(data.toJson());

class AccountPermission {
  AccountPermission({
    this.accountPermissionId,
    this.create,
    required this.view,
    this.update,
    this.delete,
  });

  int? accountPermissionId;
  int? create;
  int view;
  int? update;
  int? delete;

  factory AccountPermission.fromJson(Map<String, dynamic> json) => AccountPermission(
    accountPermissionId: json["accountPermissionId"],
    create: json["create"],
    view: json["view"],
    update: json["update"],
    delete: json["delete"],
  );

  Map<String, dynamic> toJson() => {
    "accountPermissionId": accountPermissionId,
    "create": create,
    "view": view,
    "update": update,
    "delete": delete,
  };
}