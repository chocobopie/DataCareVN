
class Department{
  final int departmentId;
  final int blockId;
  final String name;

  Department({
    required this.departmentId,
    required this.blockId,
    required this.name
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    departmentId: json["departmentId"] ?? '',
    blockId: json["blockId"],
    name: json["name"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "departmentId": departmentId,
    "blockId": blockId,
    "name": name,
  };
}