
import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/services/api_service.dart';

class TeamListViewModel with ChangeNotifier{

  Future<List<Team>> getAllTeams() async {
    List<Team> teamList = await ApiService().getAllTeam();

    notifyListeners();

    return teamList;
  }

}