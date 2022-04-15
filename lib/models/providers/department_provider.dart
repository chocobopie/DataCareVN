import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/department.dart';

class DepartmentProvider with ChangeNotifier{
  late Department _department;

  Department get department => _department;

  void setAccount(Department department){
    _department = department;
    notifyListeners();
  }
}