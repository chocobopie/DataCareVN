import 'dart:convert';

Gender genderFromJson(String str) => Gender.fromJson(json.decode(str));

String genderToJson(Gender data) => json.encode(data.toJson());

class Gender {
  Gender({
    required this.genderId,
    required this.name,
  });

  int genderId;
  String name;

  factory Gender.fromJson(Map<String, dynamic> json) => Gender(
    genderId: json["genderId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "genderId": genderId,
    "name": name,
  };
}