
import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/services/api_service.dart';

class DealViewModel with ChangeNotifier{

  Future<Deal> getADealbyDealId({required int accountId, required int dealId}) async {
    Deal deal = await ApiService().getADealByDealId(accountId: accountId, dealId: dealId);

    notifyListeners();

    return deal;
  }
}