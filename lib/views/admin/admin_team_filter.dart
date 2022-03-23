import 'package:flutter/material.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/team_list_view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AdminTeamFilter extends StatefulWidget {
  const AdminTeamFilter({Key? key, required this.teamList}) : super(key: key);

  final List<Team> teamList;

  @override
  State<AdminTeamFilter> createState() => _AdminTeamFilterState();
}

class _AdminTeamFilterState extends State<AdminTeamFilter> {

  late List<Team> _teams = widget.teamList;

  final RefreshController _refreshController = RefreshController();
  final TextEditingController _searchTeamName = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _searchTeamName.dispose();
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
                    controller: _searchTeamName,
                    showCursor: true,
                    cursorColor: Colors.black,
                    onSubmitted: (value){
                      setState(() {
                        _teams.clear();
                      });
                      _teams = widget.teamList;
                    },
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search,
                        color: Colors.blueGrey,
                      ),
                      suffixIcon: _searchTeamName.text.isNotEmpty ? IconButton(
                        onPressed: (){
                          setState(() {
                            _teams.clear();
                          });
                          _refreshController.resetNoData();
                          _searchTeamName.clear();
                          _teams = widget.teamList;
                        },
                        icon: const Icon(Icons.clear),
                      ) : null,
                      hintText: "Tìm theo tên của nhóm",
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
                      child: _teams.isNotEmpty ? ListView.builder(
                          itemBuilder: (context, index) {
                            final team = _teams[index];
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.pop(context, team);
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
                                              const Text('Tên nhóm:'),
                                              const Spacer(),
                                              Text(team.name),
                                            ],
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                                          child: Row(
                                            children: <Widget>[
                                              const Text('Thuộc phòng:'),
                                              const Spacer(),
                                              Text(getDepartmentName(team.departmentId, null)),
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
                          itemCount: _teams.length
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
                "Lọc theo tên nhóm",
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

  // void _getAllTeams() async {
  //   List<Team> teamList = await TeamListViewModel().getAllTeams();
  //     setState(() {
  //       _teams.addAll(teamList);
  //     });
  //   _refreshController.loadNoData();
  // }
}
