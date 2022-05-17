import 'dart:convert';

AttendanceRule attendanceRuleFromJson(String str) => AttendanceRule.fromJson(json.decode(str));

String attendanceRuleToJson(AttendanceRule data) => json.encode(data.toJson());

class AttendanceRule {
  AttendanceRule({
    required this.attendanceRuleId,
    required this.maximumApprovedLateShiftPerMonth,
    required this.maximumApprovedAbsenceShiftPerMonth,
    required this.maximumApprovedAbsenceShiftPerYear,
    required this.fineForEachLateShift,
  });

  int attendanceRuleId;
  int maximumApprovedLateShiftPerMonth;
  int maximumApprovedAbsenceShiftPerMonth;
  int maximumApprovedAbsenceShiftPerYear;
  int fineForEachLateShift;

  factory AttendanceRule.fromJson(Map<String, dynamic> json) => AttendanceRule(
    attendanceRuleId: json["attendanceRuleId"],
    maximumApprovedLateShiftPerMonth: json["maximumApprovedLateShiftPerMonth"],
    maximumApprovedAbsenceShiftPerMonth: json["maximumApprovedAbsenceShiftPerMonth"],
    maximumApprovedAbsenceShiftPerYear: json["maximumApprovedAbsenceShiftPerYear"],
    fineForEachLateShift: json["fineForEachLateShift"],
  );

  Map<String, dynamic> toJson() => {
    "attendanceRuleId": attendanceRuleId,
    "maximumApprovedLateShiftPerMonth": maximumApprovedLateShiftPerMonth,
    "maximumApprovedAbsenceShiftPerMonth": maximumApprovedAbsenceShiftPerMonth,
    "maximumApprovedAbsenceShiftPerYear": maximumApprovedAbsenceShiftPerYear,
    "fineForEachLateShift": fineForEachLateShift,
  };
}