import 'package:flutter/material.dart';
import 'package:login_sample/models/management_commission.dart';
import 'package:login_sample/models/personal_commission.dart';
import 'package:login_sample/models/attendance_rule.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/attendance_rule_view_model.dart';
import 'package:login_sample/view_models/commission_list_view_model.dart';
import 'package:login_sample/view_models/commission_view_model.dart';
import 'package:login_sample/views/hr/hr_personal_comission_add_new.dart';
import 'package:login_sample/views/hr/hr_personal_commission_detail.dart';
import 'package:login_sample/widgets/CustomListTile.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HrCompanyRule extends StatefulWidget {
  const HrCompanyRule({Key? key}) : super(key: key);

  @override
  State<HrCompanyRule> createState() => _HrCompanyRuleState();
}

class _HrCompanyRuleState extends State<HrCompanyRule> {

  AttendanceRule? _attendanceRule;

  final TextEditingController _maximumApprovedLateShiftPerMonthController = TextEditingController();
  final TextEditingController _maximumApprovedAbsenceShiftPerMonthController = TextEditingController();
  final TextEditingController _maximumApprovedAbsenceShiftPerYearController = TextEditingController();
  final TextEditingController _fineForEachLateShiftController = TextEditingController();
  final TextEditingController _managementPercentageOfKPIController = TextEditingController();
  final TextEditingController _managementCommissionController = TextEditingController();

  final RefreshController _refreshController = RefreshController();
  final RefreshController _refreshController2 = RefreshController();

  final List<PersonalCommission> _listPersonalCommission = [];
  ManagementCommission? _managementCommission;


  @override
  void initState() {
    super.initState();
    _getAttendanceRule();
    _getListPersonalCommission();
    _getListManagementCommission();
  }

  @override
  void dispose() {
    super.dispose();
    _maximumApprovedLateShiftPerMonthController.dispose();
    _maximumApprovedAbsenceShiftPerMonthController.dispose();
    _maximumApprovedAbsenceShiftPerYearController.dispose();
    _fineForEachLateShiftController.dispose();
    _refreshController.dispose();
    _refreshController2.dispose();
    _managementPercentageOfKPIController.dispose();
    _managementCommissionController.dispose();
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
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 1,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        gradient: const LinearGradient(
                          stops: [0.02, 0.01],
                          colors: [Colors.green, Colors.white],
                        ),
                      ),
                      child: Theme(
                        data: ThemeData().copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: const Text('B???ng quy ?????nh ??i???m danh'),
                          children: <Widget>[
                            const Divider(color: Colors.blueGrey, thickness: 1.0,),
                            _attendanceRule != null ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  CustomListTile(listTileLabel: 'S??? ca v???ng c?? ph??p t???i ??a trong n??m', alertDialogLabel: 'C???p nh???t s??? ca v???ng c?? ph??p t???i ??a trong n??m', value: _maximumApprovedAbsenceShiftPerYearController.text.isEmpty ? _attendanceRule!.maximumApprovedAbsenceShiftPerYear.toString() : _maximumApprovedAbsenceShiftPerYearController.text ,numberEditController: _maximumApprovedAbsenceShiftPerYearController, readOnly: false, moneyFormatType: false,),
                                  CustomListTile(listTileLabel: 'S??? ca v???ng c?? ph??p t???i ??a trong th??ng', alertDialogLabel: 'C???p nh???t s??? ca v???ng c?? ph??p t???i ??a trong th??ng', value: _maximumApprovedAbsenceShiftPerMonthController.text.isEmpty ? _attendanceRule!.maximumApprovedAbsenceShiftPerMonth.toString() : _maximumApprovedAbsenceShiftPerMonthController.text ,numberEditController: _maximumApprovedAbsenceShiftPerMonthController, readOnly: false, moneyFormatType: false,),
                                  CustomListTile(listTileLabel: 'S??? ca ??i tr??? c?? ph??p t???i ??a trong th??ng', alertDialogLabel: 'C???p nh???t ca ??i tr??? c?? ph??p t???i ??a trong th??ng', value: _maximumApprovedLateShiftPerMonthController.text.isEmpty ? _attendanceRule!.maximumApprovedLateShiftPerMonth.toString() : _maximumApprovedLateShiftPerMonthController.text ,numberEditController: _maximumApprovedLateShiftPerMonthController, readOnly: false, moneyFormatType: false,),
                                  CustomListTile(listTileLabel: 'S??? ti???n ph???t m???i l???n ??i tr??? kh??ng ph??p', alertDialogLabel: 'C???p ti???n ph???t m???i l???n ??i tr??? kh??ng ph??p', value: _fineForEachLateShiftController.text.isEmpty ? _attendanceRule!.fineForEachLateShift.toString() : _fineForEachLateShiftController.text ,numberEditController: _fineForEachLateShiftController, readOnly: false, moneyFormatType: true,),

                                  if(_maximumApprovedAbsenceShiftPerYearController.text.isNotEmpty || _maximumApprovedAbsenceShiftPerMonthController.text.isNotEmpty || _maximumApprovedLateShiftPerMonthController.text.isNotEmpty || _fineForEachLateShiftController.text.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextButton(
                                              color: mainBgColor,
                                              text: 'L??u',
                                              onPressed: () async {
                                                showLoaderDialog(context);
                                                bool result = await _updateAttendanceRule();
                                                if(result == true){
                                                  _getAttendanceRule();
                                                  _resetAttendanceRuleController();
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('C???p nh???t quy ?????nh ngh??? ph??p th??nh c??ng')),
                                                  );
                                                }else{
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('C???p nh???t quy ?????nh ngh??? ph??p th???t b???i')),
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
                            ) : const Padding(
                              padding: EdgeInsets.all(10),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    buildPersonalCommission(context),
                    const SizedBox(height: 10.0,),
                    buildManagementCommission(context),
                    const SizedBox(height: 100.0,),
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
                "Quy ?????nh c???a c??ng ty",
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

  void _getAttendanceRule() async {
    AttendanceRule? result = await AttendanceRuleViewModel().getAttendanceRule();

    if(result != null){
      setState(() {
        _attendanceRule = result;
      });
    }
  }

  Future<bool> _updateAttendanceRule() async {
    if(_fineForEachLateShiftController.text.isNotEmpty){
      _fineForEachLateShiftController.text = _fineForEachLateShiftController.text.replaceAll('.', '');
    }

    AttendanceRule attendanceRule = AttendanceRule(
        attendanceRuleId: _attendanceRule!.attendanceRuleId,
        maximumApprovedLateShiftPerMonth: _maximumApprovedAbsenceShiftPerMonthController.text.isEmpty ? _attendanceRule!.maximumApprovedLateShiftPerMonth : int.tryParse(_maximumApprovedAbsenceShiftPerMonthController.text)!,
        maximumApprovedAbsenceShiftPerMonth: _maximumApprovedAbsenceShiftPerMonthController.text.isEmpty ? _attendanceRule!.maximumApprovedAbsenceShiftPerMonth : int.tryParse(_maximumApprovedAbsenceShiftPerMonthController.text)!,
        maximumApprovedAbsenceShiftPerYear: _maximumApprovedAbsenceShiftPerYearController.text.isEmpty ? _attendanceRule!.maximumApprovedAbsenceShiftPerYear : int.tryParse(_maximumApprovedAbsenceShiftPerYearController.text)!,
        fineForEachLateShift: _fineForEachLateShiftController.text.isEmpty ? _attendanceRule!.fineForEachLateShift : num.tryParse(_fineForEachLateShiftController.text)!,
    );

    bool result = await AttendanceRuleViewModel().updateAttendanceRule(attendanceRule);

    return result;
  }

  void _resetAttendanceRuleController() async {
    _maximumApprovedLateShiftPerMonthController.clear();
    _maximumApprovedAbsenceShiftPerMonthController.clear();
    _maximumApprovedAbsenceShiftPerYearController.clear();
    _fineForEachLateShiftController.clear();
  }

  void _getListPersonalCommission() async {
    setState(() {
      _listPersonalCommission.clear();
    });

    List<PersonalCommission>? result = await CommissionListViewModel().getListPersonalCommission();

    if(result!.isNotEmpty){
      setState(() {
        _listPersonalCommission.addAll(result);
        _refreshController.loadNoData();
      });
    }
  }

  void _getListManagementCommission() async {
    setState(() {
      _managementCommission = null;
    });

    List<ManagementCommission>? result = await CommissionListViewModel().getListManagementCommission();

    if(result!.isNotEmpty){
      setState(() {
        _managementCommission = result[0];
        _refreshController2.loadNoData();
      });
    }
  }

  Future<bool> _updateManagementCommission() async {

    ManagementCommission managementCommission = ManagementCommission(
        managementCommissionId: _managementCommission!.managementCommissionId,
        percentageOfKpi: _managementPercentageOfKPIController.text.isEmpty ? _managementCommission!.percentageOfKpi : double.tryParse(_managementPercentageOfKPIController.text)!/100,
        commission: _managementCommissionController.text.isEmpty ? _managementCommission!.commission : double.tryParse(_managementCommissionController.text)!/100,
    );


    bool result = await CommissionViewModel().updateManagementCommission(managementCommission);
    return result;
  }
  
  void _onGoBack() async {
    _getListPersonalCommission();
  }

  Container buildManagementCommission(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        gradient: const LinearGradient(
          stops: [0.02, 0.01],
          colors: [Colors.orange, Colors.white],
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text('B???ng ti???n th?????ng qu???n l??'),
          children: <Widget>[
            const Divider(color: Colors.blueGrey, thickness: 1.0,),
            _managementCommission != null ? Column(
              children: <Widget>[
                CustomListTile(listTileLabel: 'Ph???m tr??m KPI ?????t', alertDialogLabel: 'C???p nh???t ph???n tr??m KPI ?????t', value: _managementPercentageOfKPIController.text.isEmpty ? (_managementCommission!.percentageOfKpi*100).toString() :  _managementPercentageOfKPIController.text ,numberEditController: _managementPercentageOfKPIController, readOnly: false, moneyFormatType: false, percentFormatType: true),
                CustomListTile(listTileLabel: 'Th?????ng', alertDialogLabel: 'C???p nh???t th?????ng', value:  _managementCommissionController.text.isEmpty ? (_managementCommission!.commission*100).toString() :  _managementCommissionController.text ,numberEditController:  _managementCommissionController, readOnly: false, moneyFormatType: false, percentFormatType: true),
                if(_managementPercentageOfKPIController.text.isNotEmpty || _managementCommissionController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextButton(
                          color: mainBgColor,
                          text: 'L??u',
                          onPressed: () async {
                            showLoaderDialog(context);
                            bool result = await _updateManagementCommission();
                            if(result == true){
                              _getListManagementCommission();
                              setState(() {
                                _managementCommissionController.clear();
                                _managementPercentageOfKPIController.clear();
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('C???p nh???t quy ?????nh ti???n th?????ng qu???n l?? th??nh c??ng')),
                              );
                            }else{
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('C???p nh???t quy ?????nh ti???n th?????ng qu???n l?? th???t b???i')),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ) : const Center(child: Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(),
            ))
          ],
        ),
      ),
    );
  }

  Container buildPersonalCommission(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        gradient: const LinearGradient(
          stops: [0.02, 0.01],
          colors: [Colors.blue, Colors.white],
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text('B???ng ti???n th?????ng c?? nh??n'),
          children: <Widget>[
            const Divider(color: Colors.blueGrey, thickness: 1.0,),
            SizedBox(
              child: _listPersonalCommission.isNotEmpty ? SmartRefresher(
                controller: _refreshController,
                enablePullUp: true,
                onRefresh: () async{
                  setState(() {
                    _listPersonalCommission.clear();
                  });
                  _refreshController.resetNoData();

                  _getListPersonalCommission();

                  if(_listPersonalCommission.isNotEmpty){
                    _refreshController.refreshCompleted();
                  }else{
                    _refreshController.refreshFailed();
                  }
                },
                child: ListView.builder(
                  itemCount: _listPersonalCommission.length,
                  itemBuilder: (context, index){
                    final _personalCommission = _listPersonalCommission[index];
                    return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0, left: 10.0),
                        child: Card(
                          elevation: 10.0,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => HrPersonalCommissionDetail(personalCommission: _personalCommission,)
                              )).then((value) => _onGoBack());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        const Text('Ph???n tr??m KPI ?????t', style: TextStyle(fontSize: 12.0),),
                                        const Spacer(),
                                        Text('${_personalCommission.percentageOfKpi * 100}%', style: const TextStyle(fontSize: 14.0),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    );
                  },
                ),
              ) : const Center(child: CircularProgressIndicator()),
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomTextButton(
                        color: mainBgColor, text: 'Th??m m???i',
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const HrPersonalCommissionAddNew()
                        )).then((value) => _onGoBack());
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
