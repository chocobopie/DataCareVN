import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/services/api_service.dart';

class DealViewModel with ChangeNotifier{

  Future<Deal> getADealByAccountIdDealId({required int accountId, required int dealId}) async {
    Deal? deal = await ApiService().getADealByAccountIdDealId(accountId: accountId, dealId: dealId);

    notifyListeners();

    return deal;
  }

  Future<Deal?> getADealByDealId({required int dealId}) async {
    Deal? deal = await ApiService().getADealByDealId(dealId: dealId);

    notifyListeners();

    return deal;
  }
}