import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/models/fromDateToDate.dart';
import 'package:login_sample/view_models/deal_list_view_model.dart';
import 'package:login_sample/view_models/deal_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_contact_filter.dart';
import 'package:login_sample/views/sale_employee/sale_emp_deal_add_new.dart';
import 'package:login_sample/views/sale_employee/sale_emp_deal_detail.dart';
import 'package:login_sample/views/sale_employee/sale_emp_date_filter.dart';
import 'package:login_sample/views/sale_employee/sale_emp_filter.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SaleEmpDealList extends StatefulWidget {
  const SaleEmpDealList({Key? key}) : super(key: key);

  @override
  _SaleEmpDealListState createState() => _SaleEmpDealListState();
}

class _SaleEmpDealListState extends State<SaleEmpDealList> {

  bool _isSearching = false;
  String _fullname = '', fromDateToDateString = 'Từ trước đến nay', _contactName = 'Tất cả khách hàng';
  int _currentPage = 0, _maxPages = 0;

  final RefreshController _refreshController = RefreshController();

  late final List<Deal> _deals = [];
  late Account currentAccount, filterAccount = Account();

  Contact? filterContact;
  DateTime? fromDate, toDate;


  @override
  void initState() {
    super.initState();
    currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getOverallInfo(_currentPage, currentAccount);
    setState(() {
      _fullname = _getDepartmentName(currentAccount.blockId!, currentAccount.departmentId);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const SaleEmpDealAddNew(),
          )).then(_onGoBack);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.plus_one),
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
            margin: const EdgeInsets.only(top: 100.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Column(
                children: <Widget>[
                  const Text('Lọc', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                  Row(
                    children: <Widget>[
                      //Lọc theo nhân viên
                      if(currentAccount.roleId! == 3 || currentAccount.roleId! == 4) Expanded(
                        child: CustomOutlinedButton(
                            color: mainBgColor,
                            title: _fullname,
                            onPressed: () async {
                              final data = await Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const SaleEmpFilter(),
                              ));
                              if(data != null){
                                _currentPage = 0;
                                setState(() {
                                  filterAccount = data;
                                  _fullname = filterAccount.fullname!;
                                  _deals.clear();
                                });
                                _refreshController.resetNoData();
                                _getFilter(isRefresh: true);
                              }
                            }, radius: 30,
                        ),
                      ),

                      //Lọc theo khách hàng
                      Expanded(
                        child: CustomOutlinedButton(
                            title: _contactName,
                            radius: 30,
                            color: mainBgColor,
                            onPressed: () async {
                              final data = await Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const SaleEmpContactFilter(),
                              ));
                              if(data != null){
                                setState(() {
                                  filterContact = data;
                                  _contactName = filterContact!.fullname;
                                  _deals.clear();
                                });
                                _refreshController.resetNoData();
                                _getFilter(isRefresh: true);
                              }
                            },
                        ),
                      ),

                      //Lọc theo ngày
                      Expanded(
                        child: CustomOutlinedButton(
                            title: fromDateToDateString,
                            radius: 30,
                            color: mainBgColor,
                            onPressed: () async {
                              final data = await Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const SaleEmpDateFilter(),
                              ));
                              if(data != null){
                                FromDateToDate fromDateToDate = data;
                                setState(() {
                                  fromDate = fromDateToDate.fromDate;
                                  toDate = fromDateToDate.toDate;
                                  fromDateToDateString = '${fromDateToDate.fromDateString} → ${fromDateToDate.toDateString}';
                                  _deals.clear();
                                });
                                _refreshController.resetNoData();
                                _getFilter(isRefresh: true);
                              }
                            },
                        ),
                      ),


                      IconButton(
                          onPressed: (){
                            if(_deals.isNotEmpty){
                              _deals.clear();
                            }
                            setState(() {
                              _currentPage = 0;
                              _fullname = _getDepartmentName(currentAccount.blockId!, currentAccount.departmentId);
                              _contactName = 'Tất cả khách hàng';
                              filterContact = null;
                              filterAccount = Account();
                              fromDate = null;
                              toDate = null;
                              fromDateToDateString = 'Từ trước đến nay';
                            });
                            _refreshController.resetNoData();
                            _getOverallInfo(_currentPage, currentAccount);
                          },
                          icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                      ),
                    ],
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
                    _currentPage = 0;
                    print('Curent page: $_currentPage');

                    _getFilter(isRefresh: true);

                    if(_deals.isNotEmpty){
                      _refreshController.refreshCompleted();
                    }else{
                      _refreshController.refreshFailed();
                    }
                  },
                  onLoading: () async{
                    if(_currentPage < _maxPages){
                      setState(() {
                        _currentPage++;
                      });
                      _getFilter(isRefresh: false);
                    }
                    print('Curent page: $_currentPage');

                    if(_deals.isNotEmpty){
                       _refreshController.loadComplete();
                    }else if(_deals.isEmpty){
                       _refreshController.loadFailed();
                    }

                  },
                  child: ListView.separated(
                    itemBuilder: (context, index){
                      final deal = _deals[index];
                      return ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => SaleEmpDealDetail(deal: deal)
                          )).then(_onGoBack);
                        },
                        title: Text(deal.title),
                        subtitle: Text('Từ trước đến nay: ${DateFormat('dd-MM-yyyy').format(deal.closedDate)}'),
                        dense: true,
                        trailing: Column(
                          children: [
                            const SizedBox(height: 8.0,),
                            Text('Giá trị: ${deal.amount}'),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text('Tiến trình: ${dealStagesNameUtilities[deal.dealStageId]}'),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 1,
                        thickness: 2,
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
                  _getADealByDealId(dealId: int.parse(value.toString()));
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
                      _getOverallInfo(_currentPage, currentAccount);
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

  void _getFilter({required bool isRefresh}){

    if(filterAccount.accountId == null && filterContact == null){
      if(fromDate == null && toDate == null){
        _getAllDealByAccountId(isRefresh: isRefresh, accountId: currentAccount.accountId!, currentPage: _currentPage);
      }else if(fromDate != null && toDate != null){
        _getAllDealByAccountId(isRefresh: isRefresh, accountId: currentAccount.accountId!, currentPage: _currentPage, fromDate: fromDate, toDate: toDate);
      }
    }

    if(filterAccount.accountId == null && filterContact != null){
      if(fromDate == null && toDate == null){
        _getAllDealByAccountId(isRefresh: isRefresh, accountId: currentAccount.accountId!, currentPage: _currentPage, contactId: filterContact!.contactId);
      }else if(fromDate != null && toDate != null){
        _getAllDealByAccountId(isRefresh: isRefresh, accountId: currentAccount.accountId!, currentPage: _currentPage, fromDate: fromDate, toDate: toDate, contactId: filterContact!.contactId);
      }
    }

    if(filterAccount.accountId != null && filterContact == null){
      if(fromDate == null && toDate == null){
        _getAllDealByDealOwnerId(isRefresh: isRefresh, dealOwnerId: filterAccount.accountId!, currentPage: _currentPage);
      }else if(fromDate != null && toDate != null){
        _getAllDealByDealOwnerId(isRefresh: isRefresh, dealOwnerId: filterAccount.accountId!, currentPage: _currentPage, fromDate: fromDate, toDate: toDate);
      }
    }

    if(filterAccount.accountId != null && filterContact != null){
      if(fromDate == null && toDate == null){
        _getAllDealByDealOwnerId(isRefresh: isRefresh, dealOwnerId: filterAccount.accountId!, currentPage: _currentPage, contactId: filterContact!.contactId);
      }else if(fromDate != null && toDate != null){
        _getAllDealByDealOwnerId(isRefresh: isRefresh, dealOwnerId: filterAccount.accountId!, currentPage: _currentPage, fromDate: fromDate, toDate: toDate, contactId: filterContact!.contactId);
      }
    }
  }

  String _getDepartmentName(int blockId, departmentId){
    String name = '';
    for(int i = 0; i < departments.length; i++){
      if(blockId == departments[i].blockId && departmentId == departments[i].departmentId){
        name = departments[i].name;
      }
    }
    return name;
  }

  void _getOverallInfo(int currentPage, Account account){
    if(currentAccount.roleId == 5){
      _getAllDealByDealOwnerId(isRefresh: true, dealOwnerId: currentAccount.accountId!, currentPage: currentPage);
    }else{
      _getAllDealByAccountId(isRefresh: true, accountId: account.accountId!, currentPage: currentPage);
    }
  }

  void _getAllDealByAccountId({required bool isRefresh, required int accountId, required int currentPage, int? contactId, DateTime? fromDate, DateTime? toDate}) async {

    List<Deal> dealList = await DealListViewModel().getAllDealByAccountId(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage, fromDate: fromDate, toDate: toDate, contactId: contactId);
    if(dealList.isNotEmpty){
      setState(() {
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

  void _getADealByDealId({required int dealId}) async {
    Deal deal = await DealViewModel().getADealByDealId(dealId: dealId);

    setState(() {
      _deals.add(deal);
    });
  }

  void _onGoBack(dynamic value){
    setState(() {
      _currentPage = 0;
      _deals.clear();
    });
    _refreshController.resetNoData();
    _getFilter(isRefresh: true);
  }

}
