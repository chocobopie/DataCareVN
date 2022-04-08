import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/issue.dart';
import 'package:login_sample/services/api_service.dart';

class IssueViewModel with ChangeNotifier{
  Future<Issue?> createNewIssue(Issue issue) async {
    Issue? result = await ApiService().createNewIssue(issue);

    notifyListeners();

    return result;
  }

  Future<Issue?> updateAIssue(Issue issue) async {
    Issue? result = await ApiService().updateAIssue(issue);

    notifyListeners();

    return result;
  }

  Future<bool> deleteIssue(int issueId) async {
    bool result = await ApiService().deleteIssue(issueId);

    notifyListeners();

    return result;
  }
}
