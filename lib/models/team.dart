import 'dart:convert';

Team teamFromJson(String str) => Team.fromJson(json.decode(str));

String teamToJson(Team data) => json.encode(data.toJson());

class Team {
  Team({
    this.teamId,
    required this.departmentId,
    required this.name,
    this.maxPage,
  });

  int? teamId;
  int departmentId;
  String name;
  int? maxPage;

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    teamId: json["teamId"],
    departmentId: json["departmentId"],
    name: json["name"],
    maxPage: json["maxPage"],
  );

  Map<String, dynamic> toJson() => {
    "teamId": teamId,
    "departmentId": departmentId,
    "name": name,
    "maxPage": maxPage,
  };
}