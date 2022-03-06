class User{
  String name;
  late DateTime dob;
  String email;
  String phoneNumber;
  late String address;
  late String team;
  String role;
  DateTime joinDate;
  String employeeId;
  String gender;
  late String payroll;
  late String department;

  User({
    required this.employeeId,
    required this.email,
    required this.role,
    required this.name,
    required this.phoneNumber,
    required this.gender,
    required this.joinDate,
    required this.dob,
    required this.department,
    required this.team,
  });
}