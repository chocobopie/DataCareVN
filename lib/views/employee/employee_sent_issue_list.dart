import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/fromDateToDate.dart';
import 'package:login_sample/models/issue.dart';
import 'package:login_sample/view_models/account_list_view_model.dart';
import 'package:login_sample/view_models/issue_list_view_model.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_date_filter.dart';
import 'package:login_sample/views/sale_employee/sale_emp_filter.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/employee/employee_issue_add_new.dart';
import 'package:login_sample/views/employee/employee_issue_detail.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EmployeeSentIssueList extends StatefulWidget {
  const EmployeeSentIssueList({Key? key}) : super(key: key);

  @override
  _EmployeeSentIssueListState createState() => _EmployeeSentIssueListState();
}

class _EmployeeSentIssueListState extends State<EmployeeSentIssueList> {

  late final List<Account> _employeeList = [];
  late final List<Issue> _issues = [];
  bool _isSearching = false;
  DateTime? _deadlineFromDate, _deadlineToDate, _createFromDate, _createToDate;
  late Account _currentAccount, _filterAccount = Account();
  int _currentPage = 0, _maxPage = 0;

  late String _fromDatetoDateDeadlineString = 'Hạn chót', _fromDateToDateCreateDateString = 'Ngày tạo vấn đề', _tagAccount = 'Tên nhân viên được giao';

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getAllIssue(isRefresh: true);
    _getAllEmployee();
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
      floatingActionButton:  Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const EmployeeIssueAddNew(),
                  )).then((value) => _onGoBack());
                },
                backgroundColor: mainBgColor,
                child: const Icon(Icons.plus_one),
              ),
            ),
          ),

          Card(
            child: _maxPage > 0 ? NumberPaginator(
                buttonSelectedBackgroundColor: mainBgColor,
                numberPages: _maxPage,
                initialPage: 0,
                onPageChange: (int index){
                  setState(() {
                    if(index >= _maxPage){
                      index = 0;
                      _currentPage = index;
                    }else{
                      _currentPage = index;
                    }
                    _issues.clear();
                  });
                  _getAllIssue(isRefresh: false);
                },
            ) : null,
          ),
        ],
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
            margin: const EdgeInsets.only(top: 90.0),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text('Lọc theo:', style: TextStyle(color: defaultFontColor),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    height: 40.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        CustomOutlinedButton(
                          title: _tagAccount,
                          radius: 10,
                          color: mainBgColor,
                          onPressed: () async {
                            final data = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SaleEmpFilter(saleForIssue: true),
                            ));
                            if(data != null){
                              _currentPage = _currentPage = 0;
                              _filterAccount = data;
                              setState(() {
                                _tagAccount = 'Nhân viên được giao: ${_filterAccount.fullname!}' ;
                                _issues.clear();
                              });
                              _getAllIssue(isRefresh: true);
                            }
                          },
                        ),
                        CustomOutlinedButton(
                            title: _fromDateToDateCreateDateString,
                            radius: 10,
                            color: mainBgColor,
                            onPressed: () async {
                              final data = await Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const SaleEmpDateFilter(),
                              ));
                              if(data != null){
                                FromDateToDate fromDateToDate = data;
                                _createFromDate = fromDateToDate.fromDate;
                                _createToDate = fromDateToDate.toDate;
                                setState(() {
                                  _currentPage = _currentPage = 0;
                                  _issues.clear();
                                  _fromDateToDateCreateDateString = 'Ngày tạo: ${fromDateToDate.fromDateString} → ${fromDateToDate.toDateString}';
                                });
                                _getAllIssue(isRefresh: true);
                              }
                            },
                        ),
                        CustomOutlinedButton(
                            title: _fromDatetoDateDeadlineString,
                            radius: 10,
                            color: mainBgColor,
                            onPressed: () async {
                              final data = await Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const SaleEmpDateFilter(),
                              ));
                              if(data != null){
                                FromDateToDate fromDateToDate2 = data;
                                _deadlineFromDate = fromDateToDate2.fromDate;
                                _deadlineToDate = fromDateToDate2.toDate;
                                setState(() {
                                  _currentPage = _currentPage = 0;
                                  _issues.clear();
                                  _fromDatetoDateDeadlineString = 'Hạn chót: ${fromDateToDate2.fromDateString} → ${fromDateToDate2.toDateString}';
                                });
                                _getAllIssue(isRefresh: true);
                              }
                            },
                        ),
                        IconButton(
                            onPressed: (){
                              setState(() {
                                _issues.clear();
                                _fromDatetoDateDeadlineString = 'Hạn chót';
                                _fromDateToDateCreateDateString = 'Ngày tạo vấn đề';
                                _tagAccount = 'Tên nhân viên được giao';
                                _currentPage = _currentPage = 0;
                              });
                              _filterAccount = Account();
                              _deadlineFromDate = null;
                              _deadlineToDate = null;
                              _createFromDate = null;
                              _createToDate = null;
                              _getAllIssue(isRefresh: true);
                            },
                            icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Card dưới
          _maxPage >= 0 ? Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.22),
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
                margin: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.01),
                child: _issues.isNotEmpty ? SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: true,
                  onRefresh: () {
                    setState(() {
                      _issues.clear();
                    });
                    _getAllIssue(isRefresh: false);

                    if(_issues.isNotEmpty){
                      _refreshController.loadComplete();
                    }else{
                      _refreshController.loadFailed();
                    }
                  },
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        final issue = _issues[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeIssueDetail(issue: issue, viewOnly: false,)
                              )).then((value) => _onGoBack());
                            },
                            child: Card(
                              elevation: 10,
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
                                          const Text('Tiêu đề:'),
                                          const Spacer(),
                                          SizedBox(
                                              height: 20.0, width: MediaQuery.of(context).size.width * 0.5,
                                              child: Align(alignment: Alignment.bottomRight,child: Text(issue.title, overflow: TextOverflow.ellipsis,softWrap: false,))),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Text('Nhân viên được giao:'),
                                          const Spacer(),
                                          Text(_getEmployeeName(issue.taggedAccountId)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Text('Ngày tạo vấn đề:'),
                                          const Spacer(),
                                          Text(DateFormat('dd-MM-yyyy').format(issue.createdDate!)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Text('Hạn chót:'),
                                          const Spacer(),
                                          Text(DateFormat('dd-MM-yyyy').format(issue.deadlineDate)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: _issues.length,
                  ),
                ) : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ) : const Center(child: Text('Không có dữ liệu')),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: !_isSearching
                  ? const Text("Danh sách vấn đề đã gửi",style: TextStyle(color: Colors.blueGrey),)
                  : const TextField(
                style: TextStyle(color: Colors.blueGrey,),
                showCursor: true,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  icon: Icon(Icons.search,
                    color: Colors.blueGrey,
                  ),
                  hintText: "Search name, email",
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              actions: <Widget>[
                _isSearching ? IconButton(
                  icon: const Icon(
                    Icons.cancel,
                  ),
                  onPressed: (){
                    setState(() {
                      _isSearching = false;
                    });
                  },
                ) : IconButton(
                  icon: const Icon(
                    Icons.search,
                  ),
                  onPressed: (){
                    setState(() {
                      _isSearching = true;
                    });
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getEmployeeName(int accountId){
    String name = '';
    for(int i = 0; i < _employeeList.length; i++){
      if(accountId == _employeeList[i].accountId){
        name = _employeeList[i].fullname!;
      }
    }
    return name;
  }
  
  void _onGoBack(){
    _getAllIssue(isRefresh: false);
  }
  
  void _getAllEmployee() async {
    List<Account> accountList = await AccountListViewModel().getAllAccount(isRefresh: true, currentPage: 0, accountId: 0, limit: 100000);

    setState(() {
      _employeeList.addAll(accountList);
    });

  }

  void _getAllIssue({required bool isRefresh}) async {

    List<Issue>? issueList = await IssueListViewModel().
    getAllIssue(
        isRefresh: isRefresh, currentPage: _currentPage,
        ownerId: _currentAccount.accountId!, taggedAccountId: _filterAccount.accountId,
        fromCreateDate: _createFromDate, toCreateDate: _createToDate,
        fromDeadlineDate: _deadlineFromDate, toDeadlineDate: _deadlineToDate,
    );

    if(issueList!.isNotEmpty){
      setState(() {
        _issues.clear();
        _issues.addAll(issueList);
        _maxPage = _issues[0].maxPage!;
      });
    }else{
      setState(() {
        _maxPage = -1;
      });
    }
  }
}