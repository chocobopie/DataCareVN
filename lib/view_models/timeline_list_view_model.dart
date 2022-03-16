
import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/timeline.dart';
import 'package:login_sample/services/api_service.dart';

class TimelineListViewModel with ChangeNotifier{

  Future<List<Timeline>> getTimelineByDealId({ required bool isRefresh ,required dealId, required currentPage}) async {
    List<Timeline> timeLineList = await ApiService().getTimelineByDealId(isRefresh: isRefresh, dealId: dealId, currentPage: currentPage);

    notifyListeners();
    
    return timeLineList;
  }

}