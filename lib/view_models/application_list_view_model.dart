
import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/application.dart';
import 'package:login_sample/services/api_service.dart';

class ApplicationListViewModel with ChangeNotifier{
  Future<List<Application>?> getSelfApplicationList({required bool isRefresh, required int currentPage, required int accountId, DateTime? fromCreatedDate, DateTime? toCreatedDate, DateTime? fromAssignedDate, DateTime? toAssignedDate, int? applicationStatusId, int? periodOfDayId, int? limit}) async {
    List<Application>? result = await ApiService().getSelfApplicationList(isRefresh: isRefresh, currentPage: currentPage, accountId: accountId, fromCreatedDate: fromCreatedDate, toCreatedDate: toCreatedDate, fromAssignedDate: fromAssignedDate, toAssignedDate: toAssignedDate, applicationStatusId: applicationStatusId, periodOfDayId: periodOfDayId, limit: limit);

    notifyListeners();

    return result;
  }

  Future<List<Application>?> getOtherApplicationList({required bool isRefresh, required int currentPage, required int accountId, DateTime? fromCreatedDate, DateTime? toCreatedDate, DateTime? fromAssignedDate, DateTime? toAssignedDate, int? applicationStatusId, int? periodOfDayId, int? limit}) async {
    List<Application>? result = await ApiService().getOtherApplicationList(isRefresh: isRefresh, currentPage: currentPage, accountId: accountId, fromCreatedDate: fromCreatedDate, toCreatedDate: toCreatedDate, fromAssignedDate: fromAssignedDate, toAssignedDate: toAssignedDate, applicationStatusId: applicationStatusId, periodOfDayId: periodOfDayId, limit: limit);

    notifyListeners();

    return result;
  }
}