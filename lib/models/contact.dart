import 'dart:convert';

Contact contactFromJson(String str) => Contact.fromJson(json.decode(str));

String contactToJson(Contact data) => json.encode(data.toJson());

class Contact {
  Contact({
    required this.contactId,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.contactOwnerId,
    required this.companyName,
    required this.leadSourceId,
    required this.genderId,
    this.statusId,
    this.maxPage,
  });


  int contactId;
  String fullname;
  String email;
  String phoneNumber;
  int contactOwnerId;
  String companyName;
  int leadSourceId;
  int genderId;
  int? statusId;
  int? maxPage;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    contactId: json["contactId"],
    fullname: json["fullname"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    contactOwnerId: json["contactOwnerId"],
    companyName: json["companyName"],
    leadSourceId: json["leadSourceId"],
    genderId: json["genderId"],
    statusId: json["statusId"],
    maxPage: json["maxPage"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId,
    "fullname": fullname,
    "email": email,
    "phoneNumber": phoneNumber,
    "contactOwnerId": contactOwnerId,
    "companyName": companyName,
    "leadSourceId": leadSourceId,
    "genderId": genderId,
    "statusId": statusId,
    "maxPage": maxPage,
  };
}