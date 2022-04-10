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

  Future<bool> createNewDeal(Deal deal) async {
    bool result = await ApiService().createNewDeal(deal);

    notifyListeners();

    return result;
  }

  Future<bool> updateADeal(Deal deal) async {
    bool result = await ApiService().updateADeal(deal);

    notifyListeners();

    return result;
  }

  Future<bool> deleteDeal(int dealId) async {
    bool result = await ApiService().deleteDeal(dealId);

    notifyListeners();

    return result;
  }
}