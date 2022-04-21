
import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/payroll.dart';
import 'package:login_sample/services/api_service.dart';

class PayrollListViewModel with ChangeNotifier{
  Future<List<Payroll>?> getListPayroll({required bool isRefresh, required int currentPage, int? payrollCompanyId, int? accountId, int? limit}) async {
    List<Payroll>? result = await ApiService().getListPayroll(isRefresh: isRefresh, currentPage: currentPage, payrollCompanyId: payrollCompanyId, accountId: accountId, limit: limit);

    notifyListeners();

    return result;
  }
}