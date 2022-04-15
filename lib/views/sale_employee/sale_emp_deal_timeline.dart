import 'package:flutter/material.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/models/timeline.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/timeline_list_view_model.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SaleEmpDealTimeline extends StatefulWidget {
  const SaleEmpDealTimeline({Key? key, required this.deal}) : super(key: key);

  final Deal deal;

  @override
  State<SaleEmpDealTimeline> createState() => _SaleEmpDealTimelineState();
}

class _SaleEmpDealTimelineState extends State<SaleEmpDealTimeline> {

  late final List<Timeline> _timeLines = [];
  late int _currentPage = 0, _maxPages = 0;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _getTimelineByDealId(isRefresh: true, dealId: widget.deal.dealId, currentPage: _currentPage);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Card(
        elevation: 10.0,
        child: _maxPages > 0 ? NumberPaginator(
          numberPages: _maxPages,
          initialPage: 0,
          buttonSelectedBackgroundColor: mainBgColor,
          onPageChange: (int index) {
            setState(() {
              if(index >= _maxPages){
                index = 0;
                _currentPage = index;
              }else{
                _currentPage = index;
              }
              _timeLines.clear();
            });
            _getTimelineByDealId(isRefresh: false, dealId: widget.deal.dealId, currentPage: _currentPage);
          },
        ) : null,
      ),
      body: Stack(
        children: <Widget>[
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomCenter,
                      colors: [mainBgColor, mainBgColor])),
              height: MediaQuery.of(context).size.height * 0.3),
          Card(
              elevation: 20.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              margin: const EdgeInsets.only(top: 100.0),
              child: Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: _timeLines.isNotEmpty ? SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    onRefresh: (){
                      setState(() {
                        _timeLines.clear();
                      });
                      _refreshController.resetNoData();

                      _getTimelineByDealId(isRefresh: false, dealId: widget.deal.dealId, currentPage: _currentPage);

                      if(_timeLines.isNotEmpty){
                        _refreshController.refreshCompleted();
                      }else{
                        _refreshController.refreshFailed();
                      }
                    },
                    onLoading: (){
                      if(_currentPage < _maxPages){
                        _currentPage++;
                      }

                      _getTimelineByDealId(isRefresh: false, dealId: widget.deal.dealId, currentPage: _currentPage);

                      if(_timeLines.isEmpty){
                        _refreshController.loadFailed();
                      }
                    },
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          final timeline = _timeLines[index];
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              elevation: 10.0,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                                      child: Row(
                                         children: <Widget>[
                                           Expanded(child: Text(timeline.line)),
                                         ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: _timeLines.length
                    ),
                  ) : const Center(child: CircularProgressIndicator())
              )),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(
                  color: Colors.blueGrey), // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text(
                widget.deal.title,
                style: const TextStyle(
                  letterSpacing: 0.0,
                  fontSize: 20.0,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getTimelineByDealId({ required bool isRefresh ,required dealId, required currentPage}) async {
    List<Timeline> timeLineList = await TimelineListViewModel().getTimelineByDealId(isRefresh: isRefresh, dealId: dealId, currentPage: currentPage);

    _timeLines.clear();
    if(timeLineList.isNotEmpty){
      setState(() {
        _timeLines.addAll(timeLineList);
        _maxPages = _timeLines[0].maxPage;
      });
    }else{
      _refreshController.loadNoData();
    }

  }
}
