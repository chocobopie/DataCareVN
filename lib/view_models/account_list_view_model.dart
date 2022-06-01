import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/services/api_service.dart';

class AccountListViewModel with ChangeNotifier{

  Future<List<Account>?> getAllSalesForContact({required bool isRefresh, required int currentPage, required int accountId, String? fullname, int? blockId, int? departmentId, int? teamId, int? limit}) async {
    List<Account>? accountList = await ApiService().getAllSalesForContact(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId, limit: limit, accountId: accountId, fullname: fullname);

    notifyListeners();

    return accountList;
  }

  Future<List<Account>?> getAllSalesForIssue({required bool isRefresh, required int currentPage, required int accountId, String? fullname, int? blockId, int? departmentId, int? teamId, int? limit}) async {
    List<Account>? accountList = await ApiService().getAllSalesForIssue(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId, limit: limit, accountId: accountId, fullname: fullname);

    notifyListeners();

    return accountList;
  }

  Future<List<Account>?> getAllSalesForDeal({required bool isRefresh, required int currentPage, required int accountId, String? fullname, int? blockId, int? departmentId, int? teamId, int? limit}) async {
    List<Account>? accountList = await ApiService().getAllSalesForDeal(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId, limit: limit, accountId: accountId, fullname: fullname);

    notifyListeners();

    return accountList;
  }

  Future<List<Account>?> getAllSalesTaggedByAnother({required bool isRefresh, required int currentPage, required int accountId, String? fullname, int? blockId, int? departmentId, int? teamId, int? limit}) async{
    List<Account>? accountList = await ApiService().getAllSalesTaggedByAnother(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId, limit: limit, accountId: accountId, fullname: fullname);

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

  Future<List<Account>> getAllPromotedAccounts({required bool isRefresh, required currentPage, int? blockId, int? departmentId, int? teamId, int? roleId, int? limit, String? search}) async {
    List<Account> accountList = await ApiService().getAllPromotedAccounts(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId, roleId: roleId, limit: limit, search: search);

    notifyListeners();

    return accountList;
  }

  Future<List<Account>> getAllDemotedAccounts({required bool isRefresh, required currentPage, int? blockId, int? departmentId, int? teamId, int? roleId, int? limit, String? search}) async {
    List<Account> accountList = await ApiService().getAllDemotedAccounts(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId, roleId: roleId, limit: limit, search: search);

    notifyListeners();

    return accountList;
  }

}