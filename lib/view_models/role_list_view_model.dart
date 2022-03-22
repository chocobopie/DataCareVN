import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/role.dart';
import 'package:login_sample/services/api_service.dart';

class RoleListViewModel with ChangeNotifier{
  Future<List<Role>> getAllRole() async {
    List<Role> listRole = await ApiService().getAllRoles();

    notifyListeners();
    
    return listRole;
  }
}