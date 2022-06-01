import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/block.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/models/role.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/account_list_view_model.dart';
import 'package:login_sample/view_models/department_list_view_model.dart';
import 'package:login_sample/view_models/team_list_view_model.dart';
import 'package:login_sample/views/admin/admin_account_detail.dart';
import 'package:login_sample/views/admin/admin_block_filter.dart';
import 'package:login_sample/views/admin/admin_department_filter.dart';
import 'package:login_sample/views/admin/admin_role_filter.dart';
import 'package:login_sample/views/admin/admin_team_filter.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HrPromoteDemoteAccountList extends StatefulWidget {
  const HrPromoteDemoteAccountList({Key? key}) : super(key: key);

  @override
  State<HrPromoteDemoteAccountList> createState() => _HrPromoteDemoteAccountListState();
}

class _HrPromoteDemoteAccountListState extends State<HrPromoteDemoteAccountList> {

  late final List<Account> _accounts = [];
  bool _isSearching = false;
  late Account _currentAccount;
  late int _currentPage = 0, _maxPages = 0;
  final RefreshController _refreshController = RefreshController();
  String _blockNameString = 'Tên khối', _departmentNameString = 'Tên phòng' , _teamNameString = 'Tên nhóm', _roleNameString = 'Chức vụ', _searchString = '';

  Block? _blockFilter;
  Team? _teamFilter;
  Department? _departmentFilter;
  Role? _roleFilter;

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getAllPromotedAccount(isRefresh: true, currentPage: 0);
    _onGoBackGetDepartmentList();
    _onGoBackGetTeamList();
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
      floatingActionButton: Card(
        elevation: 10.0,
        child: _maxPages > 0 ? NumberPaginator(
          numberPages: _maxPages,
          buttonSelectedBackgroundColor: mainBgColor,
          onPageChange: (int index) {
            setState(() {
              if(index >= _maxPages){
                index = 0;
                _currentPage = index;
              }else{
                _currentPage = index;
              }
              _accounts.clear();
            });
            _getAllPromotedAccount(isRefresh: false, currentPage: _currentPage);

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
                  padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                  child: Column(
                    children: <Widget>[
                      const Text('Lọc theo', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                      const SizedBox(height: 5.0,),
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
                                    _roleFilter = null;
                                    _departmentNameString = 'Tên phòng';
                                    _teamNameString = 'Tên nhóm';
                                    _roleNameString = 'Chức vụ';
                                    _accounts.clear();
                                    _blockNameString = _blockFilter!.name;
                                    _maxPages = _currentPage = 0;
                                  });
                                }

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
                                        _maxPages = _currentPage = 0;
                                      });
                                    }

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
                                        _maxPages = _currentPage = 0;
                                      });
                                    }

                                  },
                                ),

                            CustomOutlinedButton(
                              title: _roleNameString,
                              radius: 10,
                              color: mainBgColor,
                              onPressed: () async {
                                final data = await Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const AdminRoleFilter(isAdminFilter: true,)
                                ));
                                if(data != null){
                                  _roleFilter = data;
                                  setState(() {
                                    _accounts.clear();
                                    _roleNameString = ('Chức vụ: ${_roleFilter!.name}' ) ;
                                    _maxPages = _currentPage = 0;
                                  });
                                }

                              },
                            ),
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
                                  _maxPages = _currentPage = 0;
                                });
                                _refreshController.resetNoData();

                                _onGoBackGetDepartmentList();
                                _onGoBackGetTeamList();
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
          _maxPages >= 0 ? Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.22),
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
                      _getAllPromotedAccount(isRefresh: false, currentPage: _currentPage);

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
                              )).then((value) => _onGoBack());
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
                                          SizedBox(
                                            height: 20.0, width: MediaQuery.of(context).size.width * 0.5,
                                            child: Align( alignment: Alignment.centerRight,child: Text(account.fullname!, overflow: TextOverflow.ellipsis, softWrap: false,)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Text('Khối', style: TextStyle(fontSize: 12.0),),
                                          const Spacer(),
                                          Text(blockNames[account.blockId!]),
                                        ],
                                      ),
                                    ),
                                    if(account.departmentId != null) Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Text('Phòng:', style: TextStyle(fontSize: 12.0),),
                                          const Spacer(),
                                          Text(getDepartmentName(account.departmentId!, null))
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
                                          Text(rolesNames[account.roleId!]),
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
              ),
            ),
          ) : const Center(child: Text('Không có dữ liệu')),
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
                  : TextField(
                style: const TextStyle(color: Colors.blueGrey,),
                showCursor: true,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.blueGrey,),
                  hintText: "Tìm theo tên của nhân viên",
                  hintStyle: TextStyle(color: Colors.blueGrey,),
                ),
                onSubmitted: (value){
                  setState(() {
                    _accounts.clear();
                  });
                  _currentPage = 0;
                  _searchString = value.toString();
                  _getAllPromotedAccount(isRefresh: true, currentPage: _currentPage);
                },
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
                      _accounts.clear();
                      _blockNameString = 'Tên khối';
                      _departmentNameString = 'Tên phòng';
                      _teamNameString = 'Tên nhóm';
                      _roleNameString = 'Chức vụ';
                      _blockFilter = null;
                      _departmentFilter = null;
                      _teamFilter = null;
                      _roleFilter = null;
                      _searchString = '';
                    });
                    
                  },
                )
                    : IconButton(
                  icon: const Icon(Icons.search,),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                      _accounts.clear();
                      _blockNameString = 'Tên khối';
                      _departmentNameString = 'Tên phòng';
                      _teamNameString = 'Tên nhóm';
                      _roleNameString = 'Chức vụ';
                      _blockFilter = null;
                      _departmentFilter = null;
                      _teamFilter = null;
                      _roleFilter = null;
                      _searchString = '';
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

  void _getAllPromotedAccount({required bool isRefresh, required currentPage,}) async {
    _accounts.clear();

    List<Account> accountList = await AccountListViewModel().getAllPromotedAccounts(
        isRefresh: isRefresh, currentPage: currentPage, blockId: _blockFilter!.blockId,
        departmentId: _departmentFilter!.departmentId, teamId: _teamFilter!.teamId,
        roleId: _roleFilter!.roleId, limit: 10, search: _searchString
    );

    if(accountList.isNotEmpty){
      setState(() {
        _accounts.addAll(accountList);
        _maxPages = _accounts[0].maxPage!;
      });
    }else{
      setState(() {
        _maxPages = -1;
      });
    }
  }

  void _getAllDemotedAccount({required bool isRefresh, required currentPage, int? blockId, int? departmentId, int? teamId, int? roleId, String? search, int? limit}) async {
    _accounts.clear();

    List<Account> accountList = await AccountListViewModel().getAllDemotedAccounts(
        isRefresh: isRefresh, currentPage: currentPage, blockId: _blockFilter!.blockId,
        departmentId: _departmentFilter!.departmentId, teamId: _teamFilter!.teamId,
        roleId: _roleFilter!.roleId, limit: 10, search: _searchString
    );

    if(accountList.isNotEmpty){
      setState(() {
        _accounts.addAll(accountList);
        _maxPages = _accounts[0].maxPage!;
      });
    }else{
      setState(() {
        _maxPages = -1;
      });
    }
  }

  void _onGoBackGetDepartmentList() async {
    departments = await DepartmentListViewModel().getAllDepartment();
  }

  void _onGoBackGetTeamList() async {
    teams = await TeamListViewModel().getAllTeams();
  }

  void _onGoBack(){
    _getAllPromotedAccount(isRefresh: false, currentPage: _currentPage);
  }
}
