
import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/register_account.dart';
import 'package:login_sample/services/api_service.dart';

class RegisterAccountViewModel with ChangeNotifier{

  Future<RegisterAccount?> registerAnAccount(RegisterAccount registerAccount) async {
    RegisterAccount? regisAccount = await ApiService().registerAnAccount(registerAccount);

    notifyListeners();

    return regisAccount;
  }

}