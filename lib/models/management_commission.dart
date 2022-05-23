import 'dart:convert';

ManagementCommission managementCommissionFromJson(String str) => ManagementCommission.fromJson(json.decode(str));

String managementCommissionToJson(ManagementCommission data) => json.encode(data.toJson());

class ManagementCommission {
  ManagementCommission({
    required this.managementCommissionId,
    required this.percentageOfKpi,
    required this.commission,
  });

  int managementCommissionId;
  double percentageOfKpi;
  double commission;

  factory ManagementCommission.fromJson(Map<String, dynamic> json) => ManagementCommission(
    managementCommissionId: json["managementCommissionId"],
    percentageOfKpi: json["percentageOfKPI"].toDouble(),
    commission: json["commission"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "managementCommissionId": managementCommissionId,
    "percentageOfKPI": percentageOfKpi,
    "commission": commission,
  };
}