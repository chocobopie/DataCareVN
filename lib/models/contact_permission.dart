import 'dart:convert';

ContactPermission contactPermissionFromJson(String str) => ContactPermission.fromJson(json.decode(str));

String contactPermissionToJson(ContactPermission data) => json.encode(data.toJson());

class ContactPermission {
  ContactPermission({
    required this.contactPermissionId,
    required this.create,
    required this.view,
    required this.update,
    required this.delete,
  });

  int contactPermissionId;
  int create;
  int view;
  int update;
  int delete;

  factory ContactPermission.fromJson(Map<String, dynamic> json) => ContactPermission(
    contactPermissionId: json["contactPermissionId"],
    create: json["create"],
    view: json["view"],
    update: json["update"],
    delete: json["delete"],
  );

  Map<String, dynamic> toJson() => {
    "contactPermissionId": contactPermissionId,
    "create": create,
    "view": view,
    "update": update,
    "delete": delete,
  };
}