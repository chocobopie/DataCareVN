
class Contact{
  String id;
  String name;
  String email;
  String phoneNumber;
  DateTime createDate;
  late String contactOwner;
  late String company;

  Contact({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.createDate,
    required this.contactOwner,
    required this.company,
});

}