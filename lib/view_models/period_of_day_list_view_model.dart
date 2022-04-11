import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/period_of_day.dart';
import 'package:login_sample/services/api_service.dart';

class PeriodOfDayListViewModel with ChangeNotifier{
  Future<List<PeriodOfDay>> getPeriodOfDay() async {
    List<PeriodOfDay> result = await ApiService().getPeriodOfDay();

    notifyListeners();

    return result;
  }
}