import 'dart:convert';

Deal dealFromJson(String str) => Deal.fromJson(json.decode(str));

String dealToJson(Deal data) => json.encode(data.toJson());

class Deal {
  Deal({
    required this.dealId,
    required this.title,
    required this.dealStageId,
    required this.amount,
    required this.closedDate,
    required this.dealOwnerId,
    this.linkTrello,
    required this.vatId,
    required this.serviceId,
    required this.dealTypeId,
    required this.contactId,
    this.maxPage,
  });

  int dealId;
  String title;
  int dealStageId;
  num amount;
  DateTime closedDate;
  int dealOwnerId;
  String? linkTrello;
  int vatId;
  int serviceId;
  int dealTypeId;
  int contactId;
  int? maxPage;

  factory Deal.fromJson(Map<String, dynamic> json) => Deal(
    dealId: json["dealId"],
    title: json["title"],
    dealStageId: json["dealStageId"],
    amount: json["amount"],
    closedDate: DateTime.parse(json["closedDate"]),
    dealOwnerId: json["dealOwnerId"],
    linkTrello: json["linkTrello"],
    vatId: json["vatId"],
    serviceId: json["serviceId"],
    dealTypeId: json["dealTypeId"],
    contactId: json["contactId"],
    maxPage: json["maxPage"],
  );

  Map<String, dynamic> toJson() => {
    "dealId": dealId,
    "title": title,
    "dealStageId": dealStageId,
    "amount": amount,
    "closedDate": closedDate.toIso8601String(),
    "dealOwnerId": dealOwnerId,
    "linkTrello": linkTrello,
    "vatId": vatId,
    "serviceId": serviceId,
    "dealTypeId": dealTypeId,
    "contactId": contactId,
    "maxPage": maxPage,
  };
}