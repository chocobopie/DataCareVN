import 'dart:convert';

PersonalCommission personalCommissionFromJson(String str) => PersonalCommission.fromJson(json.decode(str));

String personalCommissionToJson(PersonalCommission data) => json.encode(data.toJson());

class PersonalCommission {
  PersonalCommission({
    required this.personalCommissionId,
    required this.percentageOfKpi,
    required this.newSignCommissionForSalesManager,
    required this.renewedSignCommissionForSalesManager,
    required this.newSignCommissionForSalesLeader,
    required this.renewedSignCommissionForSalesLeader,
    required this.newSignCommissionForSalesEmloyee,
    required this.renewedSignCommissionForSalesEmployee,
  });

  int personalCommissionId;
  double percentageOfKpi;
  double newSignCommissionForSalesManager;
  double renewedSignCommissionForSalesManager;
  double newSignCommissionForSalesLeader;
  double renewedSignCommissionForSalesLeader;
  double newSignCommissionForSalesEmloyee;
  double renewedSignCommissionForSalesEmployee;

  factory PersonalCommission.fromJson(Map<String, dynamic> json) => PersonalCommission(
    personalCommissionId: json["personalCommissionId"],
    percentageOfKpi: json["percentageOfKPI"].toDouble(),
    newSignCommissionForSalesManager: json["newSignCommissionForSalesManager"].toDouble(),
    renewedSignCommissionForSalesManager: json["renewedSignCommissionForSalesManager"].toDouble(),
    newSignCommissionForSalesLeader: json["newSignCommissionForSalesLeader"].toDouble(),
    renewedSignCommissionForSalesLeader: json["renewedSignCommissionForSalesLeader"].toDouble(),
    newSignCommissionForSalesEmloyee: json["newSignCommissionForSalesEmloyee"].toDouble(),
    renewedSignCommissionForSalesEmployee: json["renewedSignCommissionForSalesEmployee"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "personalCommissionId": personalCommissionId,
    "percentageOfKPI": percentageOfKpi,
    "newSignCommissionForSalesManager": newSignCommissionForSalesManager,
    "renewedSignCommissionForSalesManager": renewedSignCommissionForSalesManager,
    "newSignCommissionForSalesLeader": newSignCommissionForSalesLeader,
    "renewedSignCommissionForSalesLeader": renewedSignCommissionForSalesLeader,
    "newSignCommissionForSalesEmloyee": newSignCommissionForSalesEmloyee,
    "renewedSignCommissionForSalesEmployee": renewedSignCommissionForSalesEmployee,
  };
}