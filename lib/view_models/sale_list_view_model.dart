import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/sale.dart';
import 'package:login_sample/services/api_service.dart';

class SaleListViewModel with ChangeNotifier{
  Future<List<Sale>?> getListSales({required bool isRefresh, required int currentPage, int? payrollId, int? saleId, int? limit}) async {
    List<Sale>? result = await ApiService().getListSales(isRefresh: isRefresh, currentPage: currentPage, limit: limit, payrollId: payrollId, saleId: saleId);

    notifyListeners();

    return result;
  }
}