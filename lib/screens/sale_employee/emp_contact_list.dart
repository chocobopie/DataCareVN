import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/screens/providers/account_provider.dart';
import 'package:login_sample/screens/sale_employee/emp_contact_add_new.dart';
import 'package:login_sample/screens/sale_employee/emp_contact_detail.dart';
import 'package:login_sample/screens/sale_employee/sale_emp_filter.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/utilities/utils.dart';
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
  String fullname = '';
  late final GlobalKey<FormFieldState> _key = GlobalKey();
  int _currentPage = 0, _maxPages = 0, _contactOwnerId = -1;

  final RefreshController _refreshController = RefreshController();

  late Future<List<Contact>> _futureContacts;
  late Future<Account> _futureAccount;
  late final List<Contact> _contacts = [];


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
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,),
                  child: Row(
                    children: <Widget>[
                      const Text('LỌC THEO', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                      const SizedBox(width: 10,),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: defaultFontColor,
                            side: const BorderSide(width: 3.0, color: mainBgColor),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                          ),
                          onPressed: () async {
                            final data = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => SaleEmpFilter(account: _account,),
                            ));
                            if(data != null){

                              _currentPage = 0;
                              setState(() {
                                _contactOwnerId = data;
                              });

                              if(_contacts.isNotEmpty){
                                _contacts.clear();
                              }

                              _getAccountFullnameById(_contactOwnerId);
                              _getAllContactByOwnerId(isRefresh: true, contactOwnerId: _contactOwnerId, currentPage: _currentPage);
                            }
                          },
                          child:  _contactOwnerId == -1 ? const Text('Tên nhân viên') : Text(fullname)
                      ),
                      // CustomFilterFormField(
                      //   key: _key,
                      //   items: _contactOwnerIdNames,
                      //   titleWidth: 120,
                      //   dropdownWidth: 250,
                      //   hint: 'Nhân viên',
                      //   selectedValue: _contactOwnerIdName,
                      //   onChanged: (value) {
                      //     if(_contacts.isNotEmpty){
                      //       _contacts.clear();
                      //     }
                      //     setState(() {
                      //       _contactOwnerIdName = value.toString();
                      //       String split = _contactOwnerIdName!.substring(0, _contactOwnerIdName!.indexOf(','));
                      //       _contactOwnerId = int.parse(split);
                      //     });
                      //     _getAllContactByOwnerId(isRefresh: true, contactOwnerId: _contactOwnerId, currentPage: _currentPage);
                      //   },
                      // ),
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
                child: _contacts.isNotEmpty ? SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: true,
                  onRefresh: () async{
                    if(_contacts.isNotEmpty){
                      _contacts.clear();
                    }
                    _currentPage = 0;
                    if(_contactOwnerId == -1){
                      _getAllContactByAccountId(isRefresh: true ,currentPage: _currentPage, accountId: widget.account.accountId!);
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
                        _getAllContactByAccountId(isRefresh: false ,currentPage: _currentPage, accountId: widget.account.accountId!);
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
                  _currentPage = 0;
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
  }

  void _getAllContactByAccountId({required bool isRefresh, required int accountId, required int currentPage}){
    _futureContacts = ApiService().getAllContactsByAccountId(isRefresh: isRefresh,accountId: accountId, currentPage: currentPage);

    _futureContacts.then((value) {
     setState(() {
       _contacts.addAll(value);
       _maxPages = _contacts[0].maxPage!;
     });
     });
    for(int i = 0; i < _contacts.length; i++){
      if(_contacts[i].statusId == 1){
        _contacts.removeAt(i);
      }
    }
    print('Max page: $_maxPages');
  }

  void _getAccountFullnameById(int accountId){
    _futureAccount = ApiService().getAccountById(accountId);
    _futureAccount.then((value) {
      setState(() {
        fullname = value.fullname!;
      });
    });
  }

  onGoBack(dynamic value) {
    if(_contacts.isNotEmpty){
      _contacts.clear();
    }
    if(_contactOwnerId == -1){
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
    });
    for(int i = 0; i < _contacts.length; i++){
      if(_contacts[i].statusId == 1){
        _contacts.removeAt(i);
      }
    }
    print('Max page: $_maxPages');
  }

}
