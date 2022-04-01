import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/services/api_service.dart';

class AccountListViewModel with ChangeNotifier{

  Future<List<Account>> getAllSalesEmployeesByBlockIdDepartmentIdOrTeamId({required bool isRefresh, required int currentPage, required int blockId, required int departmentId, int? teamId, int? limit}) async {
    List<Account> accountList = await ApiService().getAllAccountByBlockIdDepartmentIdOrTeamId(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId, limit: limit);

    notifyListeners();

    return accountList;
  }

  Future<List<Account>> getAccountsByFullname({required bool isRefresh, required int currentPage, required int departmentId, required int blockId, required String fullname}) async {
    List<Account> accountList = await ApiService().getAccountByFullname(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, fullname: fullname);

    notifyListeners();

    return accountList;
  }

  Future<List<Account>> getAllAccount({required bool isRefresh, required currentPage, required int accountId, int? blockId, int? departmentId, int? teamId, int? roleId, int? limit}) async {
    List<Account> accountList = await ApiService().getAllAccounts(isRefresh: isRefresh, currentPage: currentPage, accountId: accountId, blockId: blockId, departmentId: departmentId, teamId: teamId, roleId: roleId, limit: limit);

    notifyListeners();

    return accountList;
  }

}