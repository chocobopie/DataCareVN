
import 'package:login_sample/models/account.dart';

class PayRoll{
  final int payrollId;
  final int accountId;
  final DateTime date;
  final int kpi;
  final int sales;
  final int basicSalary;
  final int allowance;
  final int parkingFee;
  final int personalInsurance;
  final int companyInsurance;
  final int supporter;
  final int clb20;
  final int personalBonus;
  final int teamBonus;

  PayRoll(this.payrollId, this.accountId, this.date, this.kpi, this.sales, this.basicSalary, this.allowance, this.parkingFee, this.personalInsurance, this.companyInsurance, this.supporter, this.clb20, this.personalBonus, this.teamBonus);
}