import 'dart:convert';

PeriodOfDay periodOfDayFromJson(String str) => PeriodOfDay.fromJson(json.decode(str));

String periodOfDayToJson(PeriodOfDay data) => json.encode(data.toJson());

class PeriodOfDay {
  PeriodOfDay({
    this.periodOfDayId,
    required this.name,
  });

  int? periodOfDayId;
  String name;

  factory PeriodOfDay.fromJson(Map<String, dynamic> json) => PeriodOfDay(
    periodOfDayId: json["periodOfDayId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "periodOfDayId": periodOfDayId,
    "name": name,
  };
}