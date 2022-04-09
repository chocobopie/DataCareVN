import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/issue.dart';
import 'package:login_sample/services/api_service.dart';

class IssueListViewModel with ChangeNotifier{
  Future<List<Issue>?> getAllIssue(
      {required bool isRefresh, required currentPage ,int? issueId, int? dealId,
        int? ownerId, int? taggedAccountId,
        DateTime? fromCreateDate, DateTime? toCreateDate,
        DateTime? fromDeadlineDate, DateTime? toDeadlineDate,
        int? limit}
      ) async {

    List<Issue>? issueList = await ApiService().getAllIssue(
        isRefresh: isRefresh, currentPage: currentPage,
        issueId: issueId, dealId: dealId, ownerId: ownerId,
        taggedAccountId: taggedAccountId,
        fromCreateDate: fromCreateDate, toCreateDate: toCreateDate,
        fromDeadlineDate: fromDeadlineDate, toDeadlineDate: toDeadlineDate,
        limit: limit);

    notifyListeners();

    return issueList;
  }

}