import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/application.dart';
import 'package:login_sample/models/fromDateToDate.dart';
import 'package:login_sample/models/sort_item.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/account_list_view_model.dart';
import 'package:login_sample/view_models/application_list_view_model.dart';
import 'package:login_sample/views/hr_manager/hr_manager_attendance_report_list.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_date_filter.dart';
import 'package:login_sample/widgets/CustomDropDownFormField2Filter.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HrManagerApplicationList extends StatefulWidget {
  const HrManagerApplicationList({Key? key}) : super(key: key);

  @override
  _HrManagerApplicationListState createState() => _HrManagerApplicationListState();
}

class _HrManagerApplicationListState extends State<HrManagerApplicationList> {

  Account? _currentAccount;
  String _fromCreatedDateToDateString = 'Ngày gửi đơn', _fromAssignedDateToDateString = 'Ngày phép';
  int? _applicationStatusId, _periodOfDayId;
  DateTime? _fromCreatedDate, _toCreatedDate, _fromAssignedDate, _toAssignedDate;
  int _currentPage = 0, _maxPages = 0;

  final RefreshController _refreshController = RefreshController();
  final List<Application> _applications = [];
  late final List<Account> _employeeList = [];

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getOtherApplicationList(isRefresh: true);
    _getAllEmployee();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Card(
        elevation: 10.0,
        child: _maxPages > 0 ? NumberPaginator(
          numberPages: _maxPages,
          initialPage: 0,
          buttonSelectedBackgroundColor: mainBgColor,
          onPageChange: (int index) {
            setState(() {
              _applications.clear();
              _currentPage = index;
            });
            _getOtherApplicationList(isRefresh: false);
          },
        ) : null,
      ),
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
            margin: const EdgeInsets.only(top: 100.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                  child: SizedBox(
                    height: 40.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text('Lọc theo:', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                        ),
                        const SizedBox(width: 5.0,),
                        CustomOutlinedButton(
                          title: _fromCreatedDateToDateString,
                          radius: 10.0,
                          color: mainBgColor,
                          onPressed: () async {
                            final data = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SaleEmpDateFilter(),
                            ));
                            if(data != null){
                              FromDateToDate fromDateToDate = data;
                              setState(() {
                                _fromCreatedDate = fromDateToDate.fromDate;
                                _toCreatedDate = fromDateToDate.toDate;
                                _fromCreatedDateToDateString = 'Ngày gửi đơn: ${fromDateToDate.fromDateString} → ${fromDateToDate.toDateString}';
                                _applications.clear();
                                _maxPages = 0;
                              });
                              _getOtherApplicationList(isRefresh: true);
                            }
                          },
                        ),
                        CustomOutlinedButton(
                          title: _fromAssignedDateToDateString,
                          radius: 10.0,
                          color: mainBgColor,
                          onPressed: () async {
                            final data = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SaleEmpDateFilter(),
                            ));
                            if(data != null){
                              FromDateToDate fromDateToDate = data;
                              setState(() {
                                _fromAssignedDate = fromDateToDate.fromDate;
                                _toAssignedDate = fromDateToDate.toDate;
                                _fromAssignedDateToDateString = 'Ngày phép: ${fromDateToDate.fromDateString} → ${fromDateToDate.toDateString}';
                                _applications.clear();
                                _maxPages = 0;
                              });
                              _getOtherApplicationList(isRefresh: true);
                            }
                          },
                        ),
                        SizedBox(
                          width: 120.0,
                          child: CustomDropdownFormField2Filter(
                            borderColor: mainBgColor,
                            value: _periodOfDayId == null ? null : periodOfDayNames[_periodOfDayId!],
                            label: 'Buổi xin phép',
                            items: periodOfDayNames,
                            onChanged: (value){
                              for(int i = 0; i < periodOfDay.length; i++){
                                if(value.toString() == periodOfDay[i].name){
                                  _periodOfDayId = periodOfDay[i].periodOfDayId;
                                }
                              }
                              setState(() {
                                _applications.clear();
                                _maxPages = 0;
                              });
                              _getOtherApplicationList(isRefresh: true);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 100.0,
                          child: CustomDropdownFormField2Filter(
                            borderColor: mainBgColor,
                            value: _applicationStatusId == null ? null : applicationStatusesNames[_applicationStatusId!],
                            label: 'Trạng thái',
                            items: applicationStatusesNames,
                            onChanged: (value){
                              for(int i = 0; i < applicationStatuses.length; i++){
                                if(value.toString() == applicationStatuses[i].name){
                                  _applicationStatusId = applicationStatuses[i].applicationStatusId;
                                }
                              }
                              print(_applicationStatusId);
                              setState(() {
                                _applications.clear();
                                _maxPages = 0;
                              });
                              _getOtherApplicationList(isRefresh: true);
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: (){
                              setState(() {
                                _fromCreatedDate = null;
                                _toCreatedDate = null;
                                _fromAssignedDate = null;
                                _toAssignedDate = null;
                                _fromCreatedDateToDateString = 'Ngày gửi đơn';
                                _fromAssignedDateToDateString = 'Ngày phép';
                                _applicationStatusId = null;
                                _periodOfDayId = null;
                                _applications.clear();
                                _maxPages = 0;
                              });
                              _getOtherApplicationList(isRefresh: true);
                            },
                            icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                        ),
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.20),
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
                  elevation: 20.0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  margin: const EdgeInsets.only(top: 5.0),
                  child: (_applications.isNotEmpty && _employeeList.isNotEmpty) ? SmartRefresher(
                    enablePullUp: true,
                    controller: _refreshController,
                    onRefresh: (){
                      setState(() {
                        _applications.clear();
                      });

                      _getOtherApplicationList(isRefresh: false);

                      if(_applications.isNotEmpty){
                        _refreshController.refreshCompleted();
                      }else{
                        _refreshController.refreshFailed();
                      }
                    },
                    child: ListView.builder(
                      itemCount: _applications.length,
                      itemBuilder: (context, index) {
                        final _application = _applications[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Theme(
                              data: ThemeData().copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                title: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Spacer(),
                                          Text(applicationTypesNames[_application.applicationTypeId], style: const TextStyle(fontSize: 18.0, color: defaultFontColor),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                      child: Row(
                                        children: [
                                          const Expanded(child: Text('Tên nhân viên:', style: TextStyle(fontSize: 14.0),)),
                                          const Spacer(),
                                          Text(_getEmployeeName(_application.accountId), style: const TextStyle(fontSize: 14.0),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                      child: Row(
                                        children: [
                                          const Text('Ngày gửi đơn:', style: TextStyle(fontSize: 14.0),),
                                          const Spacer(),
                                          Text(DateFormat('dd-MM-yyyy').format(_application.createdDate!), style: const TextStyle(fontSize: 14.0),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                      child: Row(
                                        children: [
                                          Text(_application.applicationTypeId == 1 ? 'Ngày xin đi trễ:' : 'Ngày xin nghỉ phép:', style: const TextStyle(fontSize: 14.0),),
                                          const Spacer(),
                                          Text(DateFormat('dd-MM-yyyy').format(_application.assignedDate), style: const TextStyle(fontSize: 14.0),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                      child: Row(
                                        children: [
                                          Text(_application.applicationTypeId == 1 ? 'Xin đi trễ buổi:' : 'Xin nghỉ phép buổi:', style: const TextStyle(fontSize: 14.0),),
                                          const Spacer(),
                                          Text(periodOfDayNames[_application.periodOfDayId!], style: const TextStyle(fontSize: 14.0),),
                                        ],
                                      ),
                                    ),
                                    if(_application.applicationTypeId == 1)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                                      child: Row(
                                        children: [
                                          const Text('Giờ dự kiến có mặt:', style: TextStyle(fontSize: 14.0),),
                                          const Spacer(),
                                          Text( '${_application.expectedWorkingTime!.hour}:${_application.expectedWorkingTime!.minute}', style: const TextStyle(fontSize: 14.0),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Column(
                                        children: <Widget>[
                                          if(_application.applicationStatusId == 0)  const Text('Mới', style: TextStyle(fontSize: 12.0, color: Colors.green),),
                                          if(_application.applicationStatusId == 1) const Text('Duyệt', style: TextStyle(fontSize: 12.0, color: Colors.blue),),
                                          if(_application.applicationStatusId == 2) const Text('Từ chối', style: TextStyle(fontSize: 12.0, color: Colors.red),),
                                          _customDropdownButton(_application, _applications.indexOf(_applications[index])),
                                        ]
                                    ),
                                  ],
                                ),
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0, bottom: 20.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: CustomEditableTextFormField(
                                              text: _application.description,
                                              title: 'Lý do',
                                              readonly: true
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ) : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),

          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),
              // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                'Duyệt đơn xin phép',
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

  void _getOtherApplicationList({required bool isRefresh}) async {

    List<Application>? result = await ApplicationListViewModel().getOtherApplicationList(isRefresh: isRefresh, currentPage: _currentPage, accountId: _currentAccount!.accountId!,
        fromCreatedDate: _fromCreatedDate, toCreatedDate: _toCreatedDate, fromAssignedDate: _fromAssignedDate, toAssignedDate: _toAssignedDate,
        applicationStatusId: _applicationStatusId, periodOfDayId: _periodOfDayId
    );

    _applications.clear();
    if(result != null){
      setState(() {
        _applications.addAll(result);
        _maxPages = _applications[0].maxPage!;
      });
      print(_maxPages);
      print(_currentPage);
    }else{
      _refreshController.loadNoData();
    }
  }

  String _getEmployeeName(int accountId){
    String name = '';
    for(int i = 0; i < _employeeList.length; i++){
      if(accountId == _employeeList[i].accountId){
        name = _employeeList[i].fullname!;
      }
    }
    return name;
  }

  void _getAllEmployee() async {
    List<Account> accountList = await AccountListViewModel().getAllAccount(isRefresh: true, currentPage: 0, accountId: _currentAccount!.accountId!, limit: 100000);
    _employeeList.clear();

    setState(() {
      _employeeList.addAll(accountList);
    });
  }

  Widget _customDropdownButton(Application application, int index){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: application.applicationStatusId == 0 ? const Icon(Icons.watch_later_rounded, size: 30, color: Colors.green,)
            : application.applicationStatusId == 1 ? const Icon(Icons.check, size: 30, color: Colors.blue,)
            : const Icon(Icons.close_rounded, size: 30, color: Colors.red,),
        customItemsIndexes: const [3],
        customItemsHeight: 8,
        items: [
          ...MenuItems.firstItems.map(
                (item) =>
                DropdownMenuItem<MenuItem>(
                  value: item,
                  child: MenuItems.buildItem(item),
                ),
          ),
        ],
        onChanged: (value) {
          String _attendanceType = MenuItems.onChanged(context, value as MenuItem);
          if(_attendanceType.isNotEmpty){
            if(_attendanceType == 'Duyệt'){
              setState(() {

              });
            }else{
              setState(() {

              });
            }
          }
        },
        itemHeight: 48,
        itemPadding: const EdgeInsets.only(left: 10),
        dropdownWidth: 120,
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
        ),
        dropdownElevation: 8,
        offset: const Offset(0, 8),
      ),
    );
  }

  // void _updateLateExcuse(String attendType){
  //   if(attendType != lateExcuseController.text) {
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text(
  //           'Thay đổi trạng thái từ $attendType thành ${lateExcuseController.text}',
  //           style: const TextStyle(fontSize: 14.0, color: defaultFontColor),
  //         ),
  //         actions: [
  //           TextButton(
  //             child: const Text("Huỷ"),
  //             onPressed: () => Navigator.pop(context),
  //           ),
  //           TextButton(
  //             child: const Text("Lưu"),
  //             onPressed: () {
  //               setState(() {
  //                 userLateExcuses[currentIndex].attendance = lateExcuseController.text;
  //                 Navigator.pop(context);
  //               });
  //             },
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }
}

class MenuItem {
  final String text;
  final Icon icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [accept, deny];

  static const pending = MenuItem(text: 'Mới', icon: Icon(Icons.watch_later_rounded, color: Colors.green));
  static const accept = MenuItem(text: 'Duyệt', icon: Icon(Icons.check, color: Colors.blue));
  static const deny = MenuItem(text: 'Từ chối', icon: Icon(Icons.close_rounded, color: Colors.red));

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        item.icon,
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: defaultFontColor,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.accept:
        return 1;
      case MenuItems.deny:
        return 2;
    }
  }
}
