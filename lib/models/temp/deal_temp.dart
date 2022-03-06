class Deal{
  String dealId;
  String name;
  String dealName;
  String dealStage;
  String amount;
  String dealOwner;
  String department;
  String team;
  bool vat;
  String service;
  String dealType;
  late String company;
  String priority;
  DateTime dealDate;
  DateTime closeDate;

  Deal({
    required this.dealId,
    required this.name,
    required this.dealName,
    required this.dealStage,
    required this.amount,
    required this.dealOwner,
    required this.department,
    required this.team,
    required this.vat,
    required this.service,
    required this.dealType,
    required this.priority,
    required this.dealDate,
    required this.closeDate,
  });
}