import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/change_password.dart';
import 'package:login_sample/services/api_service.dart';

class ChangePasswordViewModel with ChangeNotifier{

  Future<bool> changePassword(ChangePassword changePassword) async {
   bool result = await ApiService().changePassword(changePassword);

   notifyListeners();

   return result;
  }

}