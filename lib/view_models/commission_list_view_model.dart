import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/ManagementCommission.dart';
import 'package:login_sample/models/PersonalCommission.dart';
import 'package:login_sample/services/api_service.dart';

class CommissionListViewModel with ChangeNotifier{
  Future<List<PersonalCommission>?> getListPersonalCommission() async {
    List<PersonalCommission>? result = await ApiService().getListPersonalCommission();

    notifyListeners();

    return result;
  }

  Future<List<ManagementCommission>?> getListManagementCommission() async {
    List<ManagementCommission>? result = await ApiService().getListManagementCommission();

    notifyListeners();

    return result;
  }
}