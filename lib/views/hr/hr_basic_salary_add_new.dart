import 'package:flutter/material.dart';
import 'package:login_sample/models/basic_salary_by_grade.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/basic_salary_grade_list_view_model.dart';
import 'package:login_sample/widgets/CustomListTile.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';

class HrBasicSalaryAddNew extends StatefulWidget {
  const HrBasicSalaryAddNew({Key? key}) : super(key: key);

  @override
  State<HrBasicSalaryAddNew> createState() => _HrBasicSalaryAddNewState();
}

class _HrBasicSalaryAddNewState extends State<HrBasicSalaryAddNew> {

  final TextEditingController _basicSalaryController = TextEditingController();
  final TextEditingController _kpiController = TextEditingController();
  final TextEditingController _allowanceController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _basicSalaryController.dispose();
    _kpiController.dispose();
    _allowanceController.dispose();
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
              child: Column(
                children: <Widget>[
                  CustomListTile(listTileLabel: 'Mức lương tương ứng cấp bậc', alertDialogLabel: 'Cập nhật mức lương tương ứng cấp bậc',
                    value: _basicSalaryController.text.isEmpty ? '0' : _basicSalaryController.text,
                    numberEditController: _basicSalaryController, readOnly: false, moneyFormatType: true),
                  const Divider(color: Colors.blueGrey, thickness: 1.0,),
                  CustomListTile(listTileLabel: 'KPI sau thuế', alertDialogLabel: 'Cập nhật KPI sau thuế',
                      value: _kpiController.text.isEmpty ? '0' : _kpiController.text,
                      numberEditController: _kpiController, readOnly: false, moneyFormatType: true),
                  const Divider(),
                  CustomListTile(listTileLabel: 'Phụ cấp', alertDialogLabel: 'Cập nhật phụ cấp',
                      value: _allowanceController.text.isEmpty ? '0' : _allowanceController.text,
                      numberEditController: _allowanceController, readOnly: false, moneyFormatType: true),
                  const Divider(),

                  if(_basicSalaryController.text.isNotEmpty || _kpiController.text.isNotEmpty || _allowanceController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextButton(
                            color: mainBgColor,
                            text: 'Thêm mới',
                            onPressed: () async {
                              _reverseMoneyFormat();
                              showLoaderDialog(context);
                              bool result = await _createNewBasicSalaryByGrade();
                              if(result == true){
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Thêm mới thành công')),
                                );
                                Navigator.pop(context);
                              }else{
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Thêm mới thất bại')),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),

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
  void _reverseMoneyFormat(){
    _basicSalaryController.text = _basicSalaryController.text.replaceAll('.', '');
    _kpiController.text = _kpiController.text.replaceAll('.', '');
    _allowanceController.text = _allowanceController.text.replaceAll('.', '');
  }

  Future<bool> _createNewBasicSalaryByGrade() async {
    BasicSalaryByGrade basicSalaryByGrade = BasicSalaryByGrade(
        basicSalaryByGradeId: 0,
        basicSalary: _basicSalaryController.text.isEmpty ? 0 : num.tryParse(_basicSalaryController.text)!,
        kpi: _kpiController.text.isEmpty ? 0 : num.tryParse(_kpiController.text)!,
        allowance: _allowanceController.text.isEmpty ? 0 : num.tryParse(_allowanceController.text)!,
    );

    bool? result = await BasicSalaryGradeListViewModel().createNewBasicSalaryGrade(basicSalaryByGrade);

    return result;
  }
}
