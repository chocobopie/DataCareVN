import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
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
  String fullname = 'Nhân viên';
  late final GlobalKey<FormFieldState> _key = GlobalKey();
  int _currentPage = 0, _maxPages = 0, _contactOwnerId = -1;

  final RefreshController _refreshController = RefreshController();

  late Future<List<Contact>> _futureContacts;
  late final List<Contact> _contacts = [];
  late Account currentAccount, filterAccount = Account();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_contacts.isEmpty){
      currentAccount = Provider.of<AccountProvider>(context).account;
      getOverallInfo(_currentPage, currentAccount);
    }
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
            builder: (context) => SaleEmpContactAddNew(account: currentAccount,),
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
                  child: currentAccount.roleId! == 3 || currentAccount.roleId == 4 ? Row(
                    children: <Widget>[
                      const Text('LỌC THEO', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                      const SizedBox(width: 10,),
                      CustomOutlinedButton(
                        color: mainBgColor,
                        title: fullname,
                        radius: 30,
                        onPressed: () async {
                          final data = await Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const SaleEmpFilter(),
                          ));
                          if(data != null){
                            _currentPage = 0;

                            setState(() {
                              filterAccount = data;
                              _contactOwnerId = filterAccount.accountId!;
                              fullname = filterAccount.fullname!;
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
                              filterAccount = Account();
                              _currentPage = 0;
                              fullname = 'Nhân viên';
                              _contactOwnerId = -1;
                              _contacts.clear();
                              _refreshController.resetNoData();
                              getOverallInfo(_currentPage, currentAccount);
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
            padding: EdgeInsets.only(top: currentAccount.roleId! == 3 || currentAccount.roleId == 4 ? MediaQuery.of(context).size.height * 0.22 : 90),
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
                      _getAllContactByAccountId(isRefresh: true ,currentPage: _currentPage, accountId: currentAccount.accountId!);
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
                        _getAllContactByAccountId(isRefresh: false ,currentPage: _currentPage, accountId: currentAccount.accountId!);
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
                              builder: (context) => SaleEmpContactDetail(contact: contact, account: currentAccount,),
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
                onSubmitted: (value){
                  _currentPage = 0;
                  searchNameAndEmail(currentAccount: currentAccount, query: value.toString());
                }
              ),
              actions: <Widget>[
                _isSearching ? IconButton(
                  icon: const Icon(
                    Icons.cancel,
                  ),
                  onPressed: (){
                    _contacts.clear();
                    setState(() {
                      _isSearching = false;
                      getOverallInfo(_currentPage, currentAccount);
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

  void searchNameAndEmail({required Account currentAccount, required String query}) async {
      List<Contact> contactList = await ContactListViewModel().searchNameAndEmail(currentAccount: currentAccount, query: query);

      setState(() {
        if(_contacts.isNotEmpty){
          _contacts.clear();
        }
        _contacts.addAll(contactList);
      });
  }

  onGoBack(dynamic value) {
    if(_contacts.isNotEmpty){
      _contacts.clear();
    }

    setState(() {
      _currentPage = 0;
      _key.currentState?.reset();
    });

    if(_contactOwnerId == -1){
      getOverallInfo(_currentPage, currentAccount);
    }else{
      _getAllContactByOwnerId(isRefresh: true, contactOwnerId: _contactOwnerId, currentPage: _currentPage);
    }
  }

}
