import 'dart:convert';

PayrollCompany payrollCompanyFromJson(String str) => PayrollCompany.fromJson(json.decode(str));

String payrollCompanyToJson(PayrollCompany data) => json.encode(data.toJson());

class PayrollCompany {
  PayrollCompany({
    required this.payrollCompanyId,
    required this.date,
    required this.isClosing,
  });

  int payrollCompanyId;
  DateTime date;
  int isClosing;

  factory PayrollCompany.fromJson(Map<String, dynamic> json) => PayrollCompany(
    payrollCompanyId: json["payrollCompanyId"],
    date: DateTime.parse(json["date"]),
    isClosing: json["isClosing"],
  );

  Map<String, dynamic> toJson() => {
    "payrollCompanyId": payrollCompanyId,
    "date": date.toIso8601String(),
    "isClosing": isClosing,
  };
}