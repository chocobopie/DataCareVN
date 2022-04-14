import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/application.dart';
import 'package:login_sample/services/api_service.dart';

class ApplicationViewModel with ChangeNotifier{
  Future<bool> sendApplication(Application application) async {
    bool result = await ApiService().sendApplication(application);

    notifyListeners();

    return result;
  }

  Future<bool> updateAnApplication({required Application application}) async {
    bool result = await ApiService().updateAnApplication(application: application);

    notifyListeners();

    return result;
  }
}