import 'dart:convert';

BasicSalaryByGrade basicSalaryByGradeFromJson(String str) => BasicSalaryByGrade.fromJson(json.decode(str));

String basicSalaryByGradeToJson(BasicSalaryByGrade data) => json.encode(data.toJson());

class BasicSalaryByGrade {
  BasicSalaryByGrade({
    required this.basicSalaryByGradeId,
    required this.basicSalary,
    required this.kpi,
    required this.allowance,
  });

  int basicSalaryByGradeId;
  num basicSalary;
  num kpi;
  num allowance;

  factory BasicSalaryByGrade.fromJson(Map<String, dynamic> json) => BasicSalaryByGrade(
    basicSalaryByGradeId: json["basicSalaryByGradeId"],
    basicSalary: json["basicSalary"],
    kpi: json["kpi"],
    allowance: json["allowance"],
  );

  Map<String, dynamic> toJson() => {
    "basicSalaryByGradeId": basicSalaryByGradeId,
    "basicSalary": basicSalary,
    "kpi": kpi,
    "allowance": allowance,
  };
}