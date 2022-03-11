import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/services/api_service.dart';

class AccountListViewModel with ChangeNotifier{

  Future<List<Account>> getAllSalesEmployeesByBlockIdDepartmentId({required bool isRefresh, required int currentPage, required int blockId, required int departmentId}) async {
    List<Account> accountList = await ApiService().getAllAccountByBlockIdDepartmentId(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId);

    notifyListeners();

    return accountList;
  }

  Future<List<Account>> getAccountsByFullname({required bool isRefresh, required int currentPage, required int departmentId, required int blockId, required String fullname}) async {
    List<Account> accountList = await ApiService().getAccountByFullname(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, fullname: fullname);

    notifyListeners();

    return accountList;
  }

}