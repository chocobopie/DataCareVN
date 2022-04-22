import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/widgets/BonusExpansionTile.dart';
import 'package:login_sample/widgets/CustomMonthPicker.dart';
import 'package:login_sample/widgets/CustomReadOnlyTextField.dart';
import 'package:login_sample/widgets/PayrollExpansionTile.dart';
import 'package:login_sample/utilities/utils.dart';

class HrManagerPayrollDetail extends StatefulWidget {
  const HrManagerPayrollDetail({Key? key, required this.empAccount})
      : super(key: key);

  final Account empAccount;

  @override
  _HrManagerPayrollDetailState createState() => _HrManagerPayrollDetailState();
}

class _HrManagerPayrollDetailState extends State<HrManagerPayrollDetail> {
  final TextEditingController _basicPayrollController = TextEditingController();
  final TextEditingController _carParkController = TextEditingController();
  final TextEditingController _fineController = TextEditingController();
  final TextEditingController _personalInsuranceController = TextEditingController();
  final TextEditingController _paidInsuranceController = TextEditingController();
  late double finalPayroll;

  DateTime _selectedMonth = DateTime.now();
  final DateTime _currentTime = DateTime.now();
  late final DateTime _thisMonthYear;

  final TextEditingController personalNewSignController = TextEditingController();
  final TextEditingController personalReSignController = TextEditingController();
  final TextEditingController manageController = TextEditingController();
  final TextEditingController supporterController = TextEditingController();
  final TextEditingController club20Controller = TextEditingController();
  final TextEditingController recruitmentController = TextEditingController();
  final TextEditingController cttdBonusController = TextEditingController();
  final TextEditingController personalBonusController = TextEditingController();
  final TextEditingController teamBonusController = TextEditingController();
  final TextEditingController? emulationBonusController = TextEditingController();
  final TextEditingController? recruitmentBonusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _thisMonthYear = DateTime.parse( DateFormat('yyyy-MM-dd').format(_currentTime) );
    print(_thisMonthYear);
  }

  @override
  void dispose() {
    _basicPayrollController.dispose();
    _carParkController.dispose();
    _fineController.dispose();
    _personalInsuranceController.dispose();
    _paidInsuranceController.dispose();
    super.dispose();
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
              elevation: 10.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))
              ),
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 10.0,),
                      Row(
                        children: [
                          Expanded(
                            child: CustomReadOnlyTextField(
                              text: widget.empAccount.fullname!,
                              title: 'Tên nhân viên',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Expanded(
                            child: CustomReadOnlyTextField(
                              text: blockNames[widget.empAccount.blockId!],
                              title: 'Khối',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Expanded(
                            child: CustomReadOnlyTextField(
                              text: rolesNames[widget.empAccount.roleId!],
                              title: 'Chức vụ',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),
                      if(widget.empAccount.departmentId != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomReadOnlyTextField(
                                text: getDepartmentName(widget.empAccount.departmentId!, widget.empAccount.blockId),
                                title: 'Phòng ban',
                              ),
                            ),
                          ],
                        ),
                      ),
                      if(widget.empAccount.teamId != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomReadOnlyTextField(
                                text: getTeamName(widget.empAccount.teamId!, widget.empAccount.departmentId!),
                                title: 'Nhóm',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 200.0,
                              decoration: const BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: TextButton.icon(
                                onPressed: () async {
                                  // _onPressed(context: context);
                                  final date = await DatePicker.showPicker(context,
                                    pickerModel: CustomMonthPicker(
                                      currentTime: DateTime.now(),
                                      minTime: DateTime(2016),
                                      maxTime: DateTime.now(),
                                      locale: LocaleType.vi,
                                    ),
                                  );

                                  if (date != null) {
                                    setState(() {
                                      _selectedMonth = date;
                                      print(_selectedMonth);
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Tháng ${DateFormat('dd-MM-yyyy').format(_selectedMonth).substring(3, 10)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20.0,),

                      PayrollExpansionTile(
                          readOnly: _selectedMonth.isBefore(_thisMonthYear) ? true : false,
                          selectMonth: 'Tháng ${DateFormat('dd-MM-yyyy').format(_selectedMonth).substring(3, 10)}',
                          basicPayrollController: _basicPayrollController,
                          carParkController: _carParkController,
                          fineController: _fineController,
                          personalInsuranceController: _personalInsuranceController,
                          paidInsuranceController: _paidInsuranceController
                      ),
                      // const SizedBox(
                      //   height: 20.0,
                      // ),
                      // BonusExpansionTile(
                      //   readOnly: _selectedMonth.isBefore(_thisMonthYear) ? true : false,
                      //   selectMonth: 'Tháng ${DateFormat('dd-MM-yyyy').format(_selectedMonth).substring(3, 10)}',
                      //   emulationBonusController: emulationBonusController,
                      //   recruitmentBonusController: recruitmentBonusController,
                      //   personalBonusController: personalBonusController,
                      //   teamBonusController: teamBonusController,
                      // ),
                    ],
                  ),
                ),
              )),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(
                  color: Colors.blueGrey), // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text(
                'Lương của ${widget.empAccount.fullname}',
                style: const TextStyle(
                    letterSpacing: 0.0, fontSize: 20.0, color: Colors.blueGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
