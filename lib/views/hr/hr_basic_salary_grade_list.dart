import 'package:flutter/material.dart';
import 'package:login_sample/models/basic_salary_by_grade.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/basic_salary_grade_list_view_model.dart';

class HrBasicSalaryGradeList extends StatefulWidget {
  const HrBasicSalaryGradeList({Key? key}) : super(key: key);

  @override
  State<HrBasicSalaryGradeList> createState() => _HrBasicSalaryGradeListState();
}

class _HrBasicSalaryGradeListState extends State<HrBasicSalaryGradeList> {

  final List<BasicSalaryByGrade> _listBasicSalaryGrade = [];

  @override
  void initState() {
    super.initState();
    _getBasicSalaryByGrade();
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
              height: MediaQuery.of(context).size.height * 0.3),
          Card(
              elevation: 20.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  )
              ),
              margin: const EdgeInsets.only(top: 100.0),
              child: _listBasicSalaryGrade.isNotEmpty ? ListView.builder(
                itemCount: _listBasicSalaryGrade.length,
                itemBuilder: (context, index){
                  final _basicSalaryGrade = _listBasicSalaryGrade[index];
                  return Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Card(
                        elevation: 10.0,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))
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
                              )
                            ],
                          ),
                        ),
                      )
                  );
                },
              ) : const Center(child: CircularProgressIndicator())),

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

  void _getBasicSalaryByGrade() async {
    List<BasicSalaryByGrade>? result = await BasicSalaryGradeListViewModel().getListBasicSalaryByGrade();

    if(result!.isNotEmpty){
      setState(() {
        _listBasicSalaryGrade.addAll(result);
      });
    }
  }
}
