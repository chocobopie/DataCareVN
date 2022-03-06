import 'dart:convert';

Vat vatFromJson(String str) => Vat.fromJson(json.decode(str));

String vatToJson(Vat data) => json.encode(data.toJson());

class Vat {
  Vat({
    required this.vatId,
    required this.name,
  });

  int vatId;
  String name;

  factory Vat.fromJson(Map<String, dynamic> json) => Vat(
    vatId: json["vatId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "vatId": vatId,
    "name": name,
  };
}