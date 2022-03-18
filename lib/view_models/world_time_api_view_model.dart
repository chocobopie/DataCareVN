
import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/WorldTimeAPI.dart';
import 'package:login_sample/services/api_service.dart';

class WorldTimeApiViewModel with ChangeNotifier{

  Future<WorldTimeApi> getCorrectTime() async {
    WorldTimeApi correctTime = await ApiService().getCorrectTime();

    notifyListeners();

    return correctTime;
  }

}