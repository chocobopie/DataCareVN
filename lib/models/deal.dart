class Deal {
  int dealId;
  String title;
  int dealStageId;
  int amount;
  DateTime closedDate;
  int? dealOwner;
  String? linkTrello;
  int vatid;
  int serviceId;
  int dealTypeId;
  int contactId;

  Deal({
      required this.dealId,
      required this.title,
      required this.dealStageId,
      required this.amount,
      required this.closedDate,
      required this.dealOwner,
      this.linkTrello,
      required this.vatid,
      required this.serviceId,
      required this.dealTypeId,
      required this.contactId
  });

  factory Deal.fromJson(Map<String, dynamic> json) => Deal(
        dealId: json["dealId"],
        title: json["title"] ?? '',
        dealStageId: json["dealStageId"],
        amount: json["amount"],
        closedDate: DateTime.parse(json["closedDate"]),
        dealOwner: json["dealOwner"],
        linkTrello: json["linkTrello"] ?? '',
        vatid: json["vatid"],
        serviceId: json["serviceId"],
        dealTypeId: json["dealTypeId"],
        contactId: json["contactId"],
      );

  Map<String, dynamic> toJson() => {
        "dealId": dealId,
        "title": title,
        "dealStageId": dealStageId,
        "amount": amount,
        "closedDate": closedDate.toIso8601String(),
        "dealOwner": dealOwner,
        "linkTrello": linkTrello,
        "vatid": vatid,
        "serviceId": serviceId,
        "dealTypeId": dealTypeId,
        "contactId": contactId,
      };

  @override
  String toString() {
    return 'dealId: $dealId, '
        'title: $title, '
        'dealStageId: $dealStageId, '
        'amount: $amount, '
        'closedDate: $closedDate, '
        'dealOwner: $dealOwner, '
        'linkTrello: $linkTrello,'
        'vatid: $vatid,'
        'serviceId: $serviceId,'
        'dealTypeId: $dealTypeId,'
        'contactId: $contactId';
  }
}
