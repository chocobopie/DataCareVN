import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/services/api_service.dart';

class DepartmentListViewModel with ChangeNotifier{

  Future<List<Department>> getAllDepartment() async {
    List<Department> departmentList = await ApiService().getAllDepartment();

    notifyListeners();

    return departmentList;
  }

}