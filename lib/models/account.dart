import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/screens/providers/authenticate.dart';
import 'package:provider/provider.dart';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account extends ChangeNotifier{
  Account({
    this.accountId,
    this.email,
    this.fullname,
    this.phoneNumber,
    this.address,
    this.citizenIdentityCardNumber,
    this.nationality,
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    this.roleId,
    this.blockId,
    this.departmentId,
    this.teamId,
    this.permissionId,
    this.statusId,
    this.genderId,
    this.dateOfBirth,
  });

  int? accountId;
  String? email;
  String? fullname;
  String? phoneNumber;
  String? address;
  String? citizenIdentityCardNumber;
  String? nationality;
  String? bankName;
  String? bankAccountName;
  String? bankAccountNumber;
  int? roleId;
  int? blockId;
  int? departmentId;
  int? teamId;
  int? permissionId;
  int? statusId;
  int? genderId;
  DateTime? dateOfBirth;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    accountId: json["accountId"],
    email: json["email"],
    fullname: json["fullname"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    citizenIdentityCardNumber: json["citizenIdentityCardNumber"],
    nationality: json["nationality"],
    bankName: json["bankName"] ?? '',
    bankAccountName: json["bankAccountName"],
    bankAccountNumber: json["bankAccountNumber"],
    roleId: json["roleId"],
    blockId: json["blockId"],
    departmentId: json["departmentId"],
    teamId: json["teamId"],
    permissionId: json["permissionId"],
    statusId: json["statusId"],
    genderId: json["genderId"],
    dateOfBirth: DateTime?.tryParse(json["dateOfBirth"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "accountId": accountId,
    "email": email,
    "fullname": fullname,
    "phoneNumber": phoneNumber,
    "address": address,
    "citizenIdentityCardNumber": citizenIdentityCardNumber,
    "nationality": nationality,
    "bankName": bankName,
    "bankAccountName": bankAccountName,
    "bankAccountNumber": bankAccountNumber,
    "roleId": roleId,
    "blockId": blockId,
    "departmentId": departmentId,
    "teamId": teamId,
    "permissionId": permissionId,
    "statusId": statusId,
    "genderId": genderId,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
  };
}
