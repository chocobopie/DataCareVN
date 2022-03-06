import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/screens/providers/account_provider.dart';
import 'package:login_sample/screens/sale_employee/emp_contact_add_new.dart';
import 'package:login_sample/screens/sale_employee/emp_contact_detail.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomFilterFormField.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



class EmpContactList extends StatefulWidget {
  const EmpContactList({Key? key, required this.account}) : super(key: key);

  final Account account;

  @override
  _EmpContactListState createState() => _EmpContactListState();
}

class _EmpContactListState extends State<EmpContactList> {

  bool _isSearching = false;
  late final GlobalKey<FormFieldState> _key = GlobalKey();
  int _currentPage = 0, _maxPages = 0;
  late int _contactOwnerId;
  String? _contactOwnerIdName;

  final RefreshController _refreshController = RefreshController();

  late Future<List<Contact>> _futureContacts;
  late Future<List<Account>> _futureAccounts;

  late final List<Contact> _contacts = [];
  late final List<Account> _salesEmployees = [];
  late final List<String> _contactOwnerIdNames = [];
  late final List<String> _contactIdFullnames = [];


  @override
  void initState() {
    super.initState();
    getOverallInfo(_currentPage, widget.account);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var _account = Provider.of<AccountProvider>(context).account;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => EmpContactAddNew(account: widget.account,),
          )).then(onGoBack);
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
            margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 90.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,),
                  child: Row(
                    children: <Widget>[
                      const Text('LỌC THEO', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                      const SizedBox(width: 10,),
                      CustomFilterFormField(
                        key: _key,
                        items: _contactOwnerIdNames,
                        titleWidth: 120,
                        dropdownWidth: 250,
                        hint: 'Nhân viên',
                        selectedValue: _contactOwnerIdName,
                        onChanged: (value) {
                          if(_contacts.isNotEmpty){
                            _contacts.clear();
                          }
                          setState(() {
                            _contactOwnerIdName = value.toString();
                            String split = _contactOwnerIdName!.substring(0, _contactOwnerIdName!.indexOf(','));
                            _contactOwnerId = int.parse(split);
                          });
                          _getAllContactByOwnerId(isRefresh: true, contactOwnerId: _contactOwnerId, currentPage: _currentPage);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //Card dưới
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
                child: _contacts.isNotEmpty && _salesEmployees.isNotEmpty ? SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: true,
                  onRefresh: () async{
                    if(_contacts.isNotEmpty){
                      _contacts.clear();
                    }
                    _currentPage = 0;
                    if(_contactOwnerIdName == null){
                      _getAllContactByAccountId(isRefresh: true ,currentPage: _currentPage, accountId: widget.account.accountId!);
                    } else {
                      _getAllContactByOwnerId(isRefresh: true, contactOwnerId: _contactOwnerId, currentPage: _currentPage);
                    }

                    if(_futureContacts.toString().isNotEmpty){
                      _refreshController.refreshCompleted();
                    }else{
                      _refreshController.refreshFailed();
                    }
                  },
                  onLoading: () async{
                    if(_currentPage - 1 < _maxPages){
                      setState(() {
                        _currentPage++;
                      });
                      print(_currentPage);
                      if(_contactOwnerIdName == null){
                        _getAllContactByAccountId(isRefresh: false ,currentPage: _currentPage, accountId: widget.account.accountId!);
                      } else {
                        _getAllContactByOwnerId(isRefresh: false, contactOwnerId: _contactOwnerId, currentPage: _currentPage);
                      }
                    }

                    if(_futureContacts.toString().isNotEmpty){
                      _refreshController.loadComplete();
                    }else{
                      _refreshController.loadFailed();
                    }
                  },
                  child: ListView.separated(
                      itemBuilder: (context, index){
                        final contact = _contacts[index];
                        return ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => EmpContactDetail(contact: contact, account: _account,),
                            )).then(onGoBack);
                          },
                         title: const Text('Tên khách hàng:'),
                         subtitle: Text(contact.fullname),
                         dense: true,
                         trailing: Column(
                           children: [
                             const SizedBox(height: 8.0,),
                             Text('Email: ${contact.email}', style: const TextStyle(fontSize: 12.0)),
                             const SizedBox(
                               height: 5.0,
                             ),
                             Text('SĐT: ${contact.phoneNumber}', style: const TextStyle(fontSize: 12.0)),
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
                  hintText: "Tìm theo tên hoặc email",
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                onChanged: (value){
                  searchNameAndEmail(value.toString());
                }
              ),
              actions: <Widget>[
                _isSearching ? IconButton(
                  icon: const Icon(
                    Icons.cancel,
                  ),
                  onPressed: (){
                    if(_contacts.isNotEmpty){
                      _contacts.clear();
                    }
                    setState(() {
                      _isSearching = false;
                      getOverallInfo(_currentPage, widget.account);
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
      _getAllSalesEmployeesByBlockIdDepartmentId(account.blockId!, account.departmentId!);
  }

  void _getAllContactByAccountId({required bool isRefresh, required int accountId, required int currentPage}){
    _futureContacts = ApiService().getAllContactsByAccountId(isRefresh: isRefresh,accountId: accountId, currentPage: currentPage);

    _futureContacts.then((value) {
     setState(() {
       _contacts.addAll(value);
       _maxPages = _contacts[0].maxPage!;
     });
     });
    print('Max page: $_maxPages');
    _getAllContactIdFullname();
  }

  void _getAllContactIdFullname(){
    if(_contactIdFullnames.isNotEmpty){
      _contactIdFullnames.clear();
    }
    for(int i = 0; i < _contacts.length; i++){
      String idAndName = ('${_contacts[i].contactId}_${_contacts[i].fullname}');
      String split = '${idAndName.split('_')}';
      _contactIdFullnames.add(split.substring(1, split.length-1));
    }
    print(_contactIdFullnames);
  }

  void _getAllSalesEmployeesByBlockIdDepartmentId(int blockId, int departmentId){
    _futureAccounts = ApiService().getAllAccountByBlockIdDepartmentId(blockId, departmentId);

    _futureAccounts.then((value) {
      if(_salesEmployees.isNotEmpty){
        _salesEmployees.clear();
      }
      setState(() {
        _salesEmployees.addAll(value);
      });
      for(int i = 0; i < _salesEmployees.length; i++){
        if( _salesEmployees[i].roleId! < 3 || _salesEmployees[i].roleId! > 5){
          _salesEmployees.removeAt(i);
        }
      }
      _getAllContactOwnerIdNames();
    });
  }

  void _getAllContactOwnerIdNames(){
    if(_contactOwnerIdNames.isNotEmpty){
      _contactOwnerIdNames.clear();
    }

    for(int i = 0; i < _salesEmployees.length; i++){
      String idAndName;
      if(widget.account.accountId == _salesEmployees[i].accountId){
        idAndName = ('${_salesEmployees[i].accountId}_CỦA TÔI');
      } else {
        idAndName = ('${_salesEmployees[i].accountId}_${_salesEmployees[i].fullname}');
      }
      String split = '${idAndName.split('_')}';
      _contactOwnerIdNames.add(split.substring(1, split.length-1));
    }
    print(_contactOwnerIdNames);
  }

  onGoBack(dynamic value) {
    if(_contacts.isNotEmpty){
      _contacts.clear();
    }
    if(_contactOwnerIdName == null){
      getOverallInfo(_currentPage, widget.account);
    }else{
      _getAllContactByOwnerId(isRefresh: true, contactOwnerId: _contactOwnerId, currentPage: _currentPage);
    }
    setState(() {
      _currentPage = 0;
      _key.currentState?.reset();
    });
  }

  void searchNameAndEmail(String query){
    if(query.isNotEmpty){
      _futureContacts = ApiService().getAllContactByFullnameOrEmail(widget.account.accountId!, query.toLowerCase());

      _futureContacts.then((value) {
        if(_contacts.isNotEmpty){
          _contacts.clear();
        }
        setState(() {
          _contacts.addAll(value);
        });
      });
    }
  }

  void _getAllContactByOwnerId({required bool isRefresh, required int contactOwnerId, required int currentPage}){
    _futureContacts = ApiService().getAllContactByContactOwnerId(isRefresh: isRefresh, currentPage: currentPage, contactOwnerId: contactOwnerId);

    _futureContacts.then((value) {
      setState(() {
        _contacts.addAll(value);
        _maxPages = _contacts[0].maxPage!;
      });
      print('Max page: $_maxPages');
      _getAllContactIdFullname();
    });
  }

}
