
import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/application_status.dart';
import 'package:login_sample/services/api_service.dart';

class ApplicationStatusListViewModel with ChangeNotifier{
  Future<List<ApplicationStatus>> getApplicationsStatus() async {
    List<ApplicationStatus> result = await ApiService().getApplicationsStatus();

    notifyListeners();

    return result;
  }
}