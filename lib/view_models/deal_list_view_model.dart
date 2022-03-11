
import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/services/api_service.dart';

class DealListViewModel with ChangeNotifier{
  Future<List<Deal>> getAllDealByAccountId({required bool isRefresh, required int accountId, required int currentPage, DateTime? fromDate, DateTime? toDate}) async {
    List<Deal> dealList = [];
    if(fromDate != null && toDate != null ){
      dealList = await ApiService().getAllDealByAccountId(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage, fromDate: fromDate, toDate: toDate);
    }else{
      dealList = await ApiService().getAllDealByAccountId(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage);
    }

    notifyListeners();

    return dealList;
  }

  Future<List<Deal>> getAllDealByDealOwnerId({required bool isRefresh, required int dealOwnerId, required int currentPage, DateTime? fromDate, DateTime? toDate}) async {
    List<Deal> dealList = [];
    if(fromDate != null && toDate != null){
      dealList = await ApiService().getAllDealByDealOwnerId(isRefresh: isRefresh, dealOwnerId: dealOwnerId, currentPage: currentPage, fromDate: fromDate, toDate: toDate);
    } else {
      dealList = await ApiService().getAllDealByDealOwnerId(isRefresh: isRefresh, dealOwnerId: dealOwnerId, currentPage: currentPage,);
    }

    notifyListeners();

    return dealList;
  }
}