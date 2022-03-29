import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/issue.dart';
import 'package:login_sample/services/api_service.dart';

class IssueListViewModel with ChangeNotifier{
  Future<List<Issue>?> getAllIssue() async {
    List<Issue>? issueList = await ApiService().getAllIssue();

    notifyListeners();

    return issueList;
  }
}