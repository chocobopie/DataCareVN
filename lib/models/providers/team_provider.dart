import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/team.dart';


class TeamProvider with ChangeNotifier{
  late Team _team;

  Team get department => _team;

  void setAccount(Team team){
    _team = team;
    notifyListeners();
  }
}