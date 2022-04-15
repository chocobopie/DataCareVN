import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/role.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/role_list_view_model.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AdminRoleFilter extends StatefulWidget {
  const AdminRoleFilter({Key? key, this.isAccountDetailFilter, this.isAdminFilter, this.isHrManagerFilter}) : super(key: key);

  final bool? isAccountDetailFilter;
  final bool? isAdminFilter;
  final bool? isHrManagerFilter;

  @override
  State<AdminRoleFilter> createState() => _AdminRoleFilterState();
}

class _AdminRoleFilterState extends State<AdminRoleFilter> {

  late final List<Role> _roles = [];

  final RefreshController _refreshController = RefreshController();
  final TextEditingController _searchRoleName = TextEditingController();

  Account _currentAccount = Account();

  @override
  void initState() {
    super.initState();
    _getallRoles();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _searchRoleName.dispose();
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
                    controller: _searchRoleName,
                    showCursor: true,
                    cursorColor: Colors.black,
                    onSubmitted: (value){
                      setState(() {
                        _roles.clear();
                      });
                      _getallRoles();
                    },
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search,
                        color: Colors.blueGrey,
                      ),
                      suffixIcon: _searchRoleName.text.isNotEmpty ? IconButton(
                        onPressed: (){
                          setState(() {
                            _roles.clear();
                          });
                          _refreshController.resetNoData();
                          _searchRoleName.clear();
                          _getallRoles();
                        },
                        icon: const Icon(Icons.clear),
                      ) : null,
                      hintText: "Tìm theo tên chức vụ",
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
                        setState(() {
                          _roles.clear();
                        });
                        _getallRoles();
                        if(_roles.isNotEmpty){
                          _refreshController.refreshCompleted();
                        }else{
                          _refreshController.refreshFailed();
                        }
                      },
                      child: _roles.isNotEmpty ? ListView.builder(
                          itemBuilder: (context, index) {
                            final role = _roles[index];
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.pop(context, role);
                                },
                                child: Card(
                                  elevation: 10.0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                                          child: Row(
                                            children: <Widget>[
                                              const Text('Chức vụ:'),
                                              const Spacer(),
                                              Text(role.name),
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
                          itemCount: _roles.length
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
                "Lọc theo chức vụ",
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

  void _getallRoles() async {

    List<Role> roleList = await RoleListViewModel().getAllRole();
    if(widget.isAccountDetailFilter == true){
      for(int i = 0; i < roleList.length; i++){
        if(roleList[i].name == 'Quản trị viên') {
          roleList.removeAt(i);
        }
        if(roleList[i].name == 'Trưởng phòng nhân sự') {
          roleList.removeAt(i);
        }
        if(roleList[i].name == 'Thực tập sinh nhân sự') {
          roleList.removeAt(i);
        }
        if(roleList[i].name == 'Nhân viên kỹ thuật') {
          roleList.removeAt(i);
        }
      }
    }else if(widget.isAdminFilter == true){
      for(int i = 0; i < roleList.length; i++){
        if(roleList[i].name == 'Quản trị viên') {
          roleList.removeAt(i);
        }
      }
    }else if(widget.isHrManagerFilter == true){
      for(int i = 0; i < roleList.length; i++){
        if(roleList[i].name == 'Quản trị viên') {
          roleList.removeAt(i);
        }
        if(roleList[i].name == 'Trưởng phòng nhân sự') {
          roleList.removeAt(i);
        }
      }
    }

    setState(() {
      _roles.addAll(roleList);
    });
    _refreshController.loadNoData();
  }
}
