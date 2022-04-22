import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/PayrollCompany.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/payroll.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/view_models/payroll_company_list_view_model.dart';
import 'package:login_sample/view_models/payroll_list_view_model.dart';
import 'package:login_sample/widgets/CustomListTile.dart';
import 'package:login_sample/widgets/CustomMonthPicker.dart';
import 'package:login_sample/widgets/CustomReadOnlyTextField.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:provider/provider.dart';

class HrManagerPayrollDetail extends StatefulWidget {
  const HrManagerPayrollDetail({Key? key, required this.empAccount})
      : super(key: key);

  final Account empAccount;

  @override
  _HrManagerPayrollDetailState createState() => _HrManagerPayrollDetailState();
}

class _HrManagerPayrollDetailState extends State<HrManagerPayrollDetail> {

  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month - 1);
  DateTime? _fromDate, _toDate;
  final int _currentPage = 0;
  late Account? _currentAccount;

  PayrollCompany? _payrollCompany;
  Payroll? _payroll;

  final TextEditingController basicSalaryController = TextEditingController();
  final TextEditingController allowanceController = TextEditingController();
  final TextEditingController parkingFeeController = TextEditingController();
  final TextEditingController fineController = TextEditingController();
  final TextEditingController personalInsuranceController = TextEditingController();
  final TextEditingController companyInsuranceController = TextEditingController();
  final TextEditingController actualSalaryReceivedController = TextEditingController();
  final TextEditingController newSignPersonalSalesBonusController = TextEditingController();
  final TextEditingController renewedPersonalSalesBonusController = TextEditingController();
  final TextEditingController managementSalesBonusController = TextEditingController();
  final TextEditingController supporterSalesBonusController = TextEditingController();
  final TextEditingController clB20SalesBonusController = TextEditingController();
  final TextEditingController contentManagerFanpageTechnicalEmployeeBonusController = TextEditingController();
  final TextEditingController collaboratorFanpageTechnicalEmployeeBonusController = TextEditingController();
  final TextEditingController renewedFanpageTechnicalEmployeeBonusController = TextEditingController();
  final TextEditingController contentManagerWebsiteAdsTechnicalEmployeeBonusController = TextEditingController();
  final TextEditingController collaboratorWebsiteTechnicalEmployeeBonusController = TextEditingController();
  final TextEditingController renewedWebsiteTechnicalEmployeeBonusController = TextEditingController();
  final TextEditingController collaboratorAdsTechnicalEmployeeBonusController = TextEditingController();
  final TextEditingController lecturerEducationTechnicalEmployeeBonusController = TextEditingController();
  final TextEditingController tutorEducationTechnicalEmployeeBonusController = TextEditingController();
  final TextEditingController techcareEducationTechnicalEmployeeBonusController = TextEditingController();
  final TextEditingController emulationBonusController = TextEditingController();
  final TextEditingController recruitmentBonusController = TextEditingController();
  final TextEditingController personalBonusController = TextEditingController();
  final TextEditingController teamBonusController = TextEditingController();

  @override
  void initState() {
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _fromDate = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    _toDate = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    _getPayrollCompany(isRefresh: true);
    super.initState();
  }

  @override
  void dispose() {
    basicSalaryController.dispose();
    allowanceController.dispose();
    parkingFeeController.dispose();
    fineController.dispose();
    personalInsuranceController.dispose();
    companyInsuranceController.dispose();
    actualSalaryReceivedController.dispose();
    newSignPersonalSalesBonusController.dispose();
    renewedPersonalSalesBonusController.dispose();
    managementSalesBonusController.dispose();
    supporterSalesBonusController.dispose();
    clB20SalesBonusController.dispose();
    contentManagerFanpageTechnicalEmployeeBonusController.dispose();
    collaboratorFanpageTechnicalEmployeeBonusController.dispose();
    renewedFanpageTechnicalEmployeeBonusController.dispose();
    contentManagerWebsiteAdsTechnicalEmployeeBonusController.dispose();
    collaboratorWebsiteTechnicalEmployeeBonusController.dispose();
    renewedWebsiteTechnicalEmployeeBonusController.dispose();
    collaboratorAdsTechnicalEmployeeBonusController.dispose();
    lecturerEducationTechnicalEmployeeBonusController.dispose();
    tutorEducationTechnicalEmployeeBonusController.dispose();
    techcareEducationTechnicalEmployeeBonusController.dispose();
    emulationBonusController.dispose();
    recruitmentBonusController.dispose();
    personalBonusController.dispose();
    teamBonusController.dispose();
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
                      //Chọn tháng
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
                                    });

                                    if(date.month != DateTime.now().month && date.year == DateTime.now().year){
                                      _payrollCompany = null;
                                      _payroll = null;

                                      _fromDate = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
                                      _toDate = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
                                      _getPayrollCompany(isRefresh: true);
                                      print(_fromDate);
                                      print(_toDate);
                                    }
                                  }
                                },
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Tháng ${DateFormat('MM-yyyy').format(_selectedMonth)}',
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
                      //Cập nhật lương tháng này
                      if(_selectedMonth.month == DateTime.now().month && _selectedMonth.year == DateTime.now().year)
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
                              colors: [Colors.blue, Colors.white],
                            ),
                          ),
                          child: Theme(
                            data: ThemeData().copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text('Lương tháng ${DateFormat('MM-yyyy').format(_selectedMonth)}', style: const TextStyle(fontSize: 14.0),),
                              trailing: Text('${_payroll!.actualSalaryReceived}'),
                              children: <Widget>[
                                const Divider(color: Colors.blueGrey, thickness: 1.0,),
                                CustomListTile(listTileLabel: 'Lương cơ bản', alertDialogLabel: 'Cập nhật lương cơ bản', numberEditController: basicSalaryController, readOnly: false),
                                CustomListTile(listTileLabel: 'Trợ cấp', alertDialogLabel: 'Cập nhật trợ cấp', numberEditController: allowanceController, readOnly: false),
                                CustomListTile(listTileLabel: 'Tiền giữ xe', alertDialogLabel: 'Cập nhật tiền giữ xe', numberEditController: parkingFeeController, readOnly: false),
                                CustomListTile(listTileLabel: 'Tiền phạt', alertDialogLabel: 'Cập nhật tiền phạt', numberEditController: fineController, readOnly: false),
                                CustomListTile(listTileLabel: 'Bảo hiểm cá nhân', alertDialogLabel: 'Bảo hiểm cá nhân', numberEditController: personalInsuranceController, readOnly: false),
                                CustomListTile(listTileLabel: 'Bảo hiểm công ty đóng', alertDialogLabel: 'Cập nhật bảo hiểm công ty đóng', numberEditController: companyInsuranceController, readOnly: false),
                                CustomListTile(listTileLabel: 'Tiền thưởng ký mới', alertDialogLabel: 'Cập nhật thưởng ký mới', numberEditController: newSignPersonalSalesBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Tiền thưởng tái ký', alertDialogLabel: 'Cập nhật thưởng tái ký', numberEditController: renewedPersonalSalesBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng quản lý bán hàng', alertDialogLabel: 'Cập nhật thưởng quản lý bán hàng', numberEditController: managementSalesBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng hỗ trợ bán hàng', alertDialogLabel: 'Cập nhật thưởng hỗ trợ bán hàng', numberEditController: supporterSalesBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng CLB 20', alertDialogLabel: 'Cập nhật thưởng CLB 20', numberEditController: clB20SalesBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng quản lý Fanpage', alertDialogLabel: 'Cập nhật thưởng Fanpage', numberEditController: contentManagerFanpageTechnicalEmployeeBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng cộng tác quản lý Fanpage', alertDialogLabel: 'Cập nhật cộng tác quản lý Fanpage', numberEditController: collaboratorFanpageTechnicalEmployeeBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng tái ký quản lý Fanpage', alertDialogLabel: 'Cập nhật thưởng tái ký quản lý Fanpage', numberEditController: renewedFanpageTechnicalEmployeeBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng quản lý nội dung Ads cho website', alertDialogLabel: 'Cập nhật thưởng quản lý nội dung cho website', numberEditController: contentManagerWebsiteAdsTechnicalEmployeeBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng  cộng tác quản lý website', alertDialogLabel: 'Cập nhật thưởng cộng tác quản lý website', numberEditController: collaboratorWebsiteTechnicalEmployeeBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng tái ký quản lý website', alertDialogLabel: 'Cập nhật thưởng tái ký quản lý website', numberEditController: renewedWebsiteTechnicalEmployeeBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng cộng tác quản lý nội dung Ads', alertDialogLabel: 'Cập nhật thưởng cộng tác quản lý Ads', numberEditController: collaboratorAdsTechnicalEmployeeBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng giảng viên', alertDialogLabel: 'Cập nhật thưởng giảng viên', numberEditController: lecturerEducationTechnicalEmployeeBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng trợ giảng', alertDialogLabel: 'Cập nhật trợ cấp', numberEditController: tutorEducationTechnicalEmployeeBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng CSKH', alertDialogLabel: 'Cập nhật thưởng CSKH', numberEditController: techcareEducationTechnicalEmployeeBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng thi đua', alertDialogLabel: 'Cập nhật thưởng thi đua', numberEditController: emulationBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng tuyển dụng', alertDialogLabel: 'Cập nhật thưởng tuyển dụng', numberEditController: recruitmentBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng cá nhân', alertDialogLabel: 'Cập nhật thưởng cá nhân', numberEditController: personalBonusController, readOnly: false),
                                CustomListTile(listTileLabel: 'Thưởng nhóm', alertDialogLabel: 'Cập nhật thưởng nhóm', numberEditController: teamBonusController, readOnly: false),
                              ],
                            ),
                          ),
                        ),
                      //Lương tháng trước
                      if(_selectedMonth.month != DateTime.now().month)
                        _payroll != null ? previousMonthPayroll() : const Center(child: CircularProgressIndicator()),

                      const SizedBox(height: 50.0,),
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

  Container previousMonthPayroll() {
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
                            title: Text('Lương tháng ${DateFormat('dd-MM-yyyy').format(_selectedMonth).substring(3, 10)}', style: const TextStyle(fontSize: 14.0),),
                            trailing: Text('${_payroll!.actualSalaryReceived}'),
                            children: <Widget>[
                              const Divider(color: Colors.blueGrey, thickness: 1.0,),
                              ListTile(
                                title: const Text('Lương cơ bản', style: TextStyle(fontSize: 14.0,),),
                                trailing: Text(moneyFormat(_payroll!.basicSalary.toString()), style: const TextStyle(fontSize: 14.0,),),
                              ),
                              ListTile(
                                title: const Text('Trợ cấp', style: TextStyle(fontSize: 14.0,),),
                                trailing: Text(moneyFormat(_payroll!.allowance.toString()), style: const TextStyle(fontSize: 14.0,),),
                              ),
                              ListTile(
                                title: const Text('Tiền đỗ xe', style: TextStyle(fontSize: 14.0,),),
                                trailing: Text(moneyFormat(_payroll!.parkingFee.toString()), style: const TextStyle(fontSize: 14.0,),),
                              ),
                              ListTile(
                                title: const Text('Tiền phạt', style: TextStyle(fontSize: 14.0,),),
                                trailing: Text(moneyFormat(_payroll!.fine.toString()), style: const TextStyle(fontSize: 14.0,),),
                              ),
                              ListTile(
                                title: const Text('Bảo hiểm cá nhân', style: TextStyle(fontSize: 14.0,),),
                                trailing: Text(moneyFormat(_payroll!.personalInsurance.toString()), style: const TextStyle(fontSize: 14.0,),),
                              ),
                              ListTile(
                                title: const Text('Bảo hiểm công ty đóng', style: TextStyle(fontSize: 14.0,),),
                                trailing: Text(moneyFormat(_payroll!.companyInsurance.toString()), style: const TextStyle(fontSize: 14.0,),),
                              ),
                              if(widget.empAccount.roleId == 3 || widget.empAccount.roleId == 4 ||widget.empAccount.roleId == 5)
                                ListTile(
                                  title: const Text('Thưởng ký mới', style: TextStyle(fontSize: 14.0,),),
                                  trailing: Text(moneyFormat(_payroll!.newSignPersonalSalesBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                                ),
                              if(widget.empAccount.roleId == 3 || widget.empAccount.roleId == 4 || widget.empAccount.roleId == 5)
                                ListTile(
                                  title: const Text('Thưởng tái ký', style: TextStyle(fontSize: 14.0,),),
                                  trailing: Text(moneyFormat(_payroll!.renewedPersonalSalesBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                                ),
                              if(widget.empAccount.roleId == 3 || widget.empAccount.roleId == 4 || widget.empAccount.roleId == 5)
                                ListTile(
                                  title: const Text('Thưởng quản lý bán hàng', style: TextStyle(fontSize: 14.0,),),
                                  trailing: Text(moneyFormat(_payroll!.managementSalesBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                                ),
                              if(widget.empAccount.roleId == 3 || widget.empAccount.roleId == 4 || widget.empAccount.roleId == 5)
                                ListTile(
                                  title: const Text('Thưởng hỗ trợ bán hàng', style: TextStyle(fontSize: 14.0,),),
                                  trailing: Text(moneyFormat(_payroll!.supporterSalesBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                                ),
                              if(widget.empAccount.roleId == 3 || widget.empAccount.roleId == 4 || widget.empAccount.roleId == 5)
                                ListTile(
                                  title: const Text('Thưởng CLB 20', style: TextStyle(fontSize: 14.0,),),
                                  trailing: Text(moneyFormat(_payroll!.clB20SalesBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                                ),
                              if(widget.empAccount.roleId == 6)
                                ListTile(
                                  title: const Text('Thưởng quản lý Fanpage', style: TextStyle(fontSize: 14.0,),),
                                  trailing: Text(moneyFormat(_payroll!.contentManagerFanpageTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                                ),
                              if(widget.empAccount.roleId == 6)
                                ListTile(
                                  title: const Text('Thưởng cộng tác quản lý Fanpage', style: TextStyle(fontSize: 14.0,),),
                                  trailing: Text(moneyFormat(_payroll!.collaboratorFanpageTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                                ),
                              if(widget.empAccount.roleId == 6)
                                ListTile(
                                  title: const Text('Thưởng quản lý nội dung Ads cho website', style: TextStyle(fontSize: 14.0,),),
                                  trailing: Text(moneyFormat(_payroll!.contentManagerWebsiteAdsTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                                ),
                              if(widget.empAccount.roleId == 6)
                                ListTile(
                                  title: const Text('Thưởng cộng tác quản lý website', style: TextStyle(fontSize: 14.0,),),
                                  trailing: Text(moneyFormat(_payroll!.collaboratorWebsiteTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                                ),
                              if(widget.empAccount.roleId == 6)
                                ListTile(
                                  title: const Text('Thưởng tái ký quản lý website', style: TextStyle(fontSize: 14.0,),),
                                  trailing: Text(moneyFormat(_payroll!.renewedWebsiteTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                                ),
                              if(widget.empAccount.roleId == 6)
                                ListTile(
                                  title: const Text('Thưởng cộng tác quản lý Ads', style: TextStyle(fontSize: 14.0,),),
                                  trailing: Text(moneyFormat(_payroll!.collaboratorAdsTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                                ),
                              if(widget.empAccount.roleId == 6)
                                ListTile(
                                  title: const Text('Thưởng giảng viên', style: TextStyle(fontSize: 14.0,),),
                                  trailing: Text(moneyFormat(_payroll!.lecturerEducationTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                                ),
                              if(widget.empAccount.roleId == 6)
                                ListTile(
                                  title: const Text('Thưởng trợ giảng', style: TextStyle(fontSize: 14.0,),),
                                  trailing: Text(moneyFormat(_payroll!.tutorEducationTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                                ),
                              if(widget.empAccount.roleId == 6)
                                ListTile(
                                  title: const Text('Tiền thưởng CSKH', style: TextStyle(fontSize: 14.0,),),
                                  trailing: Text(moneyFormat(_payroll!.techcareEducationTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                                ),
                              ListTile(
                                title: const Text('Tiền thưởng thi đua', style: TextStyle(fontSize: 14.0,),),
                                trailing: Text(moneyFormat(_payroll!.emulationBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                              ),
                              ListTile(
                                title: const Text('Tiền thưởng tuyển dụng', style: TextStyle(fontSize: 14.0,),),
                                trailing: Text(moneyFormat(_payroll!.recruitmentBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                              ),
                              ListTile(
                                title: const Text('Tiền thưởng cá nhân', style: TextStyle(fontSize: 14.0,),),
                                trailing: Text(moneyFormat(_payroll!.personalBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                              ),
                              ListTile(
                                title: const Text('Tiền thưởng nhóm', style: TextStyle(fontSize: 14.0,),),
                                trailing: Text(moneyFormat(_payroll!.teamBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                              ),
                              ListTile(
                                title: const Text(
                                  'Thực nhận',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: Text(moneyFormat(_payroll!.actualSalaryReceived.toString()),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
  }

  void _getPayrollCompany({required bool isRefresh}) async {
    List<PayrollCompany>? result = await PayrollCompanyListViewModel().getListPayrollCompany(isRefresh: isRefresh, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate, isClosing: 1, limit: 1);

    if(result!.isNotEmpty){
      setState(() {
        _payrollCompany = result[0];
        _getPayroll(isRefresh: true);
      });
    }
  }

  void _getPayroll({required bool isRefresh}) async {
    List<Payroll>? result = await PayrollListViewModel().getListPayroll(isRefresh: isRefresh, currentPage: _currentPage, accountId: widget.empAccount.accountId, payrollCompanyId: _payrollCompany!.payrollCompanyId, limit: 1);

    if(result!.isNotEmpty){
      setState(() {
        _payroll = result[0];
      });
    }
  }
}
