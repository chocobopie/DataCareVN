import 'package:flutter/material.dart';
import 'package:login_sample/models/personal_commission.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/commission_view_model.dart';
import 'package:login_sample/widgets/CustomListTile.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';

class HrPersonalCommissionAddNew extends StatefulWidget {
  const HrPersonalCommissionAddNew({Key? key}) : super(key: key);

  @override
  State<HrPersonalCommissionAddNew> createState() => _HrPersonalCommissionAddNewState();
}

class _HrPersonalCommissionAddNewState extends State<HrPersonalCommissionAddNew> {

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
                            value: _percentageOfKPIController.text.isEmpty ? '0' : _percentageOfKPIController.text,
                            numberEditController:_percentageOfKPIController, readOnly: false, moneyFormatType: false, percentFormatType: true,),
                          const Divider(color: Colors.blueGrey, thickness: 1.0,),

                          CustomListTile(listTileLabel: 'Thưởng kí mới cho NVKD', alertDialogLabel: 'Cập nhật thưởng kí mới cho NVKD',
                            value: _newSignCommissionForSalesEmloyeeController.text.isEmpty ? '0' :_newSignCommissionForSalesEmloyeeController.text,
                            numberEditController:_newSignCommissionForSalesEmloyeeController, readOnly: false, moneyFormatType: false, percentFormatType: true,),
                          const Divider(),

                          CustomListTile(listTileLabel: 'Thưởng tái kí cho NVKD', alertDialogLabel: 'Cập nhật thưởng tái kí cho NVKD',
                            value: _renewedSignCommissionForSalesEmployeeController.text.isEmpty ? '0' : _renewedSignCommissionForSalesEmployeeController.text,
                            numberEditController: _renewedSignCommissionForSalesEmployeeController, readOnly: false, moneyFormatType: false, percentFormatType: true,),
                          const Divider(),

                          CustomListTile(listTileLabel: 'Thưởng kí mới cho TNKD', alertDialogLabel: 'Cập nhật thưởng kí mới cho TNKD',
                            value: _newSignCommissionForSalesLeaderController.text.isEmpty ? '0' : _newSignCommissionForSalesLeaderController.text,
                            numberEditController: _newSignCommissionForSalesLeaderController, readOnly: false, moneyFormatType: false, percentFormatType: true,),
                          const Divider(),

                          CustomListTile(listTileLabel: 'Thưởng tái kí cho TNKD', alertDialogLabel: 'Cập nhật thưởng tái kí cho TNKD',
                            value: _renewedSignCommissionForSalesLeaderController.text.isEmpty ? '0' :_renewedSignCommissionForSalesLeaderController.text,
                            numberEditController: _renewedSignCommissionForSalesLeaderController, readOnly: false, moneyFormatType: false, percentFormatType: true,),

                          const Divider(),

                          CustomListTile(listTileLabel: 'Thưởng kí mới cho TPKD', alertDialogLabel: 'Cập nhật thưởng kí mới cho TPKD',
                            value: _newSignCommissionForSalesManagerController.text.isEmpty ? '0' : _newSignCommissionForSalesManagerController.text,
                            numberEditController: _newSignCommissionForSalesManagerController, readOnly: false, moneyFormatType: false, percentFormatType: true,),

                          const Divider(),

                          CustomListTile(listTileLabel: 'Thưởng tái kí cho TPKD', alertDialogLabel: 'Cập nhật thưởng tái kí cho TPKD',
                            value: _renewedSignCommissionForSalesManagerController.text.isEmpty ? '0' : _renewedSignCommissionForSalesManagerController.text,
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
                                      text: 'Thêm mới',
                                      onPressed: () async {
                                        showLoaderDialog(context);
                                        bool result = await _createNewPersonalCommission();
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
              title: const Text(
                "Thêm mới",
                style: TextStyle(
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

  Future<bool> _createNewPersonalCommission() async {
    PersonalCommission personalCommission = PersonalCommission(
        personalCommissionId: 0,
        percentageOfKpi: _percentageOfKPIController.text.isEmpty ? 0 : double.tryParse(_percentageOfKPIController.text)!/100,
        newSignCommissionForSalesManager: _newSignCommissionForSalesManagerController.text.isEmpty ? 0 : double.tryParse(_newSignCommissionForSalesManagerController.text)!/100,
        renewedSignCommissionForSalesManager: _renewedSignCommissionForSalesManagerController.text.isEmpty ? 0 : double.tryParse(_renewedSignCommissionForSalesManagerController.text)!/100,
        newSignCommissionForSalesLeader: _newSignCommissionForSalesLeaderController.text.isEmpty ? 0 : double.tryParse(_newSignCommissionForSalesLeaderController.text)!/100,
        renewedSignCommissionForSalesLeader: _renewedSignCommissionForSalesLeaderController.text.isEmpty ? 0 : double.tryParse(_renewedSignCommissionForSalesLeaderController.text)!/100,
        newSignCommissionForSalesEmloyee: _newSignCommissionForSalesEmloyeeController.text.isEmpty ? 0 : double.tryParse(_newSignCommissionForSalesEmloyeeController.text)!/100,
        renewedSignCommissionForSalesEmployee: _renewedSignCommissionForSalesEmployeeController.text.isEmpty ? 0 : double.tryParse(_renewedSignCommissionForSalesEmployeeController.text)!/100
    );

    bool result = await CommissionViewModel().createNewPersonalCommission(personalCommission);
    return result;
  }
}
