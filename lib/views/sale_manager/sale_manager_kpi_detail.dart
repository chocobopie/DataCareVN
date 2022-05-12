import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/PayrollCompany.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/payroll.dart';
import 'package:login_sample/models/sale.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/payroll_company_list_view_model.dart';
import 'package:login_sample/view_models/payroll_list_view_model.dart';
import 'package:login_sample/view_models/sale_list_view_model.dart';

class SaleManagerKpiDetail extends StatefulWidget {
  const SaleManagerKpiDetail({Key? key, required this.saleEmployee, required this.fromDate, required this.toDate}) : super(key: key);

  final Account saleEmployee;
  final DateTime fromDate;
  final DateTime toDate;

  @override
  _SaleManagerKpiDetailState createState() => _SaleManagerKpiDetailState();
}

class _SaleManagerKpiDetailState extends State<SaleManagerKpiDetail> {

  Payroll? _payroll;
  Sale? _sale;
  PayrollCompany? _payrollCompany;
  num _totalRevenue = 0;

  @override
  void initState() {
    super.initState();
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
              child: _payrollCompany != null && _payroll != null && _sale != null ? ListView(
                padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 5.0),
                children: <Widget>[
                  //Doanh thu
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
                          initiallyExpanded: true,
                          title: Text('Doanh thu tháng ${DateFormat('MM-yyyy').format(widget.fromDate)}'),
                          trailing: Text('${moneyFormat(_totalRevenue.toString())} đ'),
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
                                      const Text('Ký mới', style: TextStyle(fontSize: 12.0,),),
                                      Text(moneyFormat(_sale!.newSignFacebookContentSales.toString()), style: const TextStyle(fontSize: 12.0,),),
                                    ],
                                  ),
                                  const SizedBox(width: 20.0,),
                                  Column(
                                    children: <Widget>[
                                      const Text('Tái ký', style: TextStyle(fontSize: 12.0,),),
                                      Text(moneyFormat(_sale!.renewedFacebookContentSales.toString()), style: const TextStyle(fontSize: 12.0),),
                                    ],
                                  ),
                                ],
                              )
                          ),
                          ListTile(
                              title: const Text('Đào tạo', style: TextStyle(fontSize: 12.0,),),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      const Text('Ký mới', style: TextStyle(fontSize: 12.0,),),
                                      Text(moneyFormat(_sale!.newSignEducationSales.toString()), style: const TextStyle(fontSize: 12.0),),
                                    ],
                                  ),
                                  const SizedBox(width: 20.0,),
                                  Column(
                                    children: <Widget>[
                                      const Text('Tái ký', style: TextStyle(fontSize: 12.0,),),
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
                                      const Text('Ký mới', style: TextStyle(fontSize: 12.0,),),
                                      Text(moneyFormat(_sale!.newSignWebsiteContentSales.toString()), style: const TextStyle(fontSize: 12.0),),
                                    ],
                                  ),
                                  const SizedBox(width: 20.0,),
                                  Column(
                                    children: <Widget>[
                                      const Text('Tái ký', style: TextStyle(fontSize: 12.0,),),
                                      Text(moneyFormat(_sale!.renewedWebsiteContentSales.toString()), style: const TextStyle(fontSize: 12.0),),
                                    ],
                                  ),
                                ],
                              )
                          ),
                          ListTile(
                              title: const Text('Ads', style: TextStyle(fontSize: 12.0,),),
                              trailing: Padding(
                                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.2),
                                child: Text(moneyFormat(_sale!.adsSales.toString()), style: const TextStyle(fontSize: 12.0),),
                              ),
                          ),
                          const Divider(color: Colors.grey,thickness: 1.0,),
                          ListTile(
                            title: const Text('KPI', style: TextStyle(fontSize: 12.0,),),
                            trailing: Text(moneyFormat(_sale!.kpi.toString()), style: const TextStyle(fontSize: 12.0,),),
                          ),
                          ListTile(
                            title: const Text('Phần trăm đạt KPI', style: TextStyle(fontSize: 12.0,),),
                            trailing: Text( '${((_totalRevenue / _sale!.kpi) * 100).round()} %', style: const TextStyle(fontSize: 12.0,),),
                          ),
                          ListTile(
                            title: const  Text('Doanh thu đạt được',
                              style: TextStyle(
                                  color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text('${moneyFormat(_totalRevenue.toString())} đ',
                            style: const  TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                ],
              ) : const Center(child: CircularProgressIndicator())
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(// Add AppBar here only
              iconTheme: const IconThemeData(color: Colors.blueGrey),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text(
                "Báo cáo doanh thu ${widget.saleEmployee.fullname}",
                style: const TextStyle(
                  letterSpacing: 0.0,
                  fontSize: 16.0,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getPayrollCompany({required bool isRefresh}) async {
    List<PayrollCompany>? result = await PayrollCompanyListViewModel().getListPayrollCompany(isRefresh: isRefresh, currentPage: 0, fromDate: widget.fromDate, toDate: widget.toDate, isClosing: 1, limit: 1);

    if(result!.isNotEmpty){
      setState(() {
        _payrollCompany = null;
        _payrollCompany = result[0];
      });
      _getPayroll(isRefresh: true);
    }
  }

  void _getPayroll({required bool isRefresh}) async {
    List<Payroll>? result = await PayrollListViewModel().getListPayroll(isRefresh: isRefresh, currentPage: 0, payrollCompanyId: _payrollCompany!.payrollCompanyId, limit: 1, accountId: widget.saleEmployee.accountId);

    if(result!.isNotEmpty){
      setState(() {
        _payroll = null;
        _payroll = result[0];
      });
      final result2 = await _getSale(isRefresh: true, payrollId: _payroll!.payrollId);
      setState(() {
        _sale = result2![0];
        _totalRevenue = _sale!.adsSales + _sale!.newSignWebsiteContentSales + _sale!.newSignEducationSales + _sale!.newSignFacebookContentSales
        + _sale!.renewedWebsiteContentSales + _sale!.renewedEducationSales + _sale!.renewedFacebookContentSales;
      });
    }
  }

  Future<List<Sale>?> _getSale({required bool isRefresh, required int payrollId}) async {

    List<Sale>? result = await SaleListViewModel().getListSales(isRefresh: isRefresh, currentPage: 0, payrollId: payrollId ,limit: 1, payrollCompanyId: _payrollCompany!.payrollCompanyId);

    return result;
  }
}
