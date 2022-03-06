import 'dart:convert';

Team teamFromJson(String str) => Team.fromJson(json.decode(str));

String teamToJson(Team data) => json.encode(data.toJson());

class Team {
  Team({
    required this.teamId,
    required this.departmentId,
    required this.name,
  });

  int teamId;
  int departmentId;
  String name;

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    teamId: json["teamId"],
    departmentId: json["departmentId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "teamId": teamId,
    "departmentId": departmentId,
    "name": name,
  };
}