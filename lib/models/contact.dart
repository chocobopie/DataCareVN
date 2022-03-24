import 'dart:convert';

Contact contactFromJson(String str) => Contact.fromJson(json.decode(str));

String contactToJson(Contact data) => json.encode(data.toJson());

class Contact {
  Contact({
    required this.contactId,
    required this.fullname,
    required this.createdDate,
    required this.email,
    required this.phoneNumber,
    required this.contactOwnerId,
    required this.companyName,
    required this.leadSourceId,
    required this.genderId,
    this.maxPage,
  });

  int contactId;
  String fullname;
  DateTime createdDate;
  String email;
  String phoneNumber;
  int contactOwnerId;
  String companyName;
  int leadSourceId;
  int genderId;
  int? maxPage;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    contactId: json["contactId"],
    fullname: json["fullname"],
    createdDate: DateTime.parse(json["createdDate"]),
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    contactOwnerId: json["contactOwnerId"],
    companyName: json["companyName"],
    leadSourceId: json["leadSourceId"],
    genderId: json["genderId"],
    maxPage: json["maxPage"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId,
    "fullname": fullname,
    "createdDate": createdDate.toIso8601String(),
    "email": email,
    "phoneNumber": phoneNumber,
    "contactOwnerId": contactOwnerId,
    "companyName": companyName,
    "leadSourceId": leadSourceId,
    "genderId": genderId,
    "maxPage": maxPage,
  };
}