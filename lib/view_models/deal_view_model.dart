
import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/services/api_service.dart';

class DealViewModel with ChangeNotifier{
  Future<Deal> getADealByDealId({required int dealId}) async {
    Deal deal = await ApiService().getADealbyDealId(dealId: dealId);

    notifyListeners();

    return deal;
  }
}