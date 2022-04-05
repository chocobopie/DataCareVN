import 'dart:convert';

ChangePassword changePasswordFromJson(String str) => ChangePassword.fromJson(json.decode(str));

String changePasswordToJson(ChangePassword data) => json.encode(data.toJson());

class ChangePassword {
  ChangePassword({
    required this.accountId,
    required this.email,
    required this.currentPassword,
    required this.newPassword,
  });

  int accountId;
  String email;
  String currentPassword;
  String newPassword;

  factory ChangePassword.fromJson(Map<String, dynamic> json) => ChangePassword(
    accountId: json["accountId"],
    email: json["email"],
    currentPassword: json["currentPassword"],
    newPassword: json["newPassword"],
  );

  Map<String, dynamic> toJson() => {
    "accountId": accountId,
    "email": email,
    "currentPassword": currentPassword,
    "newPassword": newPassword,
  };
}