import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/application_type.dart';
import 'package:login_sample/services/api_service.dart';

class ApplicationTypeListViewModel with ChangeNotifier{
  Future<List<ApplicationType>> getApplicationType() async {
    List<ApplicationType> result =  await ApiService().getApplicationType();

    notifyListeners();

    return result;
  }
}