import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/services/api_service.dart';

class TeamViewMode with ChangeNotifier{

  Future<Team?> createNewTeam(Team team) async {
    Team? result = await ApiService().createNewTeam(team);

    notifyListeners();

    return result;
  }
}