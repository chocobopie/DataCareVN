import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/view_models/account_list_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:provider/provider.dart';
import 'admin_account_add.dart';

class AdminAccountList extends StatefulWidget {
  const AdminAccountList({Key? key}) : super(key: key);

  @override
  _AdminAccountListState createState() => _AdminAccountListState();
}

class _AdminAccountListState extends State<AdminAccountList> {

  late final List<Account> _accounts = [];
  bool _isSearching = false;
  late Account _currentAccount;
  final int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getAllAccount(isRefresh: true, currentPage: _currentPage, accountId: _currentAccount.accountId!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var account = Provider.of<AccountProvider>(context).account;
    return Scaffold(
       floatingActionButton: account.roleId == 0 ? FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const AdminAccountAdd(),
          ));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.plus_one),
      ) : null,
      body: Stack(
        children: <Widget>[
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomCenter,
                      colors: [mainBgColor, mainBgColor])),
              height: MediaQuery.of(context).size.height * 0.15),
          Card(
            elevation: 20.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            margin: const EdgeInsets.only(top: 90.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                  child: Column(
                    children: <Widget>[
                      const Text('LỌC THEO', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                      Row(
                        children: const <Widget>[
                          Expanded(
                            child: CustomOutlinedButton(
                                title: 'Khối',
                                radius: 30.0,
                                color: mainBgColor
                            ),
                          ),

                          Expanded(
                            child: CustomOutlinedButton(
                                title: 'Phòng ban',
                                radius: 30.0,
                                color: mainBgColor
                            ),
                          ),

                          Expanded(
                            child: CustomOutlinedButton(
                                title: 'Nhóm',
                                radius: 30,
                                color: mainBgColor
                            ),
                          ),

                          Expanded(
                            child: CustomOutlinedButton(
                                title: 'Chức vụ',
                                radius: 30,
                                color: mainBgColor
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 0.0,
                right: 0.0,
                top: MediaQuery.of(context).size.height * 0.22),
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

                  child: _accounts.isNotEmpty ? ListView.builder(
                      itemBuilder: (context, index) {
                        final account = _accounts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
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
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(account.fullname!, style: const TextStyle(fontSize: 20.0),),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(blockNameUtilities[account.blockId!]),
                                      ],
                                    ),
                                  ),
                                  if(account.departmentId != null) Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(getDepartmentName(account.departmentId!, account.blockId))
                                      ],
                                    ),
                                  ),
                                  if(account.teamId != null) Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(getTeamName(account.teamId!, account.departmentId!))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(rolesNameUtilities[account.roleId!]),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        const Spacer(),
                                        Text(account.email!),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: _accounts.length,
                      ) : const Center(child: CircularProgressIndicator())
                  )
              ),
            ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.blueGrey,
              ), // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: !_isSearching
                  ? const Text(
                "Danh sách nhân viên",
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              )
                  : const TextField(
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
                showCursor: true,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Colors.blueGrey,
                  ),
                  hintText: "Tìm theo tên",
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              actions: <Widget>[
                _isSearching
                    ? IconButton(
                  icon: const Icon(
                    Icons.cancel,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                    });
                  },
                )
                    : IconButton(
                  icon: const Icon(
                    Icons.search,
                  ),
                  onPressed: () {
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

  void _getAllAccount({required bool isRefresh, required int currentPage, required int accountId}) async {
    List<Account> accountList = await AccountListViewModel().getAllAccount(isRefresh: isRefresh, currentPage: currentPage, accountId: accountId);

    if(accountList.isNotEmpty){
      setState(() {
        _accounts.addAll(accountList);
      });
    }
  }

}
