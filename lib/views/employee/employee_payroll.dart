import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/payroll_company.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/attendance_rule.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/models/payroll.dart';
import 'package:login_sample/models/sale.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/view_models/attendance_rule_view_model.dart';
import 'package:login_sample/view_models/attendance_view_model.dart';
import 'package:login_sample/view_models/deal_list_view_model.dart';
import 'package:login_sample/view_models/payroll_company_list_view_model.dart';
import 'package:login_sample/view_models/payroll_list_view_model.dart';
import 'package:login_sample/view_models/sale_list_view_model.dart';
import 'package:login_sample/views/sale_employee/sale_emp_deal_detail.dart';
import 'package:login_sample/widgets/CustomMonthPicker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EmployeePayroll extends StatefulWidget {
  const EmployeePayroll({Key? key}) : super(key: key);

  @override
  State<EmployeePayroll> createState() => _EmployeePayrollState();
}

class _EmployeePayrollState extends State<EmployeePayroll> {

  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _fromDate, _toDate;
  int _hasPayroll = 0, _hasSale = 0, _currentPage = 0, _maxPages = 0;
  int? _exceedApprovedLateCount, _exceedApprovedAbsencesCount, _lateCount, _absentCount, _attendanceCount;
  late Account? _currentAccount;
  num _totalRevenue = 0, _fineAbsence = 0, _totalFineAbsence = 0, _totalFineLate = 0;
  late final List<Deal> _deals = [];

  final RefreshController _refreshController = RefreshController();
  AttendanceRule? _attendanceRule;

  PayrollCompany? _payrollCompany;
  Payroll? _payroll;
  Sale? _sale;

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _fromDate = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    _toDate = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    _getPayrollCompany(isRefresh: true);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
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

                          setState(() {
                            _selectedMonth = date;
                            _payrollCompany = null;
                            _payroll = null;
                            _sale = null;
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
                        'Th??ng ${DateFormat('dd-MM-yyyy').format(_selectedMonth).substring(3, 10)}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  //L????ng
                  _hasPayroll >= 0 ? _payroll != null ? Container(
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
                        title: Text('L????ng ${_payrollCompany?.isClosing == 0 ? '- D??? ki???n' : ''}', style: const TextStyle(fontSize: 14.0),),
                        trailing: Text('${moneyFormat(_payroll!.total.toString())} ??'),
                        children: <Widget>[
                          const Divider(color: Colors.blueGrey, thickness: 1.0,),
                          ListTile(
                            title: const Text('L????ng c?? b???n', style: TextStyle(fontSize: 14.0,),),
                            trailing: Text(moneyFormat(_payroll!.basicSalary.toString()), style: const TextStyle(fontSize: 14.0,),),
                          ),
                          ListTile(
                            title: const Text('Tr??? c???p', style: TextStyle(fontSize: 14.0,),),
                            trailing: Text(moneyFormat(_payroll!.allowance.toString()), style: const TextStyle(fontSize: 14.0,),),
                          ),
                          ListTile(
                            title: const Text('Ti???n ????? xe', style: TextStyle(fontSize: 14.0,),),
                            trailing: Text(moneyFormat(_payroll!.parkingFee.toString()), style: const TextStyle(fontSize: 14.0,),),
                          ),
                          ListTile(
                            title: const Text('Ti???n ph???t', style: TextStyle(fontSize: 14.0,),),
                            trailing: Text(moneyFormat(_payroll!.fine.toString()), style: const TextStyle(fontSize: 14.0,),),
                          ),
                          ListTile(
                            title: const Text('B???o hi???m c?? nh??n', style: TextStyle(fontSize: 14.0,),),
                            trailing: Text(moneyFormat(_payroll!.personalInsurance.toString()), style: const TextStyle(fontSize: 14.0,),),
                          ),
                          ListTile(
                            title: const Text('B???o hi???m c??ng ty ????ng', style: TextStyle(fontSize: 14.0,),),
                            trailing: Text(moneyFormat(_payroll!.companyInsurance.toString()), style: const TextStyle(fontSize: 14.0,),),
                          ),
                          ListTile(
                            title: const Text('Thu???', style: TextStyle(fontSize: 14.0,),),
                            trailing: Text(moneyFormat(_payroll!.tax.toString()), style: const TextStyle(fontSize: 14.0,),),
                          ),
                          ListTile(
                            title: const Text('Th???c nh???n', style: TextStyle(fontSize: 14.0,),),
                            trailing: Text(moneyFormat(_payroll!.actualSalaryReceived.toString()), style: const TextStyle(fontSize: 14.0,),),
                          ),
                          if(_currentAccount!.roleId == 3 || _currentAccount!.roleId == 4 || _currentAccount!.roleId == 5)
                            ListTile(
                              title: const Text('Th?????ng c?? nh??n k?? m???i', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.newSignPersonalSalesBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 3 || _currentAccount!.roleId == 4 || _currentAccount!.roleId == 5)
                            ListTile(
                              title: const Text('Th?????ng c?? nh??n t??i k??', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.renewedPersonalSalesBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 3 || _currentAccount!.roleId == 4 || _currentAccount!.roleId == 5)
                            ListTile(
                              title: const Text('Th?????ng qu???n l?? b??n h??ng', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.managementSalesBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 3 || _currentAccount!.roleId == 4 || _currentAccount!.roleId == 5)
                            ListTile(
                              title: const Text('Th?????ng CLB 20', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.clB20SalesBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Th?????ng qu???n l?? Fanpage', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.contentManagerFanpageTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Th?????ng c???ng t??c qu???n l?? Fanpage', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.collaboratorFanpageTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Th?????ng t??i k?? qu???n l?? Fanpage', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.renewedFanpageTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Th?????ng qu???n l?? n???i dung Ads cho website', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.contentManagerWebsiteAdsTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Th?????ng c???ng t??c  qu???n l?? website', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.collaboratorWebsiteTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Th?????ng t??i k?? qu???n l?? website', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.renewedWebsiteTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Th?????ng c???ng t??c qu???n l?? Ads', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.collaboratorAdsTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Th?????ng gi???ng vi??n', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.lecturerEducationTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Th?????ng tr??? gi???ng', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.tutorEducationTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          if(_currentAccount!.roleId == 6)
                            ListTile(
                              title: const Text('Ti???n th?????ng CSKH', style: TextStyle(fontSize: 14.0,),),
                              trailing: Text(moneyFormat(_payroll!.techcareEducationTechnicalEmployeeBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                            ),
                          ListTile(
                            title: const Text('Ti???n th?????ng thi ??ua', style: TextStyle(fontSize: 14.0,),),
                            trailing: Text(moneyFormat(_payroll!.emulationBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                          ),
                          ListTile(
                            title: const Text('Ti???n th?????ng tuy???n d???ng', style: TextStyle(fontSize: 14.0,),),
                            trailing: Text(moneyFormat(_payroll!.recruitmentBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                          ),
                          ListTile(
                            title: const Text('Ti???n th?????ng c?? nh??n', style: TextStyle(fontSize: 14.0,),),
                            trailing: Text(moneyFormat(_payroll!.personalBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                          ),
                          ListTile(
                            title: const Text('Ti???n th?????ng nh??m', style: TextStyle(fontSize: 14.0,),),
                            trailing: Text(moneyFormat(_payroll!.teamBonus.toString()), style: const TextStyle(fontSize: 14.0,),),
                          ),
                          ListTile(
                            title: const Text(
                              'T???ng ti???n',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text('${moneyFormat(_payroll!.total.toString())} ??',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) : const Center(child: CircularProgressIndicator())
                      : Container(
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
                        child: const ExpansionTile(
                          trailing: SizedBox(),
                          title: Text('Kh??ng c?? d??? li???u c???a l????ng'),
                        ),
                      )
                  ),
                  const SizedBox(height: 10.0,),

                  //Doanh thu
                  if(_currentAccount!.roleId == 3 || _currentAccount!.roleId == 4 || _currentAccount!.roleId == 5)
                  _hasSale >= 0 ? _sale != null ? Container(
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
                        initiallyExpanded: false,
                        title: const Text('Doanh thu', style: TextStyle(fontSize: 14.0),),
                        trailing: Text('${moneyFormat(_totalRevenue.toString())} ??'),
                        children: <Widget>[
                          const Divider(color: Colors.blueGrey, thickness: 1.0,),
                          ListTile(
                              title: const Text(
                                'Facebook content',
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      const Text('K?? m???i', style: TextStyle(fontSize: 12.0,),),
                                      Text(moneyFormat(_sale!.newSignFacebookContentSales.toString()), style: const TextStyle(fontSize: 12.0,),),
                                    ],
                                  ),
                                  const SizedBox(width: 20.0,),
                                  Column(
                                    children: <Widget>[
                                      const Text('T??i k??', style: TextStyle(fontSize: 12.0,),),
                                      Text(moneyFormat(_sale!.renewedFacebookContentSales.toString()), style: const TextStyle(fontSize: 12.0),),
                                    ],
                                  ),
                                ],
                              )
                          ),
                          ListTile(
                              title: const Text('????o t???o', style: TextStyle(fontSize: 12.0,),),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      const Text('K?? m???i', style: TextStyle(fontSize: 12.0,),),
                                      Text(moneyFormat(_sale!.newSignEducationSales.toString()), style: const TextStyle(fontSize: 12.0),),
                                    ],
                                  ),
                                  const SizedBox(width: 20.0,),
                                  Column(
                                    children: <Widget>[
                                      const Text('T??i k??', style: TextStyle(fontSize: 12.0,),),
                                      Text(moneyFormat(_sale!.renewedEducationSales.toString()), style: const TextStyle(fontSize: 12.0),),
                                    ],
                                  ),
                                ],
                              )
                          ),
                          ListTile(
                              title: const Text('Website content', style: TextStyle(fontSize: 12.0,),),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      const Text('K?? m???i', style: TextStyle(fontSize: 12.0,),),
                                      Text(moneyFormat(_sale!.newSignWebsiteContentSales.toString()), style: const TextStyle(fontSize: 12.0),),
                                    ],
                                  ),
                                  const SizedBox(width: 20.0,),
                                  Column(
                                    children: <Widget>[
                                      const Text('T??i k??', style: TextStyle(fontSize: 12.0,),),
                                      Text(moneyFormat(_sale!.renewedWebsiteContentSales.toString()), style: const TextStyle(fontSize: 12.0),),
                                    ],
                                  ),
                                ],
                              )
                          ),
                          ListTile(
                            title: const Text('Ads', style: TextStyle(fontSize: 12.0,),),
                            trailing: Text(moneyFormat(_sale!.adsSales.toString()), style: const TextStyle(fontSize: 12.0),),
                          ),
                          const Divider(color: Colors.grey,thickness: 1.0,),
                          ListTile(
                            title: const Text('KPI', style: TextStyle(fontSize: 12.0,),),
                            trailing: Text(moneyFormat(_sale!.kpi.toString()), style: const TextStyle(fontSize: 12.0,),),
                          ),
                          ListTile(
                            title: const Text('Ph???n tr??m ?????t KPI', style: TextStyle(fontSize: 12.0,),),
                            trailing: Text( '${((_totalRevenue / _sale!.kpi) * 100).toStringAsFixed(2)} %', style: const TextStyle(fontSize: 12.0,),),
                          ),
                          ListTile(
                            title: const  Text('Doanh thu ?????t ???????c',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text('${moneyFormat(_totalRevenue.toString())} ??',
                              style: const  TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ) : const Center(child: CircularProgressIndicator())
                      : Container(
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
                        child: const ExpansionTile(
                          trailing: SizedBox(),
                          title: Text('Kh??ng c?? d??? li???u c???a doanh thu'),
                        ),
                      )
                  ),
                  const SizedBox(height: 10.0,),

                  //H???p ?????ng
                  if(_currentAccount!.roleId == 3 || _currentAccount!.roleId == 4 || _currentAccount!.roleId == 5)
                      _maxPages >= 0 ? _deals.isNotEmpty ? Container(
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
                            title: const Text('Danh s??ch h???p ?????ng ???? xu???ng ti???n', style: TextStyle(fontSize: 14.0),),
                            children: <Widget>[
                              const Divider(color: Colors.blueGrey, thickness: 1.0,),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: SmartRefresher(
                                  controller: _refreshController,
                                  enablePullUp: true,
                                  onRefresh: () async{
                                    _refreshController.refreshCompleted();
                                  },
                                  child: ListView.builder(
                                    itemBuilder: (context, index){
                                      final deal = _deals[index];
                                      return Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0, left: 15.0),
                                          child: Card(
                                            elevation: 10.0,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) => SaleEmpDealDetail(deal: deal, readOnly: true,)
                                                ));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          const Text('M?? s??? h???p ?????ng:', style: TextStyle(fontSize: 12.0),),
                                                          const Spacer(),
                                                          Text('${deal.dealId}', style: const TextStyle(fontSize: 14.0),),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          const Text('Lo???i d???ch v???:', style: TextStyle(fontSize: 12.0),),
                                                          const Spacer(),
                                                          Text( dealServicesNames[deal.serviceId], style: const TextStyle(fontSize: 14.0)),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          const Text('Lo???i h???p ?????ng:', style: TextStyle(fontSize: 12.0),),
                                                          const Spacer(),
                                                          Text( dealTypesNames[deal.dealTypeId], style: const TextStyle(fontSize: 14.0)),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          const Text('S??? ti???n:', style: TextStyle(fontSize: 12.0),),
                                                          const Spacer(),
                                                          Text(deal.amount > 0 ? '${formatNumber(deal.amount.toString().replaceAll('.', ''))} ??' : 'Ch??a ch???t gi??', style: const TextStyle(fontSize: 14.0),),
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
                                    itemCount: _deals.length,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ) : const Center(child: CircularProgressIndicator()) : Container(
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
                            child: const ExpansionTile(
                              trailing: SizedBox(),
                              title: Text('Kh??ng c?? d??? li???u c???a c??c h???p ?????ng ???? xu???ng ti???n'),
                            ),
                          )
                      ),

                  if(_payroll != null)
                  if( (_fromDate!.month != DateTime.now().month && _fromDate!.year == DateTime.now().year) || _fromDate!.year != DateTime.now().year)
                  (_lateCount != null && _absentCount != null && _exceedApprovedAbsencesCount != null && _exceedApprovedLateCount != null && _attendanceRule != null ) ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
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
                          title: const Text('Ti???n ph???t', style: TextStyle(fontSize: 14.0),),
                          trailing: Text('${moneyFormat((_totalFineLate + _totalFineAbsence).toString())}??'),
                          children: <Widget>[
                            const Divider(color: Colors.blueGrey, thickness: 1.0,),
                            Column(
                              children: [
                                ExpansionTile(
                                    title: const Text('Tr???'),
                                    trailing: Text('${ moneyFormat( ((_attendanceRule!.fineForEachLateShift * _lateCount!) + (_attendanceRule!.fineForEachLateShift * _exceedApprovedLateCount!)).toString() ) }??'),
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                              child: Row(
                                                children: [
                                                  const Expanded(flex: 4,child: Text('S??? ca kh??ng ph??p')),
                                                  const Spacer(),
                                                  Text('$_lateCount'),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                              child: Row(
                                                children: [
                                                  const Expanded(flex: 4,child: Text('S??? ca v?????t qu?? s??? l???n cho ph??p')),
                                                  const Spacer(),
                                                  Text('$_exceedApprovedLateCount'),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                              child: Row(
                                                children: [
                                                  const Expanded(flex: 4,child: Text('S??? ti???n ph???t/l???n')),
                                                  const Spacer(),
                                                  Text('${moneyFormat(_attendanceRule!.fineForEachLateShift.toString())}??'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                ),
                              ],
                            ),
                            const Divider(color: Colors.grey,),
                            ExpansionTile(
                              title: const Text('V???ng'),
                              trailing: Text('${moneyFormat( _totalFineAbsence.toString() )}??'),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                        child: Row(
                                          children: [
                                            const Expanded(flex: 4,child: Text('S??? ca kh??ng ph??p')),
                                            const Spacer(),
                                            Text('$_absentCount'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                        child: Row(
                                          children: [
                                            const Expanded(flex: 4,child: Text('S??? ca v?????t qu?? s??? l???n cho ph??p')),
                                            const Spacer(),
                                            Text('$_exceedApprovedAbsencesCount'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                        child: Row(
                                          children: [
                                            const Expanded(flex: 4,child: Text('S??? ti???n ph???t/l???n')),
                                            const Spacer(),
                                            Text('${moneyFormat(_fineAbsence.toString())}??'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ) : const Center(child: CircularProgressIndicator()),
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
                "Xem l????ng",
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
      _hasPayroll = 0;
      _hasSale = 0;
      _maxPages = 0;
      _payrollCompany = null;
      _payroll = null;
      _sale = null;
      _lateCount = null;
      _absentCount = null;
      _attendanceCount = null;
      _exceedApprovedLateCount = null;
      _exceedApprovedAbsencesCount = null;
      _deals.clear();
    });

    List<PayrollCompany>? result = await PayrollCompanyListViewModel().getListPayrollCompany(isRefresh: isRefresh, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate, limit: 1);

    if(result!.isNotEmpty){
      setState(() {
        _payrollCompany = result[0];
        _hasPayroll = 1;
        _getPayroll(isRefresh: true);
      });
    }else{
      setState(() {
        _hasPayroll = -1;
        _hasSale = -1;
        _maxPages = -1;
      });
    }
  }

  void _getPayroll({required bool isRefresh}) async {
    setState(() {
      _hasPayroll = 0;
      _hasSale = 0;
      _maxPages = 0;
    });

    List<Payroll>? result = await PayrollListViewModel().getListPayroll(isRefresh: isRefresh, currentPage: _currentPage, accountId: _currentAccount!.accountId, payrollCompanyId: _payrollCompany!.payrollCompanyId, limit: 1);

    if(result!.isNotEmpty){
      setState(() {
        _payroll = null;
        _payroll = result[0];
        _hasPayroll = 1;
      });

      _getCountAttendance();
      _getAttendanceRule();
      _getExceedApprovedAbsencesCount();
      _getExceedApprovedLateCount();

      if(_currentAccount!.roleId == 3 || _currentAccount!.roleId == 4 || _currentAccount!.roleId == 5)
        {
          _getSale(isRefresh: true);
        }
    }else{
      setState(() {
        _hasPayroll = -1;
        _hasSale = -1;
        _maxPages = -1;
      });
    }
  }

  void _getSale({required bool isRefresh}) async {
    setState(() {
      _hasSale = 0;
      _maxPages = 0;
    });

    List<Sale>? result = await SaleListViewModel().getListSales(isRefresh: isRefresh, currentPage: 0, payrollCompanyId: _payrollCompany!.payrollCompanyId, payrollId: _payroll!.payrollId, limit: 1);

    if(result!.isNotEmpty){
      setState(() {
        _sale = null;
        _sale = result[0];
        _hasSale = 1;
        _totalRevenue = _sale!.adsSales + _sale!.newSignWebsiteContentSales + _sale!.newSignEducationSales + _sale!.newSignFacebookContentSales
            + _sale!.renewedWebsiteContentSales + _sale!.renewedEducationSales + _sale!.renewedFacebookContentSales;
      });
      print(_sale!.saleId);
      _getDealListBySaleId(isRefresh: true);
    }else{
      setState(() {
        _hasSale = -1;
        _maxPages = -1;
      });
    }
  }

  void _getDealListBySaleId({required bool isRefresh}) async {
    setState(() {
      _maxPages = 0;
    });

    List<Deal>? result = await DealListViewModel().getDealListBySaleId(saleId: _sale!.saleId, isRefresh: isRefresh, currentPage: 0, limit: 1000000);

    if(result!.isNotEmpty){
      setState(() {
        _deals.clear();
        _deals.addAll(result);
        _maxPages = _deals[0].maxPage!;
        _refreshController.loadNoData();
      });
    }else{
      setState(() {
        _maxPages = -1;
      });
    }
  }

  void _getCountAttendance() async {
    setState(() {
      _lateCount = null;
      _absentCount = null;
      _attendanceCount = null;
    });

    int? result = await AttendanceViewModel().getCountAttendance(accountId: _currentAccount!.accountId!, fromDate: _fromDate!, toDate: _toDate!);
      setState(() {
        _attendanceCount = result;
    });


    for(int i = 3; i < 5; i++){
      int? result2 = await AttendanceViewModel().getCountAttendance(accountId: _currentAccount!.accountId!, fromDate: _fromDate!, toDate: _toDate!, attendanceStatusId: i);
      setState(() {
        if(i == 3){_lateCount = result2;}
        if(i == 4){_absentCount = result2;}
      });
    }

    _getFineAbsence();
  }

  void _getExceedApprovedLateCount() async {
    setState(() {
      _exceedApprovedLateCount = null;
    });

    int? result = await AttendanceViewModel().getExceedApprovedLateCount(accountId: _currentAccount!.accountId!, fromDate: _fromDate!);
    setState(() {
      _exceedApprovedLateCount = result;
    });
  }

  void _getExceedApprovedAbsencesCount() async {
    setState(() {
      _exceedApprovedAbsencesCount = null;
    });

    int? result = await AttendanceViewModel().getExceedApprovedAbsencesCount(accountId: _currentAccount!.accountId!, fromDate: _fromDate!);
    setState(() {
      _exceedApprovedAbsencesCount = result;
    });
  }

  void _getFineAbsence() {
    num money = _payroll!.basicSalary / _attendanceCount!;
    setState(() {
      _fineAbsence = money.round();
    });

    num money2 = (_fineAbsence * _absentCount!) + (_fineAbsence * _exceedApprovedAbsencesCount! );
    setState(() {
      _totalFineAbsence = money2;
    });

    num money3 = (_attendanceRule!.fineForEachLateShift * _lateCount!) + (_attendanceRule!.fineForEachLateShift * _exceedApprovedLateCount!);
    setState(() {
      _totalFineLate = money3;
    });
  }

  void _getAttendanceRule() async {
    AttendanceRule? result = await AttendanceRuleViewModel().getAttendanceRule();
    if(result != null){
      setState(() {
        _attendanceRule = result;
      });
    }
  }
}
