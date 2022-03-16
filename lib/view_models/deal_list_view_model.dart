
import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/services/api_service.dart';

class DealListViewModel with ChangeNotifier{
  Future<List<Deal>> getAllDealByAccountId({required bool isRefresh, required int accountId, required int currentPage, int? contactId, DateTime? fromDate, DateTime? toDate}) async {
    List<Deal> dealList = [];
    dealList = await ApiService().getAllDealByAccountId(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage, fromDate: fromDate, toDate: toDate, contactId: contactId);

    notifyListeners();

    return dealList;
  }

  Future<List<Deal>> getAllDealByDealOwnerId({required bool isRefresh, required int dealOwnerId, required int currentPage, int? contactId, DateTime? fromDate, DateTime? toDate}) async {
    List<Deal> dealList = [];
    dealList = await ApiService().getAllDealByDealOwnerId(isRefresh: isRefresh, dealOwnerId: dealOwnerId, currentPage: currentPage, fromDate: fromDate, toDate: toDate, contactId: contactId);

    notifyListeners();

    return dealList;
  }
}