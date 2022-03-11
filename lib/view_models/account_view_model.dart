import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/services/api_service.dart';

class AccountViewModel with ChangeNotifier{

  Future<Account> getAccountFullnameById({required accountId}) async {

    Account account = await ApiService().getAccountById(accountId);

    notifyListeners();

    return account;
  }


}
