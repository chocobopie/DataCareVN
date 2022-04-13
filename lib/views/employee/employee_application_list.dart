import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/application.dart';
import 'package:login_sample/models/fromDateToDate.dart';
import 'package:login_sample/models/sort_item.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/view_models/application_list_view_model.dart';
import 'package:login_sample/views/hr_manager/hr_manager_attendance_report_list.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_date_filter.dart';
import 'package:login_sample/widgets/CustomDropDownFormField2Filter.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EmployeeApplicationList extends StatefulWidget {
  const EmployeeApplicationList({Key? key}) : super(key: key);

  @override
  _EmployeeApplicationListState createState() => _EmployeeApplicationListState();
}

class _EmployeeApplicationListState extends State<EmployeeApplicationList> {

  Account? _currentAccount;
  String _fromCreatedDateToDateString = 'Ngày gửi đơn', _fromAssignedDateToDateString = 'Ngày phép';
  int? _applicationStatusId, _periodOfDayId;
  DateTime? _fromCreatedDate, _toCreatedDate, _fromAssignedDate, _toAssignedDate;
  int _currentPage = 0, _maxPages = 0;

  final RefreshController _refreshController = RefreshController();

  final List<Application> _applications = [];

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getSelfApplicationList(isRefresh: true);
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
              _applications.clear();
              if(index >= _maxPages){
                index = 0;
                _currentPage = index;
              }else{
                _currentPage = index;
              }
            });
            _getSelfApplicationList(isRefresh: false);
          },
        ) : null ,
      ),
      body: Stack(
        children: <Widget>[
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomCenter,
                      colors: [mainBgColor, mainBgColor])),
              height: MediaQuery.of(context).size.height * 0.3
          ),
          Card(
            elevation: 20.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            margin: const EdgeInsets.only(top: 90),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 10.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text('Lọc theo:', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                        ),
                        const SizedBox(width: 5.0,),
                        CustomOutlinedButton(
                          title: _fromCreatedDateToDateString,
                          radius: 10.0,
                          color: mainBgColor,
                          onPressed: () async {
                            final data = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SaleEmpDateFilter(),
                            ));
                            if(data != null){
                              FromDateToDate fromDateToDate = data;
                              setState(() {
                                _fromCreatedDate = fromDateToDate.fromDate;
                                _toCreatedDate = fromDateToDate.toDate;
                                _fromCreatedDateToDateString = 'Ngày gửi đơn: ${fromDateToDate.fromDateString} → ${fromDateToDate.toDateString}';
                                _applications.clear();
                                _maxPages = 0;
                              });
                              _getSelfApplicationList(isRefresh: true);
                            }
                          },
                        ),
                        CustomOutlinedButton(
                          title: _fromAssignedDateToDateString,
                          radius: 10.0,
                          color: mainBgColor,
                          onPressed: () async {
                            final data = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SaleEmpDateFilter(),
                            ));
                            if(data != null){
                              FromDateToDate fromDateToDate = data;
                              setState(() {
                                _fromAssignedDate = fromDateToDate.fromDate;
                                _toAssignedDate = fromDateToDate.toDate;
                                _fromAssignedDateToDateString = 'Ngày phép: ${fromDateToDate.fromDateString} → ${fromDateToDate.toDateString}';
                                _applications.clear();
                                _maxPages = 0;
                              });
                              _getSelfApplicationList(isRefresh: true);
                            }
                          },
                        ),
                        SizedBox(
                          width: 120.0,
                          child: CustomDropdownFormField2Filter(
                            borderColor: mainBgColor,
                            value: _periodOfDayId == null ? null : periodOfDayNames[_periodOfDayId!],
                            label: 'Buổi xin phép',
                            items: periodOfDayNames,
                            onChanged: (value){
                              for(int i = 0; i < periodOfDay.length; i++){
                                if(value.toString() == periodOfDay[i].name){
                                  _periodOfDayId = periodOfDay[i].periodOfDayId;
                                }
                              }
                              setState(() {
                                _applications.clear();
                                _maxPages = 0;
                              });
                              _getSelfApplicationList(isRefresh: true);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100.0,
                          child: CustomDropdownFormField2Filter(
                            borderColor: mainBgColor,
                            value: _applicationStatusId == null ? null : applicationStatusesNames[_applicationStatusId!],
                            label: 'Trạng thái',
                            items: applicationStatusesNames,
                            onChanged: (value){
                              for(int i = 0; i < applicationStatuses.length; i++){
                                if(value.toString() == applicationStatuses[i].name){
                                  _applicationStatusId = applicationStatuses[i].applicationStatusId;
                                }
                              }
                              print(_applicationStatusId);
                              setState(() {
                                _applications.clear();
                                _maxPages = 0;
                              });
                              _getSelfApplicationList(isRefresh: true);
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: (){
                              setState(() {
                                _fromCreatedDate = null;
                                _toCreatedDate = null;
                                _fromAssignedDate = null;
                                _toAssignedDate = null;
                                _fromCreatedDateToDateString = 'Ngày gửi đơn';
                                _fromAssignedDateToDateString = 'Ngày phép';
                                _applicationStatusId = null;
                                _periodOfDayId = null;
                                _applications.clear();
                                _maxPages = 0;
                              });
                              _getSelfApplicationList(isRefresh: true);
                            },
                            icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                        ),
                      ],
                    ),
                  )
                ],
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                elevation: 100.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                child: _applications.isNotEmpty ? SmartRefresher(
                  onRefresh: () {
                    setState(() {
                      _applications.clear();
                    });

                    _getSelfApplicationList(isRefresh: false);

                    if(_applications.isNotEmpty){
                      _refreshController.refreshCompleted();
                    }else{
                      _refreshController.refreshFailed();
                    }
                  },
                  controller: _refreshController,
                  enablePullUp: true,
                  child: ListView.builder(
                      itemCount: _applications.length,
                      itemBuilder: (context, index){
                        final _application = _applications[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
                          child: Card(
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        const Text('Ngày gửi đơn:'),
                                        const Spacer(),
                                        Text(DateFormat('dd-MM-yyyy').format(_application.createdDate!), style: const TextStyle(fontSize: 16.0),),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(_application.applicationTypeId == 1 ? 'Ngày xin đi trễ:' : 'Ngày xin nghỉ phép:'),
                                        const Spacer(),
                                        Text(DateFormat('dd-MM-yyyy').format(_application.assignedDate), style: const TextStyle(fontSize: 16.0),),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(_application.applicationTypeId == 1 ? 'Xin đi trễ buổi:' : 'Xin nghỉ phép buổi:'),
                                        const Spacer(),
                                        Text(periodOfDayNames[_application.periodOfDayId!], style: const TextStyle(fontSize: 16.0),),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        const Text('Trạng thái:'),
                                        const Spacer(),
                                        Text(applicationStatusesNames[_application.applicationStatusId!],
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              color: _application.applicationStatusId != 2 ? _application.applicationStatusId != 1 ? Colors.green : Colors.blue : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                ) : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              // Add AppBar here only
              iconTheme: const IconThemeData(color: Colors.blueGrey),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Danh sách đơn xin đi trễ",
                style: TextStyle(
                    letterSpacing: 0.0,
                    fontSize: 20.0,
                    color: Colors.blueGrey
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
 void _getSelfApplicationList({required bool isRefresh}) async {

    List<Application>? result = await ApplicationListViewModel().getSelfApplicationList(isRefresh: isRefresh, currentPage: _currentPage, accountId: _currentAccount!.accountId!,
        fromCreatedDate: _fromCreatedDate, toCreatedDate: _toCreatedDate, fromAssignedDate: _fromAssignedDate, toAssignedDate: _toAssignedDate,
        applicationStatusId: _applicationStatusId, periodOfDayId: _periodOfDayId
    );

    _applications.clear();
    if(result != null){
      setState(() {
        _applications.addAll(result);
        _maxPages = _applications[0].maxPage!;
      });
      print(_maxPages);
      print(_currentPage);
    }else{
       _refreshController.loadNoData();
    }
 }
}