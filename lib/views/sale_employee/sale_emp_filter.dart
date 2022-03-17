import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/account_list_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SaleEmpFilter extends StatefulWidget {
  const SaleEmpFilter({Key? key}) : super(key: key);

  @override
  State<SaleEmpFilter> createState() => _SaleEmpFilterState();
}

class _SaleEmpFilterState extends State<SaleEmpFilter> {

  int _currentPage = 0, _maxPages = 0;
  final RefreshController _refreshController = RefreshController();
  late final List<Account> _salesEmployees = [];
  late Account currentAccount;
  final TextEditingController _searchEmployeeName = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _filterSaleEmployee(isRefresh: true);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _searchEmployeeName.dispose();
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
                        controller: _searchEmployeeName,
                        showCursor: true,
                        cursorColor: Colors.black,
                        onSubmitted: (value){
                          if(_salesEmployees.isNotEmpty){
                            _salesEmployees.clear();
                          }
                          _currentPage = 0;
                          _getAccountsByFullname(isRefresh: true, currentPage: _currentPage, departmentId: currentAccount.departmentId!, blockId:  currentAccount.blockId!, fullname: _searchEmployeeName.text);
                        },
                        decoration: InputDecoration(
                          icon: const Icon(Icons.search,
                            color: Colors.blueGrey,
                          ),
                          suffixIcon: _searchEmployeeName.text.isNotEmpty ? IconButton(
                            onPressed: (){
                              setState(() {
                                _salesEmployees.clear();
                              });
                              _refreshController.resetNoData();
                              _searchEmployeeName.clear();
                              _filterSaleEmployee(isRefresh: true);
                            },
                            icon: const Icon(Icons.clear),
                          ) : null,
                          hintText: "Tìm theo tên nhân viên",
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
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    onRefresh: () async{
                      if(_salesEmployees.isNotEmpty){
                        _salesEmployees.clear();
                      }
                      _currentPage = 0;
                      _refreshController.resetNoData();
                      if(_searchEmployeeName.text.isNotEmpty){
                        _getAccountsByFullname(isRefresh: true, currentPage: _currentPage, departmentId:  currentAccount.departmentId!, blockId:  currentAccount.blockId!, fullname: _searchEmployeeName.text);
                      }else{
                        _filterSaleEmployee(isRefresh: true);
                      }

                      if(_salesEmployees.isNotEmpty){
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
                        if(_searchEmployeeName.text.isNotEmpty){
                          _getAccountsByFullname(isRefresh: false, currentPage: _currentPage, departmentId:  currentAccount.departmentId!, blockId:  currentAccount.blockId!, fullname: _searchEmployeeName.text);
                        }else{
                          _filterSaleEmployee(isRefresh: false);
                        }
                      }

                      if(_salesEmployees.isNotEmpty){
                        _refreshController.loadComplete();
                      }else{
                        _refreshController.loadFailed();
                      }
                    },
                    child: _salesEmployees.isNotEmpty ? ListView.separated(
                        itemBuilder: (context, index) {
                          final _account = _salesEmployees[index];
                          return ListTile(
                            title: Text(_account.fullname!),
                            subtitle: Text(rolesNameUtilities[_account.roleId!]),
                            dense: true,
                            trailing: Column(
                              children: [
                                const SizedBox(height: 8.0,),
                                Text('SĐT: ${_account.phoneNumber}', style: const TextStyle(fontSize: 12.0)),
                                if(_account.teamId != null) const SizedBox(height: 5.0,),
                                if(_account.teamId != null) Text('Nhóm: ${teams[_account.teamId!].name}', style: const TextStyle(fontSize: 12.0)),
                              ],
                            ),
                            onTap: (){
                              Navigator.pop(context, _account);
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 1,
                            thickness: 2,
                          );
                        },
                        itemCount: _salesEmployees.length
                    ) : const Center(child: CircularProgressIndicator())
                  )
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
                "Lọc theo nhân viên",
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

  void _filterSaleEmployee({required bool isRefresh}){
    if(currentAccount.roleId == 4 || currentAccount.roleId == 5){
      _getAllSalesEmployeesByBlockIdDepartmentIdOrTeamId(isRefresh: isRefresh, currentPage: _currentPage, blockId: currentAccount.blockId!, departmentId:  currentAccount.departmentId!, teamId: currentAccount.teamId);
    }else{
      _getAllSalesEmployeesByBlockIdDepartmentIdOrTeamId(isRefresh: isRefresh, currentPage: _currentPage, blockId: currentAccount.blockId!, departmentId:  currentAccount.departmentId!);
    }
  }

  void _getAllSalesEmployeesByBlockIdDepartmentIdOrTeamId({required bool isRefresh, required int currentPage, required int blockId, required int departmentId, int? teamId}) async {
    List<Account> accountList = await AccountListViewModel().getAllSalesEmployeesByBlockIdDepartmentIdOrTeamId(isRefresh: isRefresh, currentPage: currentPage, blockId: blockId, departmentId: departmentId, teamId: teamId);

    if(accountList.isNotEmpty){
      setState(() {
        _salesEmployees.addAll(accountList);
        _maxPages = _salesEmployees[0].maxPage!;
      });
    }else{
      _refreshController.loadNoData();
    }
  }

  void _getAccountsByFullname({required bool isRefresh, required int currentPage, required int departmentId, required int blockId, required String fullname}) async {
    List<Account> accountList = await AccountListViewModel().getAccountsByFullname(isRefresh: isRefresh, currentPage: currentPage, departmentId: departmentId, blockId: blockId, fullname: fullname);

    if(accountList.isNotEmpty){
      setState(() {
        _salesEmployees.addAll(accountList);
        _maxPages = _salesEmployees[0].maxPage!;
      });
    }else{
      _refreshController.loadNoData();
    }

  }


}
