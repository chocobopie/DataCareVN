import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/contact_list_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SaleEmpContactFilter extends StatefulWidget {
  const SaleEmpContactFilter({Key? key}) : super(key: key);

  @override
  State<SaleEmpContactFilter> createState() => _SaleEmpContactFilterState();
}

class _SaleEmpContactFilterState extends State<SaleEmpContactFilter> {

  late final List<Contact> _contacts = [];
  late Account currentAccount;
  int _currentPage = 0, _maxPages = 0;
  final RefreshController _refreshController = RefreshController();
  final TextEditingController _searchContactNameOrEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getAllContactByAccountId(isRefresh: true, accountId: currentAccount.accountId!, currentPage: _currentPage);
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
                    onChanged: (value){
                      _currentPage = 0;
                      _searchContactByNameOrEmail(currentAccount: currentAccount, query: value.toString());
                    },
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search,
                        color: Colors.blueGrey,
                      ),
                      suffixIcon: _searchContactNameOrEmail.text.isNotEmpty ? IconButton(
                        onPressed: (){
                          _searchContactNameOrEmail.clear();
                          setState(() {
                            _contacts.clear();
                          });
                          _getAllContactByAccountId(isRefresh: true, accountId: currentAccount.accountId!, currentPage: _currentPage);
                        },
                        icon: const Icon(Icons.clear),
                      ) : null,
                      hintText: "Tìm theo tên hoặc email",
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
                        if(_contacts.isNotEmpty){
                          _contacts.clear();
                        }
                        _currentPage = 0;
                        if(_searchContactNameOrEmail.text.isNotEmpty){
                          _searchContactByNameOrEmail(currentAccount: currentAccount, query: _searchContactNameOrEmail.text);
                        }else{
                          _getAllContactByAccountId(isRefresh: true, accountId: currentAccount.accountId!, currentPage: _currentPage);
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
                          if(_searchContactNameOrEmail.text.isNotEmpty){
                            _searchContactByNameOrEmail(currentAccount: currentAccount, query: _searchContactNameOrEmail.text);
                          }else{
                            _getAllContactByAccountId(isRefresh: false, accountId: currentAccount.accountId!, currentPage: _currentPage);
                          }
                        }

                        if(_contacts.isNotEmpty){
                          _refreshController.loadComplete();
                        }else{
                          _refreshController.loadFailed();
                        }
                      },
                      child: _contacts.isNotEmpty ? ListView.separated(
                          itemBuilder: (context, index) {
                            final _contact = _contacts[index];
                            return ListTile(
                              title: Text(_contact.fullname),
                              subtitle: const Text(''),
                              dense: true,
                              trailing: Column(
                                children: [
                                  const SizedBox(height: 8.0,),
                                  Text('SĐT: ${_contact.phoneNumber}', style: const TextStyle(fontSize: 12.0)),
                                  const SizedBox(height: 5.0,),
                                  Text('Email: ${_contact.email}', style: const TextStyle(fontSize: 12.0)),
                                ],
                              ),
                              onTap: (){
                                Navigator.pop(context, _contact);
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(
                              height: 1,
                              thickness: 2,
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
                "Lọc theo khác hàng",
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

    setState(() {
      _contacts.addAll(contactList);
      _maxPages = _contacts[0].maxPage!;
    });
  }

  void _searchContactByNameOrEmail({required Account currentAccount, required String query}) async {
    List<Contact> contactList = await ContactListViewModel().searchNameAndEmail(currentAccount: currentAccount, query: query);

    setState(() {
      _contacts.clear();
      _contacts.addAll(contactList);
    });
  }

}
