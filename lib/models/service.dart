import 'dart:convert';

Service serviceFromJson(String str) => Service.fromJson(json.decode(str));

String serviceToJson(Service data) => json.encode(data.toJson());

class Service {
  Service({
    required this.serviceId,
    required this.name,
  });

  int serviceId;
  String name;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    serviceId: json["serviceId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "serviceId": serviceId,
    "name": name,
  };
}