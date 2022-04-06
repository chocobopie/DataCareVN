import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/services/api_service.dart';

class DepartmentViewModel with ChangeNotifier{
  Future<Department?> createNewDepartment(Department department) async {
    Department? result = await ApiService().createNewDepartment(department);

    notifyListeners();

    return result;
  }
}