import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/account_list_view_model.dart';
import 'package:login_sample/view_models/contact_list_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SaleEmpContactFilter extends StatefulWidget {
  const SaleEmpContactFilter({Key? key}) : super(key: key);

  @override
  State<SaleEmpContactFilter> createState() => _SaleEmpContactFilterState();
}

class _SaleEmpContactFilterState extends State<SaleEmpContactFilter> {

  late final List<Contact> _contacts = [];
  late Account _currentAccount;
  int _currentPage = 0, _maxPages = 0;
  final RefreshController _refreshController = RefreshController();
  final TextEditingController _searchContactNameOrEmail = TextEditingController();
  late final List<Account> _saleEmployeeList = [];

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getAllContactByAccountId(isRefresh: true, accountId: _currentAccount.accountId!, currentPage: _currentPage);
    _getAllSaleEmployee(isRefresh: true);
  }

  @override
  void dispose() {
    super.dispose();
    _searchContactNameOrEmail.dispose();
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
          buttonSelectedBackgroundColor: mainBgColor,
          onPageChange: (int index) {
            setState(() {
              _currentPage = index;
              _contacts.clear();
            });
            if(_searchContactNameOrEmail.text.isNotEmpty){
              _searchContactByNameOrEmail(currentAccount: _currentAccount, query: _searchContactNameOrEmail.text);
            }else{
              _getAllContactByAccountId(isRefresh: false, accountId: _currentAccount.accountId!, currentPage: _currentPage);
            }
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
                    controller: _searchContactNameOrEmail,
                    showCursor: true,
                    cursorColor: Colors.black,
                    onSubmitted: (value){
                      _currentPage = 0;
                      _refreshController.resetNoData();
                      _contacts.clear();
                      _searchContactByNameOrEmail(currentAccount: _currentAccount, query: value.toString());
                    },
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search,
                        color: Colors.blueGrey,
                      ),
                      suffixIcon: _searchContactNameOrEmail.text.isNotEmpty ? IconButton(
                        onPressed: (){
                          _searchContactNameOrEmail.clear();
                          _refreshController.resetNoData();
                          setState(() {
                            _contacts.clear();
                          });
                          _getAllContactByAccountId(isRefresh: true, accountId: _currentAccount.accountId!, currentPage: _currentPage);
                        },
                        icon: const Icon(Icons.clear),
                      ) : null,
                      hintText: "Tìm theo tên của khách hàng",
                      hintStyle: const TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
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
                  child: _contacts.isNotEmpty ? SmartRefresher(
                      controller: _refreshController,
                      enablePullUp: true,
                      onRefresh: () async{
                        setState(() {
                          _contacts.clear();
                        });
                        _refreshController.resetNoData();
                        if(_searchContactNameOrEmail.text.isNotEmpty){
                          _searchContactByNameOrEmail(currentAccount: _currentAccount, query: _searchContactNameOrEmail.text);
                        }else{
                          _getAllContactByAccountId(isRefresh: false, accountId: _currentAccount.accountId!, currentPage: _currentPage);
                        }

                        if(_contacts.isNotEmpty){
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
                      //     if(_searchContactNameOrEmail.text.isNotEmpty){
                      //       _searchContactByNameOrEmail(currentAccount: _currentAccount, query: _searchContactNameOrEmail.text);
                      //     }else{
                      //       _getAllContactByAccountId(isRefresh: false, accountId: _currentAccount.accountId!, currentPage: _currentPage);
                      //     }
                      //   }
                      //
                      //   if(_contacts.isNotEmpty){
                      //     _refreshController.loadComplete();
                      //   }else{
                      //     _refreshController.loadFailed();
                      //   }
                      // },
                      child: _contacts.isNotEmpty ? ListView.builder(
                          itemBuilder: (context, index) {
                            final contact = _contacts[index];
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context, contact);
                                },
                                child: Card(
                                  elevation: 10.0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                                          child: Row(
                                            children: <Widget>[
                                              const Text('Tên khách hàng:'),
                                              const Spacer(),
                                              Text(contact.fullname),
                                            ],
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                                          child: Row(
                                            children: <Widget>[
                                              const Text('Tên công ty:'),
                                              const Spacer(),
                                              Text(contact.companyName),
                                            ],
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                                          child: Row(
                                            children: <Widget>[
                                              const Text('SĐT:'),
                                              const Spacer(),
                                              Text(contact.phoneNumber),
                                            ],
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                                          child: Row(
                                            children: <Widget>[
                                              const Text('Email:'),
                                              const Spacer(),
                                              Text(contact.email),
                                            ],
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                                          child: Row(
                                            children: <Widget>[
                                              const Text('Người tạo:'),
                                              const Spacer(),
                                              Text(_getContactOwnerName(contact.contactOwnerId)),
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
                          itemCount: _contacts.length
                      ) : const Center(child: CircularProgressIndicator())
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
              title: const Text(
                "Lọc theo khách hàng",
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

  void _getAllContactByAccountId({required bool isRefresh, required int accountId, required int currentPage}) async {
    List<Contact> contactList = await ContactListViewModel().getAllContactByAccountId(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage);

    if(contactList.isNotEmpty){
      setState(() {
        _contacts.clear();
        _contacts.addAll(contactList);
      });
      _maxPages = _contacts[0].maxPage!;
    }else{
      _refreshController.loadNoData();
    }
  }

  void _searchContactByNameOrEmail({required Account currentAccount, required String query}) async {
    List<Contact> contactList = await ContactListViewModel().searchNameAndEmail(currentAccount: currentAccount, query: query);

    if(contactList.isNotEmpty){
      setState(() {
        _contacts.clear();
        _contacts.addAll(contactList);
      });
      _maxPages = _contacts[0].maxPage!;
    }else{
      _refreshController.loadNoData();
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

    if(accountList != null){
      setState(() {
        _saleEmployeeList.addAll(accountList);
      });
    }
  }

  String _getContactOwnerName(int contactOwnerId){
    String name = '';
    for(int i = 0; i < _saleEmployeeList.length; i++){
      if(contactOwnerId == _saleEmployeeList[i].accountId){
        name = _saleEmployeeList[i].fullname!;
      }
    }
    return name;
  }

}
