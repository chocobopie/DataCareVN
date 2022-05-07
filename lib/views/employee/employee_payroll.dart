import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/PayrollCompany.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/payroll.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/view_models/payroll_company_list_view_model.dart';
import 'package:login_sample/view_models/payroll_list_view_model.dart';
import 'package:login_sample/widgets/CustomMonthPicker.dart';
import 'package:provider/provider.dart';

class EmployeePayroll extends StatefulWidget {
  const EmployeePayroll({Key? key}) : super(key: key);

  @override
  State<EmployeePayroll> createState() => _EmployeePayrollState();
}

class _EmployeePayrollState extends State<EmployeePayroll> {

  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _fromDate, _toDate;
  final int _currentPage = 0;
  int _maxPages = 0;
  late Account? _currentAccount;

  PayrollCompany? _payrollCompany;
  Payroll? _payroll;

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _fromDate = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    _toDate = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    _getPayrollCompany(isRefresh: true);
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
              height: MediaQuery.of(context).size.height * 0.3
          ),
          Card(
              elevation: 20.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
              child: ListView(
                padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 5.0),
                children: <Widget>[
                  Container(
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
                          _payrollCompany = null;
                          _payroll = null;

                          setState(() {
                            _selectedMonth = date;
                          });

                          _fromDate = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
                          _toDate = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
                          _getPayrollCompany(isRefresh: true);
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
                  const SizedBox(height: 20.0,),
                  //Lương
                  _maxPages >= 0 ? _payroll != null ? Container(
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
                        trailing: Text('${moneyFormat(_payroll!.actualSalaryReceived.toString())} VNĐ'),
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
                          if(_currentAccount!.roleId == 3 || _currentAccount!.roleId == 4 || _currentAccount!.roleId == 5)
                            ListTile(
                              title: const Text('Thưởng ký mới', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.newSignPersonalSalesBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 3 || _currentAccount!.roleId == 4 || _currentAccount!.roleId == 5)
                            ListTile(
                              title: const Text('Thưởng tái ký', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.renewedPersonalSalesBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 3 || _currentAccount!.roleId == 4 || _currentAccount!.roleId == 5)
                            ListTile(
                              title: const Text('Thưởng quản lý bán hàng', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.managementSalesBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 3 || _currentAccount!.roleId == 4 || _currentAccount!.roleId == 5)
                            ListTile(
                              title: const Text('Thưởng hỗ trợ bán hàng', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.supporterSalesBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 3 || _currentAccount!.roleId == 4 || _currentAccount!.roleId == 5)
                            ListTile(
                              title: const Text('Thưởng CLB 20', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.clB20SalesBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Thưởng quản lý Fanpage', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.contentManagerFanpageTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Thưởng cộng tác quản lý Fanpage', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.collaboratorFanpageTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Thưởng tái ký quản lý Fanpage', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.renewedFanpageTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Thưởng quản lý nội dung Ads cho website', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.contentManagerWebsiteAdsTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Thưởng cộng tác  quản lý website', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.collaboratorWebsiteTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Thưởng tái ký quản lý website', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.renewedWebsiteTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Thưởng cộng tác quản lý Ads', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.collaboratorAdsTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Thưởng giảng viên', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.lecturerEducationTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Thưởng trợ giảng', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.tutorEducationTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
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
                            trailing: Text('${moneyFormat(_payroll!.actualSalaryReceived.toString())} VNĐ',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) : const Center(child: CircularProgressIndicator()) : const Center(child: Text('Không có dữ liệu')),
                  const SizedBox(height: 20.0,),
                ],
              )
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Xem lương",
                style: TextStyle(
                    letterSpacing: 0.0,
                    fontSize: 20.0,
                    color: Colors.blueGrey
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _getPayrollCompany({required bool isRefresh}) async {
    setState(() {
      _maxPages = 1;
    });

    List<PayrollCompany>? result = await PayrollCompanyListViewModel().getListPayrollCompany(isRefresh: isRefresh, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate, limit: 1);

    if(result!.isNotEmpty){
      setState(() {
        _payrollCompany = result[0];
        _maxPages = 1;
        _getPayroll(isRefresh: true);
      });
    }else{
      setState(() {
        _maxPages = -1;
      });
    }
  }

  void _getPayroll({required bool isRefresh}) async {
    setState(() {
      _maxPages = 1;
    });

    List<Payroll>? result = await PayrollListViewModel().getListPayroll(isRefresh: isRefresh, currentPage: _currentPage, accountId: _currentAccount!.accountId, payrollCompanyId: _payrollCompany!.payrollCompanyId, limit: 1);

    if(result!.isNotEmpty){
      setState(() {
        _payroll = result[0];
        _maxPages = 1;
      });
    }else{
      setState(() {
        _maxPages = -1;
      });
    }
  }
}


class BonusExpansionTile2 extends StatelessWidget {
  const BonusExpansionTile2({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          colors: [Colors.green, Colors.white],
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text('Thưởng'),
          trailing: const Text('2.060.500 VNĐ'),
          children: <Widget>[
            const Divider(color: Colors.blueGrey, thickness: 1.0,),
            ListTile(
              title: const Text('Cá nhân', style: TextStyle(fontSize: 12.0,),),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: const <Widget>[
                      Text('Ký mới', style: TextStyle(fontSize: 12.0,),),
                      Text('99.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
                    ],
                  ),
                  const SizedBox(width: 20.0,),
                  Column(
                    children: const <Widget>[
                      Text('Tái ký', style: TextStyle(fontSize: 12.0,),),
                      Text('297.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
                    ],
                  )
                ],
              ),
            ),
            const ListTile(
              title: Text('Quản lý', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('964.500 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            const ListTile(
              title: Text('Người hỗ trợ', style: TextStyle(fontSize: 12.0,),),
            ),
            const ListTile(
              title: Text('CLB 20', style: TextStyle(fontSize: 12.0,),),
            ),
            const ListTile(
              title: Text(
                'Thực nhận',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Text(''
                  '2.060.500 VNĐ',
                style: TextStyle(
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
}

class PayrollExpansionTile extends StatelessWidget {
  const PayrollExpansionTile({
    Key? key, required this.selectedDate, required this.payrollTitleStatus, required this.currentAccount,
  }) : super(key: key);

  final DateTime selectedDate;
  final String payrollTitleStatus;
  final Account currentAccount;

  @override
  Widget build(BuildContext context) {
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
          colors: [Colors.red, Colors.white],
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text('Lương tháng ${DateFormat('dd-MM-yyyy').format(selectedDate).substring(3, 10)} - $payrollTitleStatus', style: const TextStyle(fontSize: 14.0),),
          trailing: const Text('14.670.000 VNĐ'),
          children: <Widget>[
            const Divider(color: Colors.blueGrey, thickness: 1.0,),
            if(currentAccount.roleId != 1)
            const ListTile(
              title: Text('Hợp đồng đào tạo - Ký mới', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('1.500.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            if(currentAccount.roleId != 1)
            const ListTile(
              title: Text('Tiền quảng cáo', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('500.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            if(currentAccount.roleId != 1)
            const ListTile(
              title: Text('Tiền thưởng hỗ trợ sale', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('500.0000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            if(currentAccount.roleId != 1)
            const ListTile(
              title: Text('Tiền thưởng quản lý Fanpage', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('200.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            if(currentAccount.roleId != 1)
            const ListTile(
              title: Text('Tiền thưởng quản lý content cho Fanpage', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('700.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: const Text('Lương cơ bản', style: TextStyle(fontSize: 12.0,),),
              trailing: Text(currentAccount.roleId == 1 ? '10.000.000 VNĐ' : '3.000.000 VNĐ' , style: const TextStyle(fontSize: 12.0,),),
            ),
            const ListTile(
              title: Text('Tiền gửi xe', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('30.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            const ListTile(
              title: Text('Tiền phạt', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('0 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            const ListTile(
              title: Text('Bảo hiểm cá nhân', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('100.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            const ListTile(
              title: Text('Bảo hiểm công ty đóng', style: TextStyle(fontSize: 12.0,),),
              trailing: Text('100.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
            ),
            ListTile(
              title: const Text(
                'Thực nhận',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Text( currentAccount.roleId != 1 ? '14.670.000 VNĐ' : '9.770.000 VNĐ',
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
}
