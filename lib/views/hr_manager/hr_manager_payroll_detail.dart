import 'package:flutter/material.dart';
import 'package:login_sample/widgets/BonusExpansionTile.dart';
import 'package:login_sample/widgets/CustomReadOnlyTextField.dart';
import 'package:login_sample/widgets/PayrollExpansionTile.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/hr_manager/hr_manager_payroll_list.dart';

class HrManagerPayrollDetail extends StatefulWidget {
  const HrManagerPayrollDetail({Key? key, required this.empPayrolls})
      : super(key: key);

  final EmployeePayrollTemp empPayrolls;

  @override
  _HrManagerPayrollDetailState createState() => _HrManagerPayrollDetailState();
}

class _HrManagerPayrollDetailState extends State<HrManagerPayrollDetail> {
  final TextEditingController _basicPayrollController = TextEditingController();
  final TextEditingController _carParkController = TextEditingController();
  final TextEditingController _fineController = TextEditingController();
  final TextEditingController _personalInsuranceController =
      TextEditingController();
  final TextEditingController _paidInsuranceController =
      TextEditingController();
  late double finalPayroll;

  final TextEditingController personalNewSignController = TextEditingController();
  final TextEditingController personalReSignController = TextEditingController();
  final TextEditingController manageController = TextEditingController();
  final TextEditingController supporterController = TextEditingController();
  final TextEditingController club20Controller = TextEditingController();
  final TextEditingController recruitmentController = TextEditingController();
  final TextEditingController cttdBonusController = TextEditingController();
  final TextEditingController personalBonusController = TextEditingController();
  final TextEditingController teamBonusController = TextEditingController();

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
              elevation: 20.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    CustomReadOnlyTextField(
                      text: widget.empPayrolls.name,
                      title: 'Tên nhân viên',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomReadOnlyTextField(
                      text: widget.empPayrolls.role,
                      title: 'Chức vụ',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomReadOnlyTextField(
                      text: widget.empPayrolls.department,
                      title: 'Phòng ban',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomReadOnlyTextField(
                      text: widget.empPayrolls.team,
                      title: 'Nhóm',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    PayrollExpansionTile(
                        basicPayrollController: _basicPayrollController,
                        carParkController: _carParkController,
                        fineController: _fineController,
                        personalInsuranceController:
                            _personalInsuranceController,
                        paidInsuranceController: _paidInsuranceController),
                    const SizedBox(
                      height: 20.0,
                    ),
                    // BonusExpansionTile(
                    //     personalNewSignController: personalNewSignController,
                    //     personalReSignController: personalReSignController,
                    //     manageController: manageController,
                    //     supporterController: supporterController,
                    //     club20Controller: club20Controller,
                    //     recruitmentController: recruitmentController,
                    //     personalBonusController: personalBonusController,
                    //     teamBonusController: teamBonusController,
                    //     cttdBonusController: cttdBonusController
                    // ),
                  ],
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
                'Lương của ${widget.empPayrolls.name}',
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
