import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/account.dart';

class AccountProvider with ChangeNotifier{
  late Account _account = Account();

  Account get account => _account;

  void setAccount(Account account){
    _account = account;
    notifyListeners();
  }
}