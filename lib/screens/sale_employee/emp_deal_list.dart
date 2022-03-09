import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/screens/providers/account_provider.dart';
import 'package:login_sample/screens/sale_employee/emp_deal_add_new.dart';
import 'package:login_sample/screens/sale_employee/emp_deal_detail.dart';
import 'package:login_sample/screens/sale_employee/sale_emp_contact_detail.dart';
import 'package:login_sample/screens/sale_employee/sale_emp_filter.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EmpDealList extends StatefulWidget {
  const EmpDealList({Key? key}) : super(key: key);

  @override
  _EmpDealListState createState() => _EmpDealListState();
}

class _EmpDealListState extends State<EmpDealList> {

  bool _isSearching = false;
  String _fullname = 'Nhân viên';
  int _currentPage = 0, _maxPages = 0;

  final RefreshController _refreshController = RefreshController();

  late Future<List<Deal>> _futureDeals;
  late final List<Deal> _deals = [];
  late Account currentAccount, filterAccount = Account();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getOverallInfo(_currentPage, currentAccount);
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
            builder: (context) => const EmpDealAddNew(),
          ));
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
            margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,),
                  child: Row(
                    children: <Widget>[
                      const Text('LỌC THEO', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                      const SizedBox(width: 10,),
                      CustomOutlinedButton(
                          color: mainBgColor,
                          title: _fullname,
                          onPressed: () async {
                            final data = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => SaleEmpFilter(account: currentAccount,),
                            ));
                            if(data != null){
                              _currentPage = 0;
                              setState(() {
                                filterAccount = data;
                                _fullname = filterAccount.fullname!;
                              });
                              if(_deals.isNotEmpty){
                                _deals.clear();
                              }
                              _getAllDealByDealOwnerId(isRefresh: true, dealOwnerId: filterAccount.accountId!, currentPage: _currentPage);
                            }
                          }, radius: 30,
                      ),
                      IconButton(
                          onPressed: (){
                            if(_deals.isNotEmpty){
                              _deals.clear();
                            }
                            setState(() {
                              _currentPage = 0;
                              _fullname = 'Nhân viên';
                              filterAccount = Account();
                            });
                            _getOverallInfo(_currentPage, currentAccount);
                          },
                          icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),


          //Card dưới
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.24),
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
                    if(_deals.isNotEmpty){
                      _deals.clear();
                    }
                    _currentPage = 0;
                    if(filterAccount.accountId == null){
                      _getAllDealByAccountId(isRefresh: true, accountId: currentAccount.accountId!, currentPage: _currentPage);
                    } else {
                      _getAllDealByDealOwnerId(isRefresh: true, dealOwnerId: filterAccount.accountId!, currentPage: _currentPage);
                    }

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
                      print('Current page: $_currentPage');
                      if(filterAccount.accountId == null){
                        _getAllDealByAccountId(isRefresh: false, accountId: currentAccount.accountId!, currentPage: _currentPage);
                      } else {
                        _getAllDealByDealOwnerId(isRefresh: false, dealOwnerId: filterAccount.accountId!, currentPage: _currentPage);
                      }
                    }

                    if(_deals.isNotEmpty){
                      _refreshController.loadComplete();
                    }else{
                      _refreshController.loadFailed();
                    }
                  },
                  child: ListView.separated(
                    itemBuilder: (context, index){
                      final deal = _deals[index];
                      return ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => EmpDealDetail(deal: deal)
                          )).then(_onGoBack);
                        },
                        title: Text(deal.title),
                        subtitle: Text('Ngày đóng: ${DateFormat('dd-MM-yyyy').format(deal.closedDate)}'),
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

  void _getOverallInfo(int currentPage, Account account){
    _getAllDealByAccountId(isRefresh: true, accountId: account.accountId!, currentPage: currentPage);
  }

  void _getAllDealByAccountId({required bool isRefresh, required int accountId, required int currentPage}){
    _futureDeals = ApiService().getAllDealByAccountId(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage);

    _futureDeals.then((value) {
      setState(() {
        _deals.addAll(value);
        _maxPages = _deals[0].maxPage!;
      });
    });
    print('Max pages: $_maxPages');
  }

  void _getAllDealByDealOwnerId({required bool isRefresh, required int dealOwnerId, required int currentPage}){
    _futureDeals = ApiService().getAllDealByDealOwnerId(isRefresh: isRefresh, dealOwnerId: dealOwnerId, currentPage: currentPage);

    _futureDeals.then((value) {
      setState(() {
        _deals.addAll(value);
        _maxPages = _deals[0].maxPage!;
      });
    });
    print('Max pages: $_maxPages');
  }

  void _onGoBack(dynamic value){
    if(_deals.isNotEmpty){
      _deals.clear();
    }

    setState(() {
      _currentPage = 0;
    });

    if(filterAccount.accountId == null){
      _getOverallInfo(_currentPage, currentAccount);
    } else {
      _getAllDealByDealOwnerId(isRefresh: true, dealOwnerId: filterAccount.accountId!, currentPage: _currentPage);
    }
  }

}
