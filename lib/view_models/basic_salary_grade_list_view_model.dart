import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/basic_salary_by_grade.dart';
import 'package:login_sample/services/api_service.dart';

class BasicSalaryGradeListViewModel with ChangeNotifier{
  Future<List<BasicSalaryByGrade>?> getListBasicSalaryByGrade() async {
    List<BasicSalaryByGrade>? result = await ApiService().getListBasicSalaryByGrade();

    notifyListeners();

    return result;
  }
}