import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/PayrollCompany.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/models/payroll.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/models/sale.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/view_models/account_list_view_model.dart';
import 'package:login_sample/view_models/payroll_company_list_view_model.dart';
import 'package:login_sample/view_models/payroll_list_view_model.dart';
import 'package:login_sample/view_models/sale_list_view_model.dart';
import 'package:login_sample/widgets/CustomMonthPicker.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/sale_manager/sale_manager_payroll_detail.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';


class SaleManagerPayrollManagement extends StatefulWidget {
  const SaleManagerPayrollManagement({Key? key}) : super(key: key);

  @override
  _SaleManagerPayrollManagementState createState() => _SaleManagerPayrollManagementState();
}

class _SaleManagerPayrollManagementState extends State<SaleManagerPayrollManagement> {

  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month - 1);
  DateTime? _fromDate, _toDate, _maxTime;
  final int _currentPage = 0;
  Account? _currentAccount;
  List<Team> _teams = [];
  final List<Payroll> _payrolls = [];
  final List<Account> _saleEmployees = [];
  final List<Sale> _sales = [];
  num _totalRevenue = 0;

  PayrollCompany? _payrollCompany;

  @override
  void initState() {
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getListSaleEmployee();
    _fromDate = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    _toDate = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    _maxTime = _selectedMonth;
    _teams = getTeamListInDepartment(department: Department(departmentId: _currentAccount!.departmentId, blockId: _currentAccount!.blockId!, name: ''));
    _getPayrollCompany(isRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double leftRight = MediaQuery.of(context).size.width;
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
                  //Nút chọn tháng
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
                                maxTime: _maxTime!,
                                locale: LocaleType.vi,
                            ),
                        );

                        if (date != null) {
                          setState(() {
                            _payrollCompany = null;
                            _payrolls.clear();
                            _sales.clear();
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
                ],
              )
          ),

          _payrollCompany != null && _payrolls.isNotEmpty  && _sales.isNotEmpty ? Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.21),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                elevation: 100.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                child: ListView(
                   children: <Widget>[
                     Padding(
                       padding: EdgeInsets.only(left: leftRight * 0.04, right: leftRight * 0.04),
                       child: SizedBox(
                         child: TextField(
                           readOnly: true,
                           decoration: InputDecoration(
                             floatingLabelBehavior: FloatingLabelBehavior.always,
                             contentPadding: const EdgeInsets.only(left: 20.0),
                             labelText: 'Tổng doanh thu của phòng tháng ${DateFormat('dd-MM-yyyy').format(_selectedMonth).substring(3, 10)}',
                             hintText: moneyFormat(_totalRevenue.toString()),
                             labelStyle: const TextStyle(
                               color: Color.fromARGB(255, 107, 106, 144),
                               fontSize: 18,
                               fontWeight: FontWeight.w500,
                             ),
                             enabledBorder: OutlineInputBorder(
                               borderSide: BorderSide(
                                   color: Colors.grey.shade300,
                                   width: 2),
                               borderRadius: BorderRadius.circular(10),
                             ),
                             focusedBorder: OutlineInputBorder(
                               borderSide: const BorderSide(
                                   color: Colors.blue,
                                   width: 2),
                               borderRadius: BorderRadius.circular(10),
                             ),
                           ),
                         ),
                       ),
                     ),
                     const SizedBox(height: 20.0,),

                     Padding(
                       padding: EdgeInsets.only(left: leftRight * 0.04, right: leftRight * 0.04),
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
                             colors: [Colors.green, Colors.white],
                           ),
                         ),
                         child: _currentAccount != null ? ListTile(
                           title: Text(_currentAccount!.fullname!, style: const TextStyle(fontSize: 12.0,),),
                           trailing: Row(
                             mainAxisSize: MainAxisSize.min,
                             children: <Widget>[
                               Text('KPI: ${moneyFormat(_getKPIPercent(employee: _currentAccount!).toString())}%', style: const TextStyle(fontSize: 10.0,),),
                               TextButton.icon(
                                 onPressed: (){
                                   Navigator.push(context, MaterialPageRoute(
                                       builder: (context) => SaleManagerPayrollDetail(
                                         saleEmployee: _currentAccount!,
                                         fromDate: _fromDate!,
                                         toDate: _toDate!,
                                       ),
                                   ));
                                 },
                                 icon: const Icon(Icons.attach_money),
                                 label: Text(moneyFormat(_getSaleEach(employee: _currentAccount!).toString()), style: const TextStyle(fontSize: 12.0,),),
                               ),
                             ],
                           ),
                           subtitle: const Text('Trưởng phòng kinh doanh', style: TextStyle(fontSize: 12.0,),),
                           dense: true,
                         ) : const Center(child: CircularProgressIndicator()),
                       ),
                     ),
                     const SizedBox(height: 20.0,),

                     (_teams.isNotEmpty && _saleEmployees.isNotEmpty) ? Padding(
                       padding: EdgeInsets.only(left: leftRight * 0.04, right: leftRight * 0.04),
                       child: Theme(
                         data: ThemeData().copyWith(dividerColor: Colors.transparent),
                         child: ListView.builder(
                           physics: const NeverScrollableScrollPhysics(),
                           shrinkWrap: true,
                           itemCount: _teams.length,
                           itemBuilder: (context, index){
                             final _team = _teams[index];
                             num _totalRevenueTeam = 0;
                             List<Account> _saleEmpListView = [];
                             for(int i = 0; i < _saleEmployees.length; i++){
                               if(_saleEmployees[i].teamId == _team.teamId){
                                 _saleEmpListView.add(_saleEmployees[i]);
                                 _totalRevenueTeam = _totalRevenueTeam + _getSaleEach(employee: _saleEmployees[i]);
                               }
                             }
                             return Padding(
                               padding: const EdgeInsets.only(bottom: 10.0),
                               child: Container(
                                 decoration: BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: const BorderRadius.all(
                                     Radius.circular(5.0),
                                   ),
                                   boxShadow: [
                                     BoxShadow(
                                       color: Colors.grey.withOpacity(0.5),
                                       blurRadius: 5,
                                       offset: const Offset(0, 1), // changes position of shadow
                                     ),
                                   ],
                                   gradient: const LinearGradient(
                                     stops: [0.02, 0.01],
                                     colors: [mainBgColor, Colors.white],
                                   ),
                                 ),
                                 child: ExpansionTile(
                                   collapsedBackgroundColor: mainBgColor,
                                   trailing: TextButton.icon(onPressed: (){}, icon: const Icon(Icons.attach_money),
                                       label: Text(moneyFormat(_totalRevenueTeam.toString()))
                                   ),
                                   subtitle: const Text(
                                     'Tổng doanh thu của nhóm:',
                                     style: TextStyle(
                                       fontSize: 12.0,
                                       color: Colors.red,
                                     ),
                                   ),
                                   title: Text(
                                     _team.name,
                                     style: const TextStyle(
                                       color: Colors.black,
                                     ),
                                   ),
                                   children: <Widget>[
                                     const Divider(color: mainBgColor, thickness: 1.0,),
                                     ListView.builder(
                                         physics: const NeverScrollableScrollPhysics(),
                                         shrinkWrap: true,
                                         itemCount: _saleEmpListView.length,
                                         itemBuilder: (context, index){
                                           final _saleEmployee = _saleEmpListView[index];
                                             return ListTile(
                                             title: Text(_saleEmployee.fullname!, style: const TextStyle(fontSize: 12.0,),),
                                             trailing: Row(
                                               mainAxisSize: MainAxisSize.min,
                                               children: <Widget>[
                                                 Text(
                                                   'KPI: ${_getKPIPercent(employee: _saleEmployee)}%',
                                                   style: const TextStyle(
                                                     fontSize: 10.0,
                                                   ),
                                                 ),
                                                 TextButton.icon(
                                                   onPressed: (){
                                                     Navigator.push(context, MaterialPageRoute(
                                                         builder: (context) => SaleManagerPayrollDetail(
                                                           saleEmployee: _saleEmployee,
                                                           fromDate: _fromDate!,
                                                           toDate: _toDate!,
                                                         )
                                                     ));
                                                   },
                                                   icon: const Icon(Icons.attach_money),
                                                   label: Text(moneyFormat(_getSaleEach(employee: _saleEmployee).toString()), style: const TextStyle(fontSize: 12.0,),),
                                                 ),
                                               ],
                                             ),
                                             subtitle: Text(rolesNames[_saleEmployee.roleId!], style: const TextStyle(fontSize: 12.0,),),
                                             dense: true,
                                           );
                                         }
                                     ),
                                   ],
                                 ),
                               ),
                             );
                           },
                         ),
                       ),
                     ) : const Center(child: CircularProgressIndicator()),
                   ],
                ),
              ),
            ),
          ) : const Center(child: CircularProgressIndicator()),

          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(// Add AppBar here only
              iconTheme: const IconThemeData(color: Colors.blueGrey),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Báo cáo doanh thu",
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
    List<PayrollCompany>? result = await PayrollCompanyListViewModel().getListPayrollCompany(isRefresh: isRefresh, currentPage: _currentPage, fromDate: _fromDate, toDate: _toDate, isClosing: 1, limit: 1);

    if(result!.isNotEmpty){
      setState(() {
        _payrollCompany = null;
        _payrollCompany = result[0];
      });
      _getListPayroll(isRefresh: true);
    }
  }

  void _getListPayroll({required bool isRefresh}) async {
    List<Payroll>? result = await PayrollListViewModel().getListPayroll(isRefresh: isRefresh, currentPage: _currentPage, payrollCompanyId: _payrollCompany!.payrollCompanyId, limit: 1000000);
    List<Payroll>? result2 = [];

    
    for(int i = 0; i < result!.length; i++){
      for(int j = 0; j < _saleEmployees.length; j++){
        if(_saleEmployees[j].accountId == result[i].accountId){
          result2.add(result[i]);
        }
      }
    }

    for(int i = 0; i < result2.length; i++){
      print(result2[i].payrollId);
    }

    if(result2.isNotEmpty){
      setState(() {
        _payrolls.clear();
        _payrolls.addAll(result2);
      });
      
      List<Sale>? result3 = [];
      for(int i = 0; i < result2.length; i++){
        final result = await _getSale(isRefresh: true, payrollId: result2[i].payrollId);
        result3.add(result![0]);
      }
      if(result3.isNotEmpty){
        setState(() {
          _sales.addAll(result3);
        });
      }
      for(int i = 0; i < _sales.length; i++){
        num total = _totalRevenue + _sales[i].newSignEducationSales + _sales[i].newSignFacebookContentSales + _sales[i].newSignWebsiteContentSales
            + _sales[i].renewedEducationSales + _sales[i].renewedFacebookContentSales + _sales[i].renewedWebsiteContentSales + _sales[i].adsSales;
        setState(() {
          _totalRevenue = total;
        });
      }
    }
  }

  Future<List<Sale>?> _getSale({required bool isRefresh, required int payrollId}) async {

    List<Sale>? result = await SaleListViewModel().getListSales(isRefresh: isRefresh, currentPage: _currentPage, payrollId: payrollId ,limit: 1);

    return result;
  }

  num _getSaleEach({required Account employee}){
    num number = 0;
    for(int i = 0; i < _payrolls.length; i++){
      if(employee.accountId == _payrolls[i].accountId){
        for(int j = 0; j < _sales.length; j++){
          if(_payrolls[i].payrollId == _sales[j].payrollId){
            number = _sales[j].adsSales + _sales[j].renewedWebsiteContentSales + _sales[j].renewedFacebookContentSales + _sales[j].renewedEducationSales + _sales[j].newSignWebsiteContentSales + _sales[j].newSignFacebookContentSales + _sales[j].newSignEducationSales;
          }
        }
      }
    }
    return number;
  }

  num _getKPIPercent({required Account employee}){
    num number = 0;
    for(int i = 0; i < _payrolls.length; i++){
      if(employee.accountId == _payrolls[i].accountId){
        for(int j = 0; j < _sales.length; j++){
          if(_payrolls[i].payrollId == _sales[j].payrollId){
            number = (_sales[j].adsSales + _sales[j].renewedWebsiteContentSales + _sales[j].renewedFacebookContentSales + _sales[j].renewedEducationSales
                + _sales[j].newSignWebsiteContentSales + _sales[j].newSignFacebookContentSales + _sales[j].newSignEducationSales) / _sales[i].kpi * 100;
          }
        }
      }
    }
    return number;
  }

  void _getListSaleEmployee() async {
    List<Account>? result = await AccountListViewModel().getAllSalesForDeal(isRefresh: true, currentPage: _currentPage, accountId: _currentAccount!.accountId!, limit: 1000000);

    if(result != null){
      setState(() {
        _saleEmployees.clear();
        _saleEmployees.addAll(result);
      });
    }
  }

}

