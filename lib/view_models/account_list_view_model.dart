import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/services/api_service.dart';

class AccountListViewModel with ChangeNotifier{

  Future<List<Account>?> getAllSalesForContact({required bool isRefresh, required int currentPage, required int blockId, required int departmentId, int? teamId, int? limit}) async {
    List<Account>? accountList = await ApiService().getAllSalesForContact(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId, limit: limit);

    notifyListeners();

    return accountList;
  }

  Future<List<Account>?> getAccountsByFullname({required bool isRefresh, required int currentPage, required int accountId, required String fullname}) async {
    List<Account>? accountList = await ApiService().getAccountByFullname(isRefresh: isRefresh, currentPage: currentPage, accountId: accountId ,fullname: fullname);

    notifyListeners();

    return accountList;
  }

  Future<List<Account>> getAllAccount({required bool isRefresh, required currentPage, required int accountId, int? blockId, int? departmentId, int? teamId, int? roleId, int? limit, String? search}) async {
    List<Account> accountList = await ApiService().getAllAccounts(isRefresh: isRefresh, currentPage: currentPage, accountId: accountId, blockId: blockId, departmentId: departmentId, teamId: teamId, roleId: roleId, limit: limit, search: search);

    notifyListeners();

    return accountList;
  }

}