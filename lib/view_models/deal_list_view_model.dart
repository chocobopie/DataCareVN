
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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

  Future<List<Deal>?> getDealListBySaleId({required int saleId, required bool isRefresh, required int currentPage,int? limit}) async {
    List<Deal>? dealList = await ApiService().getDealListBySaleId(saleId: saleId, isRefresh: isRefresh, currentPage: currentPage, limit: limit);

    notifyListeners();

    return dealList;
  }
}