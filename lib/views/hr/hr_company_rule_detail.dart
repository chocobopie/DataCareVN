import 'package:flutter/material.dart';
import 'package:login_sample/models/personal_commission.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/commission_view_model.dart';
import 'package:login_sample/widgets/CustomListTile.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';

class HrCompanyRuleDetail extends StatefulWidget {
  const HrCompanyRuleDetail({Key? key, required this.personalCommission}) : super(key: key);

  final PersonalCommission personalCommission;

  @override
  State<HrCompanyRuleDetail> createState() => _HrCompanyRuleDetailState();
}

class _HrCompanyRuleDetailState extends State<HrCompanyRuleDetail> {

  final TextEditingController _percentageOfKPIController = TextEditingController();
  final TextEditingController _newSignCommissionForSalesManagerController = TextEditingController();
  final TextEditingController _renewedSignCommissionForSalesManagerController = TextEditingController();
  final TextEditingController _newSignCommissionForSalesLeaderController = TextEditingController();
  final TextEditingController _renewedSignCommissionForSalesLeaderController = TextEditingController();
  final TextEditingController _newSignCommissionForSalesEmloyeeController = TextEditingController();
  final TextEditingController _renewedSignCommissionForSalesEmployeeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _percentageOfKPIController.dispose();
    _newSignCommissionForSalesManagerController.dispose();
    _renewedSignCommissionForSalesManagerController.dispose();
    _newSignCommissionForSalesLeaderController.dispose();
    _renewedSignCommissionForSalesLeaderController.dispose();
    _newSignCommissionForSalesEmloyeeController.dispose();
    _renewedSignCommissionForSalesEmployeeController.dispose();
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
                          CustomListTile(listTileLabel: 'Phần trăm KPI đạt', alertDialogLabel: 'Cập nhật phần trăm KPI đạt',
                            value: _percentageOfKPIController.text.isEmpty ? (widget.personalCommission.percentageOfKpi * 100).toString() : _percentageOfKPIController.text,
                            numberEditController:_percentageOfKPIController, readOnly: false, moneyFormatType: false, percentFormatType: true,),
                          const Divider(color: Colors.blueGrey, thickness: 1.0,),

                          CustomListTile(listTileLabel: 'Thưởng kí mới cho NVKD', alertDialogLabel: 'Cập nhật thưởng kí mới cho NVKD',
                            value: _newSignCommissionForSalesEmloyeeController.text.isEmpty ? ( widget.personalCommission.newSignCommissionForSalesEmloyee * 100).toString() :_newSignCommissionForSalesEmloyeeController.text,
                            numberEditController:_newSignCommissionForSalesEmloyeeController, readOnly: false, moneyFormatType: false, percentFormatType: true,),
                          const Divider(),

                          CustomListTile(listTileLabel: 'Thưởng tái kí cho NVKD', alertDialogLabel: 'Cập nhật thưởng tái kí cho NVKD',
                            value: _renewedSignCommissionForSalesEmployeeController.text.isEmpty ? ( widget.personalCommission.renewedSignCommissionForSalesEmployee * 100).toString() : _renewedSignCommissionForSalesEmployeeController.text,
                            numberEditController: _renewedSignCommissionForSalesEmployeeController, readOnly: false, moneyFormatType: false, percentFormatType: true,),
                          const Divider(),

                          CustomListTile(listTileLabel: 'Thưởng kí mới cho TNKD', alertDialogLabel: 'Cập nhật thưởng kí mới cho TNKD',
                            value: _newSignCommissionForSalesLeaderController.text.isEmpty ? ( widget.personalCommission.newSignCommissionForSalesLeader * 100 ).toString() : _newSignCommissionForSalesLeaderController.text,
                            numberEditController: _newSignCommissionForSalesLeaderController, readOnly: false, moneyFormatType: false, percentFormatType: true,),
                          const Divider(),

                          CustomListTile(listTileLabel: 'Thưởng tái kí cho TNKD', alertDialogLabel: 'Cập nhật thưởng tái kí cho TNKD',
                            value: _renewedSignCommissionForSalesLeaderController.text.isEmpty ? ( widget.personalCommission.renewedSignCommissionForSalesLeader * 100).toString() :_renewedSignCommissionForSalesLeaderController.text,
                            numberEditController: _renewedSignCommissionForSalesLeaderController, readOnly: false, moneyFormatType: false, percentFormatType: true,),

                          const Divider(),

                          CustomListTile(listTileLabel: 'Thưởng kí mới cho TPKD', alertDialogLabel: 'Cập nhật thưởng kí mới cho TPKD',
                            value: _newSignCommissionForSalesManagerController.text.isEmpty ? ( widget.personalCommission.newSignCommissionForSalesManager * 100 ).toString() : _newSignCommissionForSalesManagerController.text,
                            numberEditController: _newSignCommissionForSalesManagerController, readOnly: false, moneyFormatType: false, percentFormatType: true,),

                          const Divider(),

                          CustomListTile(listTileLabel: 'Thưởng tái kí cho TPKD', alertDialogLabel: 'Cập nhật thưởng tái kí cho TPKD',
                            value: _renewedSignCommissionForSalesManagerController.text.isEmpty ? ( widget.personalCommission.renewedSignCommissionForSalesManager * 100 ).toString() : _renewedSignCommissionForSalesManagerController.text,
                            numberEditController: _renewedSignCommissionForSalesManagerController, readOnly: false, moneyFormatType: false, percentFormatType: true,),

                          if(_percentageOfKPIController.text.isNotEmpty || _newSignCommissionForSalesManagerController.text.isNotEmpty ||
                              _renewedSignCommissionForSalesManagerController.text.isNotEmpty || _newSignCommissionForSalesLeaderController.text.isNotEmpty ||
                              _renewedSignCommissionForSalesLeaderController.text.isNotEmpty || _newSignCommissionForSalesEmloyeeController.text.isNotEmpty || _renewedSignCommissionForSalesEmployeeController.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomTextButton(
                                    color: mainBgColor,
                                    text: 'Lưu',
                                    onPressed: () async {
                                      showLoaderDialog(context);
                                      bool result = await _updatePersonalCommission();
                                      if(result == true){
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Cập nhật quy định tiền thưởng cá nhân thành công')),
                                        );
                                        Navigator.pop(context);
                                      }else{
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Cập nhật quy định tiền thưởng cá nhân thất bại')),
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
                "Phần trăm KPI đạt ${widget.personalCommission.percentageOfKpi * 100}%",
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

  Future<bool> _updatePersonalCommission() async {
    PersonalCommission personalCommission = PersonalCommission(
        personalCommissionId: widget.personalCommission.personalCommissionId,
        percentageOfKpi: _percentageOfKPIController.text.isEmpty ? widget.personalCommission.percentageOfKpi : double.tryParse(_percentageOfKPIController.text)!/100,
        newSignCommissionForSalesManager: _newSignCommissionForSalesManagerController.text.isEmpty ? widget.personalCommission.newSignCommissionForSalesManager : double.tryParse(_newSignCommissionForSalesManagerController.text)!/100,
        renewedSignCommissionForSalesManager: _renewedSignCommissionForSalesManagerController.text.isEmpty ? widget.personalCommission.renewedSignCommissionForSalesManager : double.tryParse(_renewedSignCommissionForSalesManagerController.text)!/100,
        newSignCommissionForSalesLeader: _newSignCommissionForSalesLeaderController.text.isEmpty ? widget.personalCommission.newSignCommissionForSalesLeader : double.tryParse(_newSignCommissionForSalesLeaderController.text)!/100,
        renewedSignCommissionForSalesLeader: _renewedSignCommissionForSalesLeaderController.text.isEmpty ? widget.personalCommission.renewedSignCommissionForSalesLeader : double.tryParse(_renewedSignCommissionForSalesLeaderController.text)!/100,
        newSignCommissionForSalesEmloyee: _newSignCommissionForSalesEmloyeeController.text.isEmpty ? widget.personalCommission.newSignCommissionForSalesEmloyee : double.tryParse(_newSignCommissionForSalesEmloyeeController.text)!/100,
        renewedSignCommissionForSalesEmployee: _renewedSignCommissionForSalesEmployeeController.text.isEmpty ? widget.personalCommission.renewedSignCommissionForSalesEmployee : double.tryParse(_renewedSignCommissionForSalesEmployeeController.text)!/100
    );

    bool result = await CommissionViewModel().updatePersonalCommission(personalCommission);
    return result;
  }
}
