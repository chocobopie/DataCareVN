import 'package:flutter/material.dart';
import 'package:login_sample/models/basic_salary_by_grade.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/basic_salary_grade_list_view_model.dart';
import 'package:login_sample/widgets/CustomListTile.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';

class HrBasicSalaryDetail extends StatefulWidget {
  const HrBasicSalaryDetail({Key? key, required this.basicSalaryByGrade}) : super(key: key);

  final BasicSalaryByGrade basicSalaryByGrade;

  @override
  State<HrBasicSalaryDetail> createState() => _HrBasicSalaryDetailState();
}

class _HrBasicSalaryDetailState extends State<HrBasicSalaryDetail> {

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
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0, bottom: 20.0),
                      child: Column(
                        children: <Widget>[
                          CustomListTile(listTileLabel: 'Mức lương tương ứng với cấp bậc', alertDialogLabel: 'Cập nhật mức lương',
                            value: _basicSalaryController.text.isEmpty ? (widget.basicSalaryByGrade.basicSalary).toString() : _basicSalaryController.text,
                            numberEditController:_basicSalaryController, readOnly: false, moneyFormatType: true, percentFormatType: false,),
                          const Divider(color: Colors.blueGrey, thickness: 1.0,),

                          CustomListTile(listTileLabel: 'KPI ( sau thuế )', alertDialogLabel: 'Cập nhật KPI',
                            value: _kpiController.text.isEmpty ? ( widget.basicSalaryByGrade.kpi).toString() :_kpiController.text,
                            numberEditController:_kpiController, readOnly: false, moneyFormatType: true, percentFormatType: false,),
                          const Divider(),

                          CustomListTile(listTileLabel: 'Trợ cấp', alertDialogLabel: 'Cập nhật trợ cấp',
                            value: _allowanceController.text.isEmpty ? ( widget.basicSalaryByGrade.allowance ).toString() : _allowanceController.text,
                            numberEditController: _allowanceController, readOnly: false, moneyFormatType: true, percentFormatType: false,),
                          const Divider(),

                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextButton(
                                      color: mainBgColor,
                                      text: 'Lưu',
                                      onPressed: () async {
                                        _reverseMoneyFormat();
                                        showLoaderDialog(context);
                                        bool result = await _updateBasicSalaryByGrade();
                                        if(result == true){
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Cập nhật tiền lương theo cấp bậc thành công')),
                                          );
                                          Navigator.pop(context);
                                        }else{
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Cập nhật tiền lương theo cấp bậc thất bại')),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
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
              title: Text(
                "Lương ${moneyFormat(widget.basicSalaryByGrade.basicSalary.toString())}đ",
                style: const TextStyle(
                  letterSpacing: 0.0,
                  fontSize: 18.0,
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

  Future<bool> _updateBasicSalaryByGrade() async {
    BasicSalaryByGrade basicSalaryByGrade = BasicSalaryByGrade(
        basicSalaryByGradeId: widget.basicSalaryByGrade.basicSalaryByGradeId,
        basicSalary: _basicSalaryController.text.isEmpty ? widget.basicSalaryByGrade.basicSalary : num.tryParse(_basicSalaryController.text)!,
        kpi: _kpiController.text.isEmpty ? widget.basicSalaryByGrade.kpi : num.tryParse(_kpiController.text)!,
        allowance: _allowanceController.text.isEmpty ? widget.basicSalaryByGrade.allowance : num.tryParse(_allowanceController.text)!,
    );

    bool result = await BasicSalaryGradeListViewModel().updateBasicSalaryByGrade(basicSalaryByGrade);

    return result;
  }
}
