import 'dart:async';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/models/fromDateToDate.dart';
import 'package:login_sample/models/sort_item.dart';
import 'package:login_sample/view_models/account_list_view_model.dart';
import 'package:login_sample/view_models/contact_list_view_model.dart';
import 'package:login_sample/view_models/deal_list_view_model.dart';
import 'package:login_sample/view_models/deal_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_contact_filter.dart';
import 'package:login_sample/views/sale_employee/sale_emp_deal_add_new.dart';
import 'package:login_sample/views/sale_employee/sale_emp_deal_detail.dart';
import 'package:login_sample/views/sale_employee/sale_emp_date_filter.dart';
import 'package:login_sample/views/sale_employee/sale_emp_filter.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomDropdownButtonSortAscDes.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SaleEmpDealList extends StatefulWidget {
  const SaleEmpDealList({Key? key}) : super(key: key);

  @override
  _SaleEmpDealListState createState() => _SaleEmpDealListState();
}

class _SaleEmpDealListState extends State<SaleEmpDealList> {

  bool _isSearching = false, _isAsc = false;
  String _fullname = 'Người quản lý hợp đồng', _fromDateToDateString = 'Ngày chốt hợp đồng', _contactName = 'Tên khách hàng', _searchString = '';
  int _currentPage = 0, _maxPages = 0;

  final RefreshController _refreshController = RefreshController();

  late final List<Account> _saleEmployeeList = [];
  late final List<Contact> _contactList = [];
  late final List<Deal> _deals = [];
  late Account _currentAccount, _filterAccount = Account();

  Contact? _filterContact;
  DateTime? _fromDate, _toDate;

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getOverallInfo(_currentPage, _currentAccount);
    _getAllSaleEmployee(isRefresh: true);
    _getAllContactByAccountId(isRefresh: true, accountId: _currentAccount.accountId!, currentPage: _currentPage, limit: 1000000);
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const SaleEmpDealAddNew(),
                  )).then(_onGoBack);
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.plus_one),
              ),
            ),
          ),

          Card(
            elevation: 10.0,
            child: _maxPages > 0 ? NumberPaginator(
              numberPages: _maxPages,
              buttonSelectedBackgroundColor: mainBgColor,
              onPageChange: (int index) {
                setState(() {
                  _currentPage = index;
                  _deals.clear();
                });
                _getFilter(isRefresh: false);
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
            child: Padding(
              padding: const EdgeInsets.only( top: 10.0),
              child: Column(
                children: <Widget>[
                  const Text('Lọc theo', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                  const SizedBox(height: 10.0,),
                  SizedBox(
                    height: 40.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        //Lọc theo nhân viên
                        if(_currentAccount.roleId! == 3 || _currentAccount.roleId! == 4) CustomOutlinedButton(
                            color: mainBgColor,
                            title: _fullname,
                            onPressed: () async {
                              final data = await Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const SaleEmpFilter(),
                              ));
                              if(data != null){
                                _currentPage = 0;
                                setState(() {
                                  _filterAccount = data;
                                  _fullname = 'Người quản lý hợp đồng: ${_filterAccount.fullname!}';
                                  _deals.clear();
                                });
                                _refreshController.resetNoData();
                                _getFilter(isRefresh: true);
                              }
                            }, radius: 10,
                        ),

                        //Lọc theo khách hàng
                        CustomOutlinedButton(
                            title: _contactName,
                            radius: 10,
                            color: mainBgColor,
                            onPressed: () async {
                              final data = await Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const SaleEmpContactFilter(),
                              ));
                              if(data != null){
                                setState(() {
                                  _filterContact = data;
                                  _contactName = 'Tên khách hàng: ${_filterContact!.fullname}';
                                  _deals.clear();
                                });
                                _refreshController.resetNoData();
                                _getFilter(isRefresh: true);
                              }
                            },
                        ),

                        //Lọc theo ngày
                        CustomOutlinedButton(
                            title: _fromDateToDateString,
                            radius: 10,
                            color: mainBgColor,
                            onPressed: () async {
                              final data = await Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const SaleEmpDateFilter(),
                              ));
                              if(data != null){
                                FromDateToDate fromDateToDate = data;
                                setState(() {
                                  _fromDate = fromDateToDate.fromDate;
                                  _toDate = fromDateToDate.toDate;
                                  _fromDateToDateString = 'Ngày chốt hợp đồng: ${fromDateToDate.fromDateString} → ${fromDateToDate.toDateString}';
                                  _deals.clear();
                                });
                                _refreshController.resetNoData();
                                _getFilter(isRefresh: true);
                              }
                            },
                        ),
                        DropdownButton2(
                          customButton: const Icon(
                            Icons.sort,
                            size: 40,
                            color: mainBgColor,
                          ),
                          items: [
                            ...SortItems.firstItems.map(
                                  (item) =>
                                  DropdownMenuItem<SortItem>(
                                    value: item,
                                    child: SortItems.buildItem(item),
                                  ),
                            ),
                          ],
                          onChanged: (value) {
                            _isAsc = SortItems.onChanged(context, value as SortItem);
                            setState(() {
                              if(_isAsc == true ){
                                _deals.sort( (a,b) => a.closedDate.compareTo(b.closedDate) );
                              }else{
                              _deals.sort( (a,b) => b.closedDate.compareTo(a.closedDate) );
                              }
                            });
                          },
                          itemHeight: 40,
                          itemPadding: const EdgeInsets.only(left: 5, right: 5),
                          dropdownWidth: 220,
                          dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: mainBgColor,
                          ),
                          dropdownElevation: 8,
                          offset: const Offset(0, 8),
                        ),
                        IconButton(
                            onPressed: (){
                              if(_deals.isNotEmpty){
                                _deals.clear();
                              }
                              setState(() {
                                // _fullname = _getDepartmentName(_currentAccount.blockId!, _currentAccount.departmentId);
                                _fullname = 'Người quản lý hợp đồng';
                                _contactName = 'Tên khách hàng';
                                _filterContact = null;
                                _filterAccount = Account();
                                _fromDate = null;
                                _toDate = null;
                                _fromDateToDateString = 'Ngày chốt hợp đồng';
                              });
                              _refreshController.resetNoData();
                              _getOverallInfo(_currentPage, _currentAccount);
                            },
                            icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),


          //Card dưới
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.24),
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
                child: _deals.isNotEmpty ? SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: true,
                  onRefresh: () async{
                    setState(() {
                      _deals.clear();
                    });
                    _refreshController.resetNoData();
                    print('Curent page: $_currentPage');

                    _getFilter(isRefresh: false);

                    if(_deals.isNotEmpty){
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
                  //     _getFilter(isRefresh: false);
                  //   }
                  //   print('Curent page: $_currentPage');
                  //
                  //   if(_deals.isNotEmpty){
                  //      _refreshController.loadComplete();
                  //   }else if(_deals.isEmpty){
                  //      _refreshController.loadFailed();
                  //   }
                  //
                  // },
                  child: ListView.builder(
                    itemBuilder: (context, index){
                      final deal = _deals[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, left: 5.0, right: 5.0),
                          child: Card(
                            elevation: 10.0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => SaleEmpDealDetail(deal: deal)
                                )).then(_onGoBack);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Text('Mã số hợp đồng:', style: TextStyle(fontSize: 12.0),),
                                          const Spacer(),
                                          Text('${deal.dealId}', style: const TextStyle(fontSize: 14.0),),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Text('Tiêu đề:', style: TextStyle(fontSize: 12.0),),
                                          const Spacer(),
                                          Text(deal.title, style: const TextStyle(fontSize: 14.0),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Text('Tiền trình hợp đồng:', style: TextStyle(fontSize: 12.0),),
                                          const Spacer(),
                                          Text(dealStagesNameUtilities[deal.dealStageId], style: const TextStyle(fontSize: 14.0),),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Text('Số tiền:', style: TextStyle(fontSize: 12.0),),
                                          const Spacer(),
                                          Text('${deal.amount} VNĐ', style: const TextStyle(fontSize: 14.0),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Text('Tên khách hàng:', style: TextStyle(fontSize: 12.0),),
                                          const Spacer(),
                                          Text(_getContactName(deal.contactId), style: const TextStyle(fontSize: 14.0),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Text('Người quản lý hợp đồng:', style: TextStyle(fontSize: 12.0),),
                                          const Spacer(),
                                          Text(_getDealOwnerName(deal.dealOwnerId), style: const TextStyle(fontSize: 14.0)),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Text('Ngày chốt hợp đồng:', style: TextStyle(fontSize: 12.0),),
                                          const Spacer(),
                                          Text(DateFormat('dd-MM-yyyy').format(deal.closedDate), style: const TextStyle(fontSize: 14.0),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )

                      );
                    },
                    itemCount: _deals.length,
                  ),
                ) : const Center(child: CircularProgressIndicator())
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: !_isSearching
                  ? const Text("Danh sách hợp đồng",style: TextStyle(color: Colors.blueGrey),)
                  : TextField(
                style: const TextStyle(color: Colors.blueGrey,),
                showCursor: true,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search,
                    color: Colors.blueGrey,
                  ),
                  hintText: "Tìm theo ID hợp đồng",
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                onSubmitted: (value){
                  setState(() {
                    _deals.clear();
                  });
                  _searchString = value.toString();
                  _getADealByDealId(accountId: _currentAccount.accountId!, dealId: int.parse(_searchString));
                },
              ),
              actions: <Widget>[
                _isSearching ? IconButton(
                  icon: const Icon(
                    Icons.cancel,
                  ),
                  onPressed: (){
                    _deals.clear();
                    setState(() {
                      _isSearching = false;
                      _currentPage = 0;
                      // _fullname = _getDepartmentName(_currentAccount.blockId!, _currentAccount.departmentId);
                      _fullname = 'Người quản lý hợp đồng';
                      _contactName = 'Tên khách hàng';
                      _filterContact = null;
                      _filterAccount = Account();
                      _fromDate = null;
                      _toDate = null;
                      _fromDateToDateString = 'Ngày chốt hợp đồng';
                      _getOverallInfo(_currentPage, _currentAccount);
                    });
                    _refreshController.resetNoData();
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

  void _getFilter({required bool isRefresh}){

    if(_filterAccount.accountId == null && _filterContact == null){
      if(_fromDate == null && _toDate == null){
        _getAllDealByAccountId(isRefresh: isRefresh, accountId: _currentAccount.accountId!, currentPage: _currentPage);
      }else if(_fromDate != null && _toDate != null){
        _getAllDealByAccountId(isRefresh: isRefresh, accountId: _currentAccount.accountId!, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate);
      }
    }

    if(_filterAccount.accountId == null && _filterContact != null){
      if(_fromDate == null && _toDate == null){
        _getAllDealByAccountId(isRefresh: isRefresh, accountId: _currentAccount.accountId!, currentPage: _currentPage, contactId: _filterContact!.contactId);
      }else if(_fromDate != null && _toDate != null){
        _getAllDealByAccountId(isRefresh: isRefresh, accountId: _currentAccount.accountId!, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate, contactId: _filterContact!.contactId);
      }
    }

    if(_filterAccount.accountId != null && _filterContact == null){
      if(_fromDate == null && _toDate == null){
        _getAllDealByDealOwnerId(isRefresh: isRefresh, dealOwnerId: _filterAccount.accountId!, currentPage: _currentPage);
      }else if(_fromDate != null && _toDate != null){
        _getAllDealByDealOwnerId(isRefresh: isRefresh, dealOwnerId: _filterAccount.accountId!, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate);
      }
    }

    if(_filterAccount.accountId != null && _filterContact != null){
      if(_fromDate == null && _toDate == null){
        _getAllDealByDealOwnerId(isRefresh: isRefresh, dealOwnerId: _filterAccount.accountId!, currentPage: _currentPage, contactId: _filterContact!.contactId);
      }else if(_fromDate != null && _toDate != null){
        _getAllDealByDealOwnerId(isRefresh: isRefresh, dealOwnerId: _filterAccount.accountId!, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate, contactId: _filterContact!.contactId);
      }
    }
  }

  // String _getDepartmentName(int blockId, departmentId){
  //   String name = '';
  //   for(int i = 0; i < departments.length; i++){
  //     if(blockId == departments[i].blockId && departmentId == departments[i].departmentId){
  //       name = departments[i].name;
  //     }
  //   }
  //   return name;
  // }

  void _getOverallInfo(int currentPage, Account account){
    if(_currentAccount.roleId == 5){
      _getAllDealByDealOwnerId(isRefresh: false, dealOwnerId: _currentAccount.accountId!, currentPage: currentPage);
    }else{
      _getAllDealByAccountId(isRefresh: false, accountId: account.accountId!, currentPage: currentPage);
    }
  }

  void _getAllDealByAccountId({required bool isRefresh, required int accountId, required int currentPage, int? contactId, DateTime? fromDate, DateTime? toDate}) async {

    List<Deal> dealList = await DealListViewModel().getAllDealByAccountId(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage, fromDate: fromDate, toDate: toDate, contactId: contactId);
    if(dealList.isNotEmpty){
      setState(() {
        _deals.clear();
        _deals.addAll(dealList);
      });
        _maxPages = _deals[0].maxPage!;
    }else{
      setState(() {
        _refreshController.loadNoData();
      });
    }
    print('Max page: $_maxPages');
  }

  void _getAllDealByDealOwnerId({required bool isRefresh, required int dealOwnerId, required int currentPage, int? contactId, DateTime? fromDate, DateTime? toDate}) async {

    List<Deal> dealList = await DealListViewModel().getAllDealByDealOwnerId(isRefresh: isRefresh, dealOwnerId: dealOwnerId, currentPage: currentPage, fromDate: fromDate, toDate: toDate, contactId: contactId);

    if(dealList.isNotEmpty){
      setState(() {
        _deals.clear();
        _deals.addAll(dealList);
      });
      _maxPages = _deals[0].maxPage!;
    }else{
      setState(() {
        _refreshController.loadNoData();
      });
    }
    print('Max page: $_maxPages');
  }

  void _getADealByDealId({required int accountId, required int dealId}) async {
    Deal? deal = await DealViewModel().getADealbyDealId(accountId: accountId, dealId: dealId);

      setState(() {
        _deals.add(deal);
        _maxPages = _deals[0].maxPage!;
      });

  }

  void _onGoBack(dynamic value){

    setState(() {
      // _currentPage = 0;
      _deals.clear();
    });
    _refreshController.resetNoData();


    if(_isSearching == false || _searchString.isEmpty){
      _getFilter(isRefresh: false);
    }else if(_isSearching == true && _searchString.isNotEmpty){
      _getADealByDealId(accountId: _currentAccount.accountId!, dealId: int.parse(_searchString));
    }
  }

  void _getAllSaleEmployee({required bool isRefresh}){
    if(_currentAccount.roleId == 4 || _currentAccount.roleId == 5){
      _getAllSalesEmployeesByBlockIdDepartmentIdOrTeamId(isRefresh: isRefresh, currentPage: _currentPage, blockId: _currentAccount.blockId!, departmentId:  _currentAccount.departmentId!, teamId: _currentAccount.teamId, limit: 1000000);
    }else if(_currentAccount.roleId == 3){
      _getAllSalesEmployeesByBlockIdDepartmentIdOrTeamId(isRefresh: isRefresh, currentPage: _currentPage, blockId: _currentAccount.blockId!, departmentId:  _currentAccount.departmentId!, limit: 1000000);
    }
  }

  void _getAllSalesEmployeesByBlockIdDepartmentIdOrTeamId({required bool isRefresh, required int currentPage, required int blockId, required int departmentId, int? teamId, int? limit}) async {
    List<Account>? accountList = await AccountListViewModel().getAllSalesForContact(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId, limit: limit);

    if(accountList != null ){
      setState(() {
        _saleEmployeeList.addAll(accountList);
      });
    }
  }
  
  void _getAllContactByAccountId({required bool isRefresh, required int accountId, required int currentPage, int? limit}) async {
    List<Contact> contactList = await ContactListViewModel().getAllContactByAccountId(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage, limit: limit);

    if(contactList.isNotEmpty){
      setState(() {
        _contactList.addAll(contactList);
      });
    }
  }
  
  String _getContactName(int contactId){
    String name = '';
    for(int i = 0; i < _contactList.length; i++){
      if(contactId == _contactList[i].contactId){
         name = _contactList[i].fullname;
      }
    }
    return name;
  }
  
  String _getDealOwnerName(int dealOwnerId){
    String name = '';
    for(int i = 0; i < _saleEmployeeList.length; i++){
      if(dealOwnerId == _saleEmployeeList[i].accountId){
        name = _saleEmployeeList[i].fullname!;
      }
    }
    return name;
  }

}

class SortItems {
  static const List<SortItem> firstItems = [asc, des];

  static const asc = SortItem(text: 'Ngày chốt tăng dần', icon: Icons.arrow_drop_up);
  static const des = SortItem(text: 'Ngày chốt giảm dần', icon: Icons.arrow_drop_down);


  static Widget buildItem(SortItem item) {
    return Row(
      children: [
        Icon(
            item.icon,
            color: Colors.white,
            size: 22
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, SortItem item) {
    switch (item) {
      case SortItems.asc:
        return true;
      case SortItems.des:
      //Do something
        return false;
    }
  }
}