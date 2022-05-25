
import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/management_commission.dart';
import 'package:login_sample/models/personal_commission.dart';
import 'package:login_sample/services/api_service.dart';

class CommissionViewModel with ChangeNotifier{
  Future<bool> updatePersonalCommission(PersonalCommission personalCommission) async {
    bool result = await ApiService().updatePersonalCommission(personalCommission);

    notifyListeners();

    return result;
  }

  Future<bool> updateManagementCommission(ManagementCommission managementCommission) async {
    bool result = await ApiService().updateManagementCommission(managementCommission);

    notifyListeners();

    return result;
  }

  Future<bool> createNewPersonalCommission(PersonalCommission personalCommission) async {
    bool result = await ApiService().createNewPersonalCommission(personalCommission);

    notifyListeners();

    return result;
  }

  Future<bool> deleteAPersonalPermission(int personalPermissionId) async {
    bool result = await ApiService().deleteAPersonalPermission(personalPermissionId);

    notifyListeners();

    return result;
  }
}