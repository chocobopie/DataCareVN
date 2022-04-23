
import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/payroll.dart';
import 'package:login_sample/services/api_service.dart';

class PayrollViewModel with ChangeNotifier{
  Future<bool> updatePayroll(Payroll payroll) async {
    bool result = await ApiService().updatePayroll(payroll);

    notifyListeners();

    return result;
  }
}