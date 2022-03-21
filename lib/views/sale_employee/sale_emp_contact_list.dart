import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/view_models/account_list_view_model.dart';
import 'package:login_sample/view_models/contact_list_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_contact_add_new.dart';
import 'package:login_sample/views/sale_employee/sale_emp_contact_detail.dart';
import 'package:login_sample/views/sale_employee/sale_emp_filter.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



class SaleEmpContactList extends StatefulWidget {
  const SaleEmpContactList({Key? key}) : super(key: key);

  @override
  _SaleEmpContactListState createState() => _SaleEmpContactListState();
}

class _SaleEmpContactListState extends State<SaleEmpContactList> {

  bool _isSearching = false;
  String _fullname = 'Nhân viên tạo', _searchString = '';
  late final GlobalKey<FormFieldState> _key = GlobalKey();
  int _currentPage = 0, _maxPages = 0, _contactOwnerId = -1;

  final RefreshController _refreshController = RefreshController();
  late final List<Contact> _contacts = [];
  late final List<Account> _saleEmployeeList = [];
  late Account _currentAccount, _filterAccount = Account();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_contacts.isEmpty){
      _currentAccount = Provider.of<AccountProvider>(context).account;
      getOverallInfo(_currentPage, _currentAccount);
      // _fullname = _getDepartmentName(_currentAccount.blockId!, _currentAccount.departmentId);
    }
    _getAllSaleEmployee(isRefresh: true);
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
            builder: (context) => SaleEmpContactAddNew(account: _currentAccount,),
          )).then(_onGoBack);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.person_add),
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
            margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 90.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                  child: (_currentAccount.roleId! == 3 || _currentAccount.roleId == 4) && _fullname.isNotEmpty ? Row(
                    children: <Widget>[
                      const Text('Lọc theo:', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                      const SizedBox(width: 10,),
                      CustomOutlinedButton(
                        color: mainBgColor,
                        title: _fullname,
                        radius: 30,
                        onPressed: () async {
                          final data = await Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const SaleEmpFilter(),
                          ));
                          if(data != null){
                            _currentPage = 0;

                            setState(() {
                              _filterAccount = data;
                              _contactOwnerId = _filterAccount.accountId!;
                              _fullname = _filterAccount.fullname!;
                            });

                            if(_contacts.isNotEmpty){
                              _contacts.clear();
                            }

                            _getAllContactByOwnerId(isRefresh: true, contactOwnerId: _contactOwnerId, currentPage: _currentPage);
                          }
                        },
                      ),
                      IconButton(
                          onPressed: (){
                            setState(() {
                              _filterAccount = Account();
                              _currentPage = 0;
                              // _fullname = _getDepartmentName(_currentAccount.blockId!, _currentAccount.departmentId);
                              _fullname = 'Nhân viên tạo';
                              _contactOwnerId = -1;
                              _contacts.clear();
                              _refreshController.resetNoData();
                              getOverallInfo(_currentPage, _currentAccount);
                            });
                          },
                          icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                      ),
                    ],
                  ) : null
                ),
              ],
            ),
          ),
          //Card dưới
          Padding(
            padding: EdgeInsets.only(top: _currentAccount.roleId! == 3 || _currentAccount.roleId == 4 ? MediaQuery.of(context).size.height * 0.20 : 90),
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
                    _currentPage = 0;
                    _refreshController.resetNoData();
                    print('Current page: $_currentPage');
                    if(_contactOwnerId == -1){
                      _getAllContactByAccountId(isRefresh: true ,currentPage: _currentPage, accountId: _currentAccount.accountId!);
                    } else {
                      _getAllContactByOwnerId(isRefresh: true, contactOwnerId: _contactOwnerId, currentPage: _currentPage);
                    }

                    if(_contacts.isNotEmpty){
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
                      if(_contactOwnerId == -1){
                        _getAllContactByAccountId(isRefresh: false ,currentPage: _currentPage, accountId: _currentAccount.accountId!);
                      } else {
                        _getAllContactByOwnerId(isRefresh: false, contactOwnerId: _contactOwnerId, currentPage: _currentPage);
                      }
                    }

                    if(_contacts.isNotEmpty){
                      _refreshController.loadComplete();
                    }else{
                      _refreshController.loadFailed();
                    }
                  },
                  child: ListView.builder(
                      itemBuilder: (context, index){
                        final contact = _contacts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0, left: 5.0, right: 5.0),
                          child: Card(
                              elevation: 10,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => SaleEmpContactDetail(contact: contact, account: _currentAccount)
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
                                          const Text('Tên khách hàng:', style: TextStyle(fontSize: 14),),
                                          const Spacer(),
                                          Text(contact.fullname, style: const TextStyle(fontSize: 14),),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Text('Email:', style: TextStyle(fontSize: 14),),
                                          const Spacer(),
                                          Text(contact.email, style: const TextStyle(fontSize: 14),),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 30.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Text('Số điện thoại:', style: TextStyle(fontSize: 14),),
                                          const Spacer(),
                                          Text(contact.phoneNumber, style: const TextStyle(fontSize: 14),),
                                        ],
                                      ),
                                    ),

                                    Row(
                                      children: <Widget>[
                                        const Text('Nhân viên tạo: ', style: TextStyle(fontSize: 14),),
                                        const Spacer(),
                                        Text(_getContactOwnerName(contact.contactOwnerId)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          )
                        );
                      },
                      itemCount: _contacts.length,
                  ),
                ) :  const Center(child: CircularProgressIndicator())
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
                  ? const Text("Danh sách khách hàng",style: TextStyle(color: Colors.blueGrey),)
                  : TextField(
                style: const TextStyle(color: Colors.blueGrey,),
                showCursor: true,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search,
                    color: Colors.blueGrey,
                  ),
                  hintText: "Tìm theo tên, email của khách hàng",
                  hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 14.0),
                ),
                onSubmitted: (value){
                  _currentPage = 0;
                  setState(() {
                    _fullname = _getDepartmentName(_currentAccount.blockId!, _currentAccount.departmentId);
                  });
                  _searchString = value.toString();
                  _searchNameAndEmail(currentAccount: _currentAccount, query: _searchString);
                }
              ),
              actions: <Widget>[
                _isSearching ? IconButton(
                  icon: const Icon(
                    Icons.cancel,
                  ),
                  onPressed: (){
                    _contacts.clear();
                    _searchString = '';
                    setState(() {
                      _isSearching = false;
                      _filterAccount = Account();
                      _currentPage = 0;
                      _fullname = _getDepartmentName(_currentAccount.blockId!, _currentAccount.departmentId);
                      _contactOwnerId = -1;
                      _contacts.clear();
                      _refreshController.resetNoData();
                      getOverallInfo(_currentPage, _currentAccount);
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

  void getOverallInfo(int currentPage, Account account){
      _getAllContactByAccountId(isRefresh: true, accountId: account.accountId!, currentPage: currentPage);
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

  void _getAllContactByAccountId({required bool isRefresh, required int accountId, required int currentPage}) async {
    List<Contact> contactList = await ContactListViewModel().getAllContactByAccountId(isRefresh: isRefresh, accountId: accountId, currentPage: currentPage);

    if(contactList.isNotEmpty){
      setState(() {
        _contacts.addAll(contactList);
      });
      if(_contacts.isNotEmpty){
        _maxPages = _contacts[0].maxPage!;
      }
    }else{
      _refreshController.loadNoData();
    }

  }

  void _getAllContactByOwnerId({required bool isRefresh, required int contactOwnerId, required int currentPage}) async {
    List<Contact> contactList = await ContactListViewModel().getAllContactByOwnerId(isRefresh: isRefresh, contactOwnerId: contactOwnerId, currentPage: currentPage);

    if(contactList.isNotEmpty){
      setState(() {
        _contacts.addAll(contactList);
      });
      if(_contacts.isNotEmpty){
        _maxPages = _contacts[0].maxPage!;
      }
    }else{
      _refreshController.loadNoData();
    }
  }

  void _searchNameAndEmail({required Account currentAccount, required String query}) async {
      List<Contact> contactList = await ContactListViewModel().searchNameAndEmail(currentAccount: currentAccount, query: query);

      setState(() {
        _contacts.clear();
        _contacts.addAll(contactList);
      });
  }

  _onGoBack(dynamic value) {
    if(_contacts.isNotEmpty){
      _contacts.clear();
    }

    setState(() {
      _currentPage = 0;
      _key.currentState?.reset();
    });

    if(_isSearching == false || _searchString.isEmpty){
      if(_contactOwnerId == -1){
        getOverallInfo(_currentPage, _currentAccount);
      }else{
        _getAllContactByOwnerId(isRefresh: true, contactOwnerId: _contactOwnerId, currentPage: _currentPage);
      }
    }else if(_isSearching == true && _searchString.isNotEmpty){
      _searchNameAndEmail(currentAccount: _currentAccount, query: _searchString);
    }

  }

  void _getAllSaleEmployee({required bool isRefresh}){
    if(_currentAccount.roleId == 4){
      _getAllSalesEmployeesByBlockIdDepartmentIdOrTeamId(isRefresh: isRefresh, currentPage: _currentPage, blockId: _currentAccount.blockId!, departmentId:  _currentAccount.departmentId!, teamId: _currentAccount.teamId, limit: 1000000);
    }else if(_currentAccount.roleId == 3){
      _getAllSalesEmployeesByBlockIdDepartmentIdOrTeamId(isRefresh: isRefresh, currentPage: _currentPage, blockId: _currentAccount.blockId!, departmentId:  _currentAccount.departmentId!, limit: 1000000);
    }
  }

  void _getAllSalesEmployeesByBlockIdDepartmentIdOrTeamId({required bool isRefresh, required int currentPage, required int blockId, required int departmentId, int? teamId, int? limit}) async {
    List<Account> accountList = await AccountListViewModel().getAllSalesEmployeesByBlockIdDepartmentIdOrTeamId(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId, limit: limit);

    setState(() {
      _saleEmployeeList.addAll(accountList);
    });
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
