import 'package:flutter/material.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/department_list_view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AdminDepartmentFilter extends StatefulWidget {
  const AdminDepartmentFilter({Key? key, required this.departmentList}) : super(key: key);

  final List<Department> departmentList;

  @override
  State<AdminDepartmentFilter> createState() => _AdminDepartmentFilterState();
}

class _AdminDepartmentFilterState extends State<AdminDepartmentFilter> {

  late List<Department> _departments = widget.departmentList;

  final RefreshController _refreshController = RefreshController();
  final TextEditingController _searchDepartmentName = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _searchDepartmentName.dispose();
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
                    controller: _searchDepartmentName,
                    showCursor: true,
                    cursorColor: Colors.black,
                    onSubmitted: (value){
                      setState(() {
                        _departments.clear();
                      });

                    },
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search,
                        color: Colors.blueGrey,
                      ),
                      suffixIcon: _searchDepartmentName.text.isNotEmpty ? IconButton(
                        onPressed: (){
                          setState(() {
                            _departments.clear();
                            _departments = widget.departmentList;
                          });
                          _refreshController.resetNoData();
                          _searchDepartmentName.clear();
                        },
                        icon: const Icon(Icons.clear),
                      ) : null,
                      hintText: "Tìm theo tên phòng ban",
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
                      enablePullDown: false,
                      onLoading: () async {
                        _refreshController.loadNoData();
                      },
                      child: _departments.isNotEmpty ? ListView.builder(
                          itemBuilder: (context, index) {
                            final department = _departments[index];
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.pop(context, department);
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
                                              const Text('Tên phòng ban:'),
                                              const Spacer(),
                                              Text(department.name),
                                            ],
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                                          child: Row(
                                            children: <Widget>[
                                              const Text('Thuộc khối:'),
                                              const Spacer(),
                                              Text(blockNameUtilities[department.blockId]),
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
                          itemCount: _departments.length
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
                "Lọc theo tên phòng ban",
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

  // void _getAllDepartment() async {
  //   List<Department> departmentList = await DepartmentListViewModel().getAllDepartment();
  //
  //   setState(() {
  //     _departments.addAll(departmentList);
  //   });
  //     _refreshController.loadNoData();
  // }
}
