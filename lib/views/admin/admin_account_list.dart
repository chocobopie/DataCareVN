import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/block.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/models/role.dart';
import 'package:login_sample/models/sort_item.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/view_models/account_list_view_model.dart';
import 'package:login_sample/views/admin/admin_account_detail.dart';
import 'package:login_sample/views/admin/admin_block_filter.dart';
import 'package:login_sample/views/admin/admin_department_filter.dart';
import 'package:login_sample/views/admin/admin_role_filter.dart';
import 'package:login_sample/views/admin/admin_team_filter.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  late int _currentPage = 0, _maxPages = 0;
  final RefreshController _refreshController = RefreshController();
  String _blockNameString = 'Tên khối', _departmentNameString = 'Tên phòng' , _teamNameString = 'Tên nhóm', _roleNameString = 'Chức vụ';

  Block? _blockFilter;
  Team? _teamFilter;
  Department? _departmentFilter;
  Role? _roleFilter;

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getFilter(isRefresh: true);
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
           if(_currentAccount.roleId == 0)
           Padding(
             padding: const EdgeInsets.only(left: 10.0),
             child: Align(
               alignment: Alignment.bottomLeft,
               child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const AdminAccountAdd(),
                  ));
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
                   _accounts.clear();
                 });
                 // _getAllAccount(isRefresh: false, currentPage: _currentPage, accountId: _currentAccount.accountId!);
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
                  padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                  child: Column(
                    children: <Widget>[
                      const Text('Lọc theo', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                      const SizedBox(height: 10.0,),
                      SizedBox(
                        height: 40.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            CustomOutlinedButton(
                                title: _blockNameString,
                                radius: 10.0,
                                color: mainBgColor,
                                onPressed: () async {
                                  final data = await Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const AdminBlockFilter()
                                  ));
                                  if(data != null){
                                    _blockFilter = data;
                                    setState(() {
                                      _departmentFilter = null;
                                      _teamFilter = null;
                                      _departmentNameString = 'Tên phòng';
                                      _teamNameString = 'Tên nhóm';
                                      _accounts.clear();
                                      _blockNameString = _blockFilter!.name;
                                    });
                                  }
                                  _getFilter(isRefresh: true);
                                },
                            ),

                            if( _blockFilter != null )
                              if( getDepartmentListInBlock(block: _blockFilter!).isNotEmpty )
                                CustomOutlinedButton(
                                  title: _departmentNameString,
                                  radius: 10.0,
                                  color: mainBgColor,
                                  onPressed: () async {
                                    final data = await Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => AdminDepartmentFilter(departmentList: getDepartmentListInBlock(block: _blockFilter!),)
                                    ));
                                    if(data != null){
                                      _departmentFilter = data;
                                      setState(() {
                                        _teamFilter = null;
                                        _teamNameString = 'Tên nhóm';
                                        _accounts.clear();
                                        _departmentNameString = _departmentFilter!.name;
                                      });
                                    }
                                    _getFilter(isRefresh: true);
                                  },
                                ),


                            if(_departmentFilter != null)
                              if( getTeamListInDepartment(department: _departmentFilter!).isNotEmpty )
                              CustomOutlinedButton(
                                title: _teamNameString,
                                radius: 10,
                                color: mainBgColor,
                                onPressed: () async {
                                  final data = await Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => AdminTeamFilter(teamList: getTeamListInDepartment(department: _departmentFilter!),)
                                  ));
                                  if(data != null){
                                    _teamFilter = data;
                                    setState(() {
                                      _accounts.clear();
                                      _teamNameString = _teamFilter!.name;
                                    });
                                  }
                                  _getFilter(isRefresh: true);
                                },
                            ),

                            CustomOutlinedButton(
                                title: _roleNameString,
                                radius: 10,
                                color: mainBgColor,
                                onPressed: () async {
                                  final data = await Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const AdminRoleFilter(isHrManagerFilter: true,)
                                  ));
                                  if(data != null){
                                    _roleFilter = data;
                                    setState(() {
                                      _accounts.clear();
                                      _roleNameString = ('Chức vụ: ${_roleFilter!.name}' ) ;
                                    });
                                  }
                                  _getFilter(isRefresh: true);
                                },
                            ),
                            // DropdownButton2(
                            //   customButton: const Icon(
                            //     Icons.sort,
                            //     size: 40,
                            //     color: mainBgColor,
                            //   ),
                            //   items: [
                            //     ...SortItems.firstItems.map(
                            //           (item) =>
                            //           DropdownMenuItem<SortItem>(
                            //             value: item,
                            //             child: SortItems.buildItem(item),
                            //           ),
                            //     ),
                            //   ],
                            //   onChanged: (value) {
                            //   },
                            //   itemHeight: 40,
                            //   itemPadding: const EdgeInsets.only(left: 5, right: 5),
                            //   dropdownWidth: 250,
                            //   dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                            //   dropdownDecoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(25),
                            //     color: mainBgColor,
                            //   ),
                            //   dropdownElevation: 8,
                            //   offset: const Offset(0, 8),
                            // ),
                            IconButton(
                              icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,),
                              onPressed: () {
                                setState(() {
                                  _blockNameString = 'Tên khối';
                                  _departmentNameString = 'Tên phòng';
                                  _teamNameString = 'Tên nhóm';
                                  _roleNameString = 'Chức vụ';
                                  _blockFilter = null;
                                  _departmentFilter = null;
                                  _teamFilter = null;
                                  _roleFilter = null;
                                  _accounts.clear();
                                });
                                _refreshController.resetNoData();
                                // _getAllAccount(isRefresh: true, currentPage: _currentPage, accountId: _currentAccount.accountId!);
                                _getFilter(isRefresh: false);
                              },
                            ),
                          ],
                        ),
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
                top: MediaQuery.of(context).size.height * 0.23),
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

                  child: _accounts.isNotEmpty ? SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    onRefresh: () async {
                      setState(() {
                        _accounts.clear();
                      });
                      // _getAllAccount(isRefresh: false, currentPage: _currentPage, accountId: _currentAccount.accountId!);
                      _getFilter(isRefresh: false);

                      if(_accounts.isNotEmpty){
                        _refreshController.refreshCompleted();
                      }else{
                        _refreshController.refreshFailed();
                      }
                    },
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          final account = _accounts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AdminAccountDetail(account: account)
                                ));
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
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Expanded(child: Text('Tên nhân viên:', style: TextStyle(fontSize: 12.0),)),
                                            const Spacer(),
                                            Text(account.fullname!, style: const TextStyle(fontSize: 20.0),),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Text('Khối', style: TextStyle(fontSize: 12.0),),
                                            const Spacer(),
                                            Text(blockNameUtilities[account.blockId!]),
                                          ],
                                        ),
                                      ),
                                      if(account.departmentId != null) Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Text('Phòng:', style: TextStyle(fontSize: 12.0),),
                                            const Spacer(),
                                            Text(getDepartmentName(account.departmentId!, account.blockId))
                                          ],
                                        ),
                                      ),
                                      if(account.teamId != null) Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Text('Nhóm:', style: TextStyle(fontSize: 12.0),),
                                            const Spacer(),
                                            Text(getTeamName(account.teamId!, account.departmentId!))
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Text('Chức vụ:', style: TextStyle(fontSize: 12.0),),
                                            const Spacer(),
                                            Text(rolesNameUtilities[account.roleId!]),
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
                        itemCount: _accounts.length,
                        ),
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
                  hintText: "Tìm theo tên của nhân viên",
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
                    setState(() {_isSearching = false;});
                  },
                )
                    : IconButton(
                  icon: const Icon(Icons.search,),
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

  void _getFilter({required bool isRefresh}){
    _getAllAccount(isRefresh: isRefresh, currentPage: _currentPage, accountId: _currentAccount.accountId!,
        blockId: _blockFilter != null ?_blockFilter!.blockId : null,
        departmentId: _departmentFilter != null ? _departmentFilter!.departmentId : null,
        teamId: _teamFilter != null ? _teamFilter!.teamId : null,
        roleId: _roleFilter != null ? _roleFilter!.roleId : null
    );
  }

  void _getAllAccount({required bool isRefresh, required currentPage, required int accountId, int? blockId, int? departmentId, int? teamId, int? roleId}) async {
    List<Account> accountList = await AccountListViewModel()
        .getAllAccount(isRefresh: isRefresh, currentPage: currentPage, accountId: accountId, blockId: blockId, departmentId: departmentId, teamId: teamId, roleId: roleId
    );

    if(accountList.isNotEmpty){
      setState(() {
        _accounts.clear();
        _accounts.addAll(accountList);
      });
      _maxPages = _accounts[0].maxPage!;
    }else{
      setState(() {
        _refreshController.loadNoData();
      });
    }
  }

}

class SortItems {
  static const List<SortItem> firstItems = [asc, des];

  static const asc = SortItem(text: 'Theo tên nhân viên từ A-z', icon: Icons.sort_by_alpha_rounded);
  static const des = SortItem(text: 'Theo tên nhân viên từ Z-a', icon: Icons.sort_by_alpha_rounded);


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