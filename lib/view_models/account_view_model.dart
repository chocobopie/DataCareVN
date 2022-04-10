import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/services/api_service.dart';

class AccountViewModel with ChangeNotifier{

  Future<Account> getAccountFullnameById({required accountId}) async {
    Account account = await ApiService().getAccountById(accountId);

    notifyListeners();

    return account;
  }

  Future<Account> getAccountByAccountId({required accountId}) async {
    Account account = await ApiService().getAccountById(accountId);

    notifyListeners();

    return account;
  }

  Future<Account?> updateAnAccount(Account account) async {
    Account? accountTemp = await ApiService().updateAnAccount(account);

    notifyListeners();

    return accountTemp;
  }

  Future<bool> deleteAnAccount({required int accountId}) async {
    bool result = await ApiService().deleteAnAccount(accountId: accountId);

    notifyListeners();

    return result;
  }

}
