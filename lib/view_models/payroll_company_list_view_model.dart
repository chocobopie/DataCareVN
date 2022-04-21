import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/PayrollCompany.dart';
import 'package:login_sample/services/api_service.dart';

class PayrollCompanyListViewModel with ChangeNotifier{
  Future<List<PayrollCompany>?> getListPayrollCompany({required bool isRefresh, required int currentPage, int? payrollCompanyId, int? isClosing, DateTime? fromDate, DateTime? toDate, int? limit}) async {
    List<PayrollCompany>? result = await ApiService().getListPayrollCompany(isRefresh: isRefresh, currentPage: currentPage, payrollCompanyId: payrollCompanyId, fromDate: fromDate, toDate: toDate, isClosing: isClosing, limit: limit);

    notifyListeners();

    return result;
  }
}