import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/sale.dart';
import 'package:login_sample/services/api_service.dart';

class SaleViewModel with ChangeNotifier{
  Future<bool> updateKPI(Sale sale) async {
    bool result = await ApiService().updateKPI(sale);

    notifyListeners();

    return result;
  }
}