import 'dart:convert';

Sale saleFromJson(String str) => Sale.fromJson(json.decode(str));

String saleToJson(Sale data) => json.encode(data.toJson());

class Sale {
  Sale({
    required this.saleId,
    required this.payrollId,
    required this.kpi,
    required this.newSignEducationSales,
    required this.renewedEducationSales,
    required this.newSignFacebookContentSales,
    required this.renewedFacebookContentSales,
    required this.newSignWebsiteContentSales,
    required this.renewedWebsiteContentSales,
    required this.adsSales,
  });

  int saleId;
  int payrollId;
  num kpi;
  num newSignEducationSales;
  num renewedEducationSales;
  num newSignFacebookContentSales;
  num renewedFacebookContentSales;
  num newSignWebsiteContentSales;
  num renewedWebsiteContentSales;
  num adsSales;

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
    saleId: json["saleId"],
    payrollId: json["payrollId"],
    kpi: json["kpi"],
    newSignEducationSales: json["newSignEducationSales"],
    renewedEducationSales: json["renewedEducationSales"],
    newSignFacebookContentSales: json["newSignFacebookContentSales"],
    renewedFacebookContentSales: json["renewedFacebookContentSales"],
    newSignWebsiteContentSales: json["newSignWebsiteContentSales"],
    renewedWebsiteContentSales: json["renewedWebsiteContentSales"],
    adsSales: json["adsSales"],
  );

  Map<String, dynamic> toJson() => {
    "saleId": saleId,
    "payrollId": payrollId,
    "kpi": kpi,
    "newSignEducationSales": newSignEducationSales,
    "renewedEducationSales": renewedEducationSales,
    "newSignFacebookContentSales": newSignFacebookContentSales,
    "renewedFacebookContentSales": renewedFacebookContentSales,
    "newSignWebsiteContentSales": newSignWebsiteContentSales,
    "renewedWebsiteContentSales": renewedWebsiteContentSales,
    "adsSales": adsSales,
  };
}