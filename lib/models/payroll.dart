import 'dart:convert';

Payroll payrollFromJson(String str) => Payroll.fromJson(json.decode(str));

String payrollToJson(Payroll data) => json.encode(data.toJson());

class Payroll {
  Payroll({
    required this.payrollId,
    required this.payrollCompanyId,
    required this.accountId,
    required this.basicSalary,
    required this.allowance,
    required this.parkingFee,
    required this.fine,
    required this.personalInsurance,
    required this.companyInsurance,
    required this.actualSalaryReceived,
    required this.newSignPersonalSalesBonus,
    required this.renewedPersonalSalesBonus,
    required this.managementSalesBonus,
    required this.supporterSalesBonus,
    required this.clB20SalesBonus,
    required this.contentManagerFanpageTechnicalEmployeeBonus,
    required this.collaboratorFanpageTechnicalEmployeeBonus,
    required this.renewedFanpageTechnicalEmployeeBonus,
    required this.contentManagerWebsiteAdsTechnicalEmployeeBonus,
    required this.collaboratorWebsiteTechnicalEmployeeBonus,
    required this.renewedWebsiteTechnicalEmployeeBonus,
    required this.collaboratorAdsTechnicalEmployeeBonus,
    required this.lecturerEducationTechnicalEmployeeBonus,
    required this.tutorEducationTechnicalEmployeeBonus,
    required this.techcareEducationTechnicalEmployeeBonus,
    required this.emulationBonus,
    required this.recruitmentBonus,
    required this.personalBonus,
    required this.teamBonus,
  });

  int payrollId;
  int payrollCompanyId;
  int accountId;
  num basicSalary;
  num allowance;
  num parkingFee;
  num fine;
  num personalInsurance;
  num companyInsurance;
  num actualSalaryReceived;
  num newSignPersonalSalesBonus;
  num renewedPersonalSalesBonus;
  num managementSalesBonus;
  num supporterSalesBonus;
  num clB20SalesBonus;
  num contentManagerFanpageTechnicalEmployeeBonus;
  num collaboratorFanpageTechnicalEmployeeBonus;
  num renewedFanpageTechnicalEmployeeBonus;
  num contentManagerWebsiteAdsTechnicalEmployeeBonus;
  num collaboratorWebsiteTechnicalEmployeeBonus;
  num renewedWebsiteTechnicalEmployeeBonus;
  num collaboratorAdsTechnicalEmployeeBonus;
  num lecturerEducationTechnicalEmployeeBonus;
  num tutorEducationTechnicalEmployeeBonus;
  num techcareEducationTechnicalEmployeeBonus;
  num emulationBonus;
  num recruitmentBonus;
  num personalBonus;
  num teamBonus;

  factory Payroll.fromJson(Map<String, dynamic> json) => Payroll(
    payrollId: json["payrollId"],
    payrollCompanyId: json["payrollCompanyId"],
    accountId: json["accountId"],
    basicSalary: json["basicSalary"],
    allowance: json["allowance"],
    parkingFee: json["parkingFee"],
    fine: json["fine"],
    personalInsurance: json["personalInsurance"],
    companyInsurance: json["companyInsurance"],
    actualSalaryReceived: json["actualSalaryReceived"],
    newSignPersonalSalesBonus: json["newSignPersonalSalesBonus"],
    renewedPersonalSalesBonus: json["renewedPersonalSalesBonus"],
    managementSalesBonus: json["managementSalesBonus"],
    supporterSalesBonus: json["supporterSalesBonus"],
    clB20SalesBonus: json["clB20SalesBonus"],
    contentManagerFanpageTechnicalEmployeeBonus: json["contentManagerFanpageTechnicalEmployeeBonus"],
    collaboratorFanpageTechnicalEmployeeBonus: json["collaboratorFanpageTechnicalEmployeeBonus"],
    renewedFanpageTechnicalEmployeeBonus: json["renewedFanpageTechnicalEmployeeBonus"],
    contentManagerWebsiteAdsTechnicalEmployeeBonus: json["contentManagerWebsiteAdsTechnicalEmployeeBonus"],
    collaboratorWebsiteTechnicalEmployeeBonus: json["collaboratorWebsiteTechnicalEmployeeBonus"],
    renewedWebsiteTechnicalEmployeeBonus: json["renewedWebsiteTechnicalEmployeeBonus"],
    collaboratorAdsTechnicalEmployeeBonus: json["collaboratorAdsTechnicalEmployeeBonus"],
    lecturerEducationTechnicalEmployeeBonus: json["lecturerEducationTechnicalEmployeeBonus"],
    tutorEducationTechnicalEmployeeBonus: json["tutorEducationTechnicalEmployeeBonus"],
    techcareEducationTechnicalEmployeeBonus: json["techcareEducationTechnicalEmployeeBonus"],
    emulationBonus: json["emulationBonus"],
    recruitmentBonus: json["recruitmentBonus"],
    personalBonus: json["personalBonus"],
    teamBonus: json["teamBonus"],
  );

  Map<String, dynamic> toJson() => {
    "payrollId": payrollId,
    "payrollCompanyId": payrollCompanyId,
    "accountId": accountId,
    "basicSalary": basicSalary,
    "allowance": allowance,
    "parkingFee": parkingFee,
    "fine": fine,
    "personalInsurance": personalInsurance,
    "companyInsurance": companyInsurance,
    "actualSalaryReceived": actualSalaryReceived,
    "newSignPersonalSalesBonus": newSignPersonalSalesBonus,
    "renewedPersonalSalesBonus": renewedPersonalSalesBonus,
    "managementSalesBonus": managementSalesBonus,
    "supporterSalesBonus": supporterSalesBonus,
    "clB20SalesBonus": clB20SalesBonus,
    "contentManagerFanpageTechnicalEmployeeBonus": contentManagerFanpageTechnicalEmployeeBonus,
    "collaboratorFanpageTechnicalEmployeeBonus": collaboratorFanpageTechnicalEmployeeBonus,
    "renewedFanpageTechnicalEmployeeBonus": renewedFanpageTechnicalEmployeeBonus,
    "contentManagerWebsiteAdsTechnicalEmployeeBonus": contentManagerWebsiteAdsTechnicalEmployeeBonus,
    "collaboratorWebsiteTechnicalEmployeeBonus": collaboratorWebsiteTechnicalEmployeeBonus,
    "renewedWebsiteTechnicalEmployeeBonus": renewedWebsiteTechnicalEmployeeBonus,
    "collaboratorAdsTechnicalEmployeeBonus": collaboratorAdsTechnicalEmployeeBonus,
    "lecturerEducationTechnicalEmployeeBonus": lecturerEducationTechnicalEmployeeBonus,
    "tutorEducationTechnicalEmployeeBonus": tutorEducationTechnicalEmployeeBonus,
    "techcareEducationTechnicalEmployeeBonus": techcareEducationTechnicalEmployeeBonus,
    "emulationBonus": emulationBonus,
    "recruitmentBonus": recruitmentBonus,
    "personalBonus": personalBonus,
    "teamBonus": teamBonus,
  };
}