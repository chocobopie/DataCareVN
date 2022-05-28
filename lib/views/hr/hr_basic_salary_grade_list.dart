import 'package:flutter/material.dart';
import 'package:login_sample/models/basic_salary_by_grade.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/basic_salary_grade_list_view_model.dart';
import 'package:login_sample/views/hr/hr_basic_salary_add_new.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HrBasicSalaryGradeList extends StatefulWidget {
  const HrBasicSalaryGradeList({Key? key}) : super(key: key);

  @override
  State<HrBasicSalaryGradeList> createState() => _HrBasicSalaryGradeListState();
}

class _HrBasicSalaryGradeListState extends State<HrBasicSalaryGradeList> {

  final List<BasicSalaryByGrade> _listBasicSalaryGrade = [];
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _getListBasicSalaryByGrade();
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
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const HrBasicSalaryAddNew(),
                  )).then((value) => _onGoBack());
                },
                backgroundColor: mainBgColor,
                child: const Icon(Icons.add),
              ),
            ),
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
              height: MediaQuery.of(context).size.height * 0.3),
          Card(
              elevation: 20.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  )
              ),
              margin: const EdgeInsets.only(top: 100.0),
              child: Column(
                children: <Widget>[
                _listBasicSalaryGrade.isNotEmpty ? Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    onRefresh: () async {
                      setState(() {
                        _listBasicSalaryGrade.clear();
                      });
                      _getListBasicSalaryByGrade();

                      if(_listBasicSalaryGrade.isNotEmpty){
                        _refreshController.refreshCompleted();
                      }else{
                        _refreshController.refreshFailed();
                      }
                    },
                    child: ListView.builder(
                        itemCount: _listBasicSalaryGrade.length,
                        itemBuilder: (context, index){
                          final _basicSalaryGrade = _listBasicSalaryGrade[index];
                          return Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Card(
                                elevation: 10.0,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    )
                                ),
                                child: Theme(
                                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    title: const Text('Mức lương tương ứng cấp bậc:', style: TextStyle(fontSize: 12.0),),
                                    trailing: Text('${moneyFormat(_basicSalaryGrade.basicSalary.toString())}đ', style: const TextStyle(fontSize: 14.0),),
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 4.0),
                                              child: Row(
                                                children: <Widget>[
                                                  const Text('KPI:', style: TextStyle(fontSize: 12.0),),
                                                  const Spacer(),
                                                  Text('${moneyFormat(_basicSalaryGrade.kpi.toString())}đ', style: const TextStyle(fontSize: 14.0),),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 4.0),
                                              child: Row(
                                                children: <Widget>[
                                                  const Text('Trợ cấp:', style: TextStyle(fontSize: 12.0),),
                                                  const Spacer(),
                                                  Text('${moneyFormat(_basicSalaryGrade.allowance.toString())}đ', style: const TextStyle(fontSize: 14.0),),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              bool result = await _deleteABasicSalaryGrade(_basicSalaryGrade.basicSalaryByGradeId);
                                              if(result == true){
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Xóa mức lương ${moneyFormat(_basicSalaryGrade.basicSalary.toString())}đ thành công')),
                                                );
                                                _getListBasicSalaryByGrade();
                                              }else{
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Xóa mức lương ${moneyFormat(_basicSalaryGrade.basicSalary.toString())}đ thất bại')),
                                                );
                                              }
                                            },
                                            icon: const Icon(Icons.delete_forever, color: Colors.red,),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: (){},
                                            icon: const Icon(Icons.edit, color: Colors.green,),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          );
                        },
                      ),
                  ),
                ) : const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                ],
              )),

          // Text('${moneyFormat(_basicSalaryGrade.basicSalary.toString())}đ', style: const TextStyle(fontSize: 14.0),),

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
              title: const Text(
                "Lương theo cấp bậc",
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

  void _getListBasicSalaryByGrade() async {
    setState(() {
      _listBasicSalaryGrade.clear();
    });

    List<BasicSalaryByGrade>? result = await BasicSalaryGradeListViewModel().getListBasicSalaryByGrade();

    if(result!.isNotEmpty){
      setState(() {
        _listBasicSalaryGrade.addAll(result);
        _refreshController.loadNoData();
      });
    }else{
      _refreshController.loadNoData();
    }
  }
  
  void _onGoBack() async {
    _getListBasicSalaryByGrade();
  }

  Future<bool> _deleteABasicSalaryGrade(int id) async {
    bool result = await BasicSalaryGradeListViewModel().deleteABasicSalaryGrade(id);
    return result;
  }
}
