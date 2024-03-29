import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/account_list_view_model.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SaleEmpFilter extends StatefulWidget {
  const SaleEmpFilter({Key? key, this.salesForContact, this.salesForDeal, this.saleForIssue, this.taggedByAnother}) : super(key: key);

  final bool? salesForContact;
  final bool? salesForDeal;
  final bool? saleForIssue;
  final bool? taggedByAnother;

  @override
  State<SaleEmpFilter> createState() => _SaleEmpFilterState();
}

class _SaleEmpFilterState extends State<SaleEmpFilter> {

  int _currentPage = 0, _maxPages = 0;
  late final List<Account> _salesEmployees = [];
  late Account _currentAccount;

  final RefreshController _refreshController = RefreshController();
  final TextEditingController _searchEmployeeName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _filterSaleEmployee(isRefresh: true);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _searchEmployeeName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Card(
        elevation: 10.0,
        child: _maxPages > 0 ? NumberPaginator(
          numberPages: _maxPages,
          buttonSelectedBackgroundColor: mainBgColor,
          onPageChange: (int index) {
            setState(() {
              _currentPage = index;
              _salesEmployees.clear();
            });
            _filterSaleEmployee(isRefresh: false);
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
              height: MediaQuery.of(context).size.height * 0.3
          ),
          Card(
              elevation: 20.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              margin: const EdgeInsets.only(top: 100.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 40.0, top: 10.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                        style: const TextStyle(color: Colors.blueGrey,),
                        controller: _searchEmployeeName,
                        showCursor: true,
                        cursorColor: Colors.black,
                        onSubmitted: (value){
                          if(_salesEmployees.isNotEmpty){
                            _salesEmployees.clear();
                          }
                          _currentPage = 0;
                          // _getAccountsByFullname(isRefresh: true, currentPage: _currentPage, accountId: _currentAccount.accountId!, fullname: _searchEmployeeName.text);
                          _filterSaleEmployee(isRefresh: true);
                        },
                        decoration: InputDecoration(
                          icon: const Icon(Icons.search,
                            color: Colors.blueGrey,
                          ),
                          suffixIcon: _searchEmployeeName.text.isNotEmpty ? IconButton(
                            onPressed: (){
                              setState(() {
                                _salesEmployees.clear();
                              });
                              _refreshController.resetNoData();
                              _searchEmployeeName.clear();
                              _filterSaleEmployee(isRefresh: true);
                            },
                            icon: const Icon(Icons.clear),
                          ) : null,
                          hintText: "Tìm theo tên của nhân viên",
                          hintStyle: const TextStyle(
                            color: Colors.blueGrey,
                          ),
                        ),
                    ),
                  ],
                ),
              ),
          ),
          _maxPages >= 0 ? Padding(
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
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    onRefresh: () async{
                      setState(() {
                        _salesEmployees.clear();
                      });
                      _refreshController.resetNoData();
                      // if(_searchEmployeeName.text.isNotEmpty){
                      //   _getAccountsByFullname(isRefresh: false, currentPage: _currentPage, accountId: _currentAccount.accountId!, fullname: _searchEmployeeName.text);
                      // }else{
                      //   _filterSaleEmployee(isRefresh: false);
                      // }
                      _filterSaleEmployee(isRefresh: false);

                      if(_salesEmployees.isNotEmpty){
                        _refreshController.refreshCompleted();
                      }else{
                        _refreshController.refreshFailed();
                      }
                    },
                    // onLoading: () async{
                    //   if(_currentPage < _maxPages){
                    //     setState(() {
                    //       _currentPage++;
                    //     });
                    //     print('Current page: $_currentPage');
                    //     if(_searchEmployeeName.text.isNotEmpty){
                    //       _getAccountsByFullname(isRefresh: false, currentPage: _currentPage, departmentId:  _currentAccount.departmentId!, blockId:  _currentAccount.blockId!, fullname: _searchEmployeeName.text);
                    //     }else{
                    //       _filterSaleEmployee(isRefresh: false);
                    //     }
                    //   }
                    //
                    //   if(_salesEmployees.isNotEmpty){
                    //     _refreshController.loadComplete();
                    //   }else{
                    //     _refreshController.loadFailed();
                    //   }
                    // },
                    child: _salesEmployees.isNotEmpty ? ListView.builder(
                        itemBuilder: (context, index) {
                          final account = _salesEmployees[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                            child: InkWell(
                              onTap: (){
                                Navigator.pop(context, account);
                              },
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
                                            const Text('Tên nhân viên:'),
                                            const Spacer(),
                                            Text(account.fullname!),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Text('Chức vụ:'),
                                            const Spacer(),
                                            Text(rolesNames[account.roleId!]),
                                          ],
                                        ),
                                      ),

                                      if(account.teamId != null) Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Text('Nhóm:'),
                                            const Spacer(),
                                            Text(getTeamName(account.teamId!, account.departmentId)),
                                          ],
                                        ),
                                      ),

                                      if(account.phoneNumber != null) Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Text('SĐT:'),
                                            const Spacer(),
                                            Text(account.phoneNumber!),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Text('Email:'),
                                            const Spacer(),
                                            Text(account.email!),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: _salesEmployees.length
                    ) : const Center(child: CircularProgressIndicator())
                  )
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
              title: const Text(
                "Lọc theo nhân viên",
                style: TextStyle(
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

  void _filterSaleEmployee({required bool isRefresh}){
    _salesEmployees.clear();
    if(widget.salesForContact == true) _getAllSalesForContact(isRefresh: isRefresh, currentPage: _currentPage, accountId: _currentAccount.accountId!, fullname: _searchEmployeeName.text);
    if(widget.saleForIssue == true) _getAllSalesForIssue(isRefresh: isRefresh, currentPage: _currentPage, accountId: _currentAccount.accountId!, fullname: _searchEmployeeName.text);
    if(widget.salesForDeal == true) _getAllSalesForDeal(isRefresh: isRefresh, currentPage: _currentPage, accountId: _currentAccount.accountId!, fullname: _searchEmployeeName.text);
    if(widget.taggedByAnother == true) _getAllSalesByTaggedAnother(isRefresh: isRefresh, currentPage: _currentPage, accountId: _currentAccount.accountId!, fullname: _searchEmployeeName.text);
  }

  void _getAllSalesForContact({required bool isRefresh, required int currentPage, required int accountId, String? fullname, int? blockId, int? departmentId, int? teamId, int? limit}) async {
    List<Account>? accountList = await AccountListViewModel().getAllSalesForContact(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId, accountId: accountId, fullname: fullname );

    if(accountList!.isNotEmpty){
      setState(() {
        _salesEmployees.addAll(accountList);
        _maxPages = _salesEmployees[0].maxPage!;
      });
    }else{
      setState(() {
        _maxPages = -1;
      });
    }
  }

  void _getAllSalesForIssue({required bool isRefresh, required int currentPage, required int accountId, String? fullname, int? blockId, int? departmentId, int? teamId, int? limit}) async {
    List<Account>? accountList = await AccountListViewModel().getAllSalesForIssue(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId, accountId: accountId, fullname: fullname);

    if(accountList!.isNotEmpty){
      setState(() {
        _salesEmployees.addAll(accountList);
        _maxPages = _salesEmployees[0].maxPage!;
      });
    }else{
      setState(() {
        _maxPages = -1;
      });
    }
  }

  void _getAllSalesForDeal({required bool isRefresh, required int currentPage, required int accountId, String? fullname, int? blockId, int? departmentId, int? teamId, int? limit}) async {
    List<Account>? accountList = await AccountListViewModel().getAllSalesForDeal(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId, accountId: accountId, fullname: fullname);

    if(accountList!.isNotEmpty){
      setState(() {
        _salesEmployees.addAll(accountList);
        _maxPages = _salesEmployees[0].maxPage!;
      });
    }else{
      setState(() {
        _maxPages = -1;
      });
    }
  }

  void _getAllSalesByTaggedAnother({required bool isRefresh, required int currentPage, required int accountId, String? fullname, int? blockId, int? departmentId, int? teamId, int? limit}) async {
    List<Account>? accountList = await AccountListViewModel().getAllSalesTaggedByAnother(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId, accountId: accountId, fullname: fullname);

    if(accountList!.isNotEmpty){
      setState(() {
        _salesEmployees.addAll(accountList);
        _maxPages = _salesEmployees[0].maxPage!;
      });
    }else{
      setState(() {
        _maxPages = -1;
      });
    }
  }

  // void _getAccountsByFullname({required bool isRefresh, required int currentPage, required int accountId, required String fullname}) async {
  //   List<Account>? accountList = await AccountListViewModel().getAccountsByFullname(isRefresh: isRefresh, currentPage: currentPage, accountId: accountId, fullname: fullname);
  //
  //   if(accountList != null){
  //     setState(() {
  //       _salesEmployees.addAll(accountList);
  //       _maxPages = _salesEmployees[0].maxPage!;
  //     });
  //   }else{
  //     _refreshController.loadNoData();
  //   }
  // }

}
