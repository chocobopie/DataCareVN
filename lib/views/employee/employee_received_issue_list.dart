import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/fromDateToDate.dart';
import 'package:login_sample/models/issue.dart';
import 'package:login_sample/models/sort_item.dart';
import 'package:login_sample/models/temp/deal_temp.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/account_list_view_model.dart';
import 'package:login_sample/view_models/issue_list_view_model.dart';
import 'package:login_sample/views/sale_employee/sale_emp_date_filter.dart';
import 'package:login_sample/views/sale_employee/sale_emp_deal_detail.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:number_paginator/number_paginator.dart';

import 'employee_issue_detail.dart';

class EmployeeReceivedIssue extends StatefulWidget {
  const EmployeeReceivedIssue({Key? key}) : super(key: key);

  @override
  _EmployeeReceivedIssueState createState() => _EmployeeReceivedIssueState();
}

class _EmployeeReceivedIssueState extends State<EmployeeReceivedIssue> {

  late final List<Account> _employeeList = [];
  List<Issue> issues = [];
  bool isSearching = false;
  late String _fromDatetoDateString = 'Hạn chót';
  DateTime? fromDate, toDate;

  List<Deal> deals = [
    Deal(dealId: '1', name: 'Nguyễn Văn A', dealName: 'Hợp đồng 1', dealStage: 'Gửi báo giá', amount: '2.000.000', dealOwner: 'Tên sale 1', department: 'Tên phòng ban', team: 'Tên nhóm', vat: true, service: 'Đào tạo', dealType: 'Ký mới', priority: 'Thấp', dealDate: DateTime.now(), closeDate: DateTime.now()),
    Deal(dealId: '2', name: 'Nguyễn Văn B', dealName: 'Hợp đồng 2', dealStage: 'Đang suy nghĩ', amount: '2.000.000', dealOwner: 'Tên sale 2', department: 'Tên phòng ban', team: 'Tên nhóm', vat: false, service: 'Đào tạo', dealType: 'Ký mới', priority: 'Thấp', dealDate: DateTime.now(), closeDate: DateTime.now()),
    Deal(dealId: '3', name: 'Nguyễn Văn C', dealName: 'Hợp đồng 3', dealStage: 'Gặp trao đổi', amount: '2.000.000', dealOwner: 'Tên sale 3', department: 'Tên phòng ban', team: 'Tên nhóm', vat: true, service: 'Đào tạo', dealType: 'Ký mới', priority: 'Thấp', dealDate: DateTime.now(), closeDate: DateTime.now()),
    Deal(dealId: '4', name: 'Nguyễn Văn D', dealName: 'Hợp đồng 4', dealStage: 'Đồng ý mua', amount: '3.000.000', dealOwner: 'Tên sale 4', department: 'Tên phòng ban', team: 'Tên nhóm', vat: false, service: 'Đào tạo', dealType: 'Ký mới', priority: 'Thấp', dealDate: DateTime.now(), closeDate: DateTime.now()),
    Deal(dealId: '5', name: 'Nguyễn Văn E', dealName: 'Hợp đồng 5', dealStage: 'Gửi hợp đồng', amount: '4.000.000', dealOwner: 'Tên sale 5', department: 'Tên phòng ban', team: 'Tên nhóm', vat: true, service: 'Đào tạo', dealType: 'Ký mới', priority: 'Thấp', dealDate: DateTime.now(), closeDate: DateTime.now()),
    Deal(dealId: '6', name: 'Nguyễn Văn F', dealName: 'Hợp đồng 6', dealStage: 'Xuống tiền', amount: '5.000.000', dealOwner: 'Tên sale 5', department: 'Tên phòng ban', team: 'Tên nhóm', vat: false, service: 'Đào tạo', dealType: 'Ký mới', priority: 'Thấp', dealDate: DateTime.now(), closeDate: DateTime.now()),
    Deal(dealId: '7', name: 'Nguyễn Văn G', dealName: 'Hợp đồng 7', dealStage: 'Thất bại', amount: '6.000.000', dealOwner: 'Tên sale 5', department: 'Tên phòng ban', team: 'Tên nhóm', vat: true, service: 'Đào tạo', dealType: 'Tái ký', priority: 'Thấp', dealDate: DateTime.now(), closeDate: DateTime.now()),
    Deal(dealId: '8', name: 'Nguyễn Văn H', dealName: 'Hợp đồng 8', dealStage: 'Xuống tiền', amount: '7.000.000', dealOwner: 'Tên sale 5', department: 'Tên phòng ban', team: 'Tên nhóm', vat: true, service: 'Đào tạo', dealType: 'Tái ký', priority: 'Thấp', dealDate: DateTime.now(), closeDate: DateTime.now()),
    Deal(dealId: '9', name: 'Nguyễn Văn I', dealName: 'Hợp đồng 9', dealStage: 'Gửi báo giá', amount: '8.000.000', dealOwner: 'Tên sale 5', department: 'Tên phòng ban', team: 'Tên nhóm', vat: true, service: 'Đào tạo', dealType: 'Tái ký', priority: 'Thấp', dealDate: DateTime.now(), closeDate: DateTime.now()),
    Deal(dealId: '10', name: 'Nguyễn Văn K', dealName: 'Hợp đồng 10', dealStage: 'Xuống tiền', amount: '9.000.000', dealOwner: 'Tên sale 5', department: 'Tên phòng ban', team: 'Tên nhóm', vat: true, service: 'Đào tạo', dealType: 'Tái ký', priority: 'Thấp', dealDate: DateTime.now(), closeDate: DateTime.now()),
    Deal(dealId: '11', name: 'Nguyễn Văn L', dealName: 'Hợp đồng 11', dealStage: 'Xuống tiền', amount: '10.000.000', dealOwner: 'Tên sale 5', department: 'Tên phòng ban', team: 'Tên nhóm', vat: true, service: 'Đào tạo', dealType: 'Tái ký', priority: 'Thấp', dealDate: DateTime.now(), closeDate: DateTime.now()),
  ];

  @override
  void initState() {
    super.initState();
    // _getAllIssue();
    _getAllEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const Card(
        child: NumberPaginator(
            numberPages: 10
        ),
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
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text('Lọc theo:', style: TextStyle(color: defaultFontColor),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    height: 40.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        const SizedBox(width: 10.0,),
                        CustomOutlinedButton(
                          title: 'Tên nhân viên giao',
                          radius: 10,
                          color: mainBgColor,
                          onPressed: () async {
                          },
                        ),
                        const CustomOutlinedButton(
                            title: 'Ngày nhận vấn đề',
                            radius: 10,
                            color: mainBgColor
                        ),
                        CustomOutlinedButton(
                          title: _fromDatetoDateString,
                          radius: 10,
                          color: mainBgColor,
                          onPressed: () async {
                            final data = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SaleEmpDateFilter(),
                            ));
                            if(data != null){
                              FromDateToDate fromDateToDate = data;
                              setState(() {
                                fromDate = fromDateToDate.fromDate;
                                toDate = fromDateToDate.toDate;
                                _fromDatetoDateString = '${fromDateToDate.fromDateString} → ${fromDateToDate.toDateString}';
                              });
                            }
                          },
                        ),
                        DropdownButton2(
                          customButton: const Icon(
                            Icons.sort,
                            size: 40,
                            color: mainBgColor,
                          ),
                          items: [
                            ...SortItems.firstItems.map(
                                  (item) =>
                                  DropdownMenuItem<SortItem>(
                                    value: item,
                                    child: SortItems.buildItem(item),
                                  ),
                            ),
                          ],
                          onChanged: (value) {
                          },
                          itemHeight: 40,
                          itemPadding: const EdgeInsets.only(left: 5, right: 5),
                          dropdownWidth: 220,
                          dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: mainBgColor,
                          ),
                          dropdownElevation: 8,
                          offset: const Offset(0, 8),
                        ),
                        IconButton(
                            onPressed: (){
                            },
                            icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.24),
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
                margin: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.01),
                child: issues.isNotEmpty ? ListView.builder(
                  itemBuilder: (context, index) {
                    final issue = issues[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const EmployeeIssueDetail()
                          ));
                        },
                        child: Card(
                          elevation: 10,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Text('Tiêu đề:'),
                                      const Spacer(),
                                      Text(issue.description),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: const <Widget>[
                                      Text('Nhân viên giao:'),
                                      Spacer(),
                                      Text('Nguyễn Thanh Vân'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Text('Ngày nhận vấn đề:'),
                                      const Spacer(),
                                      Text(DateFormat('dd-MM-yyyy').format(issue.createdDate)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Text('Hạn chót:'),
                                      const Spacer(),
                                      Text(DateFormat('dd-MM-yyyy').format(issue.dealineDate)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: issues.length,
                ) : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: !isSearching
                  ? const Text("Danh sách vấn đề được giao",style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),)
                  : const TextField(
                style: TextStyle(color: Colors.blueGrey,),
                showCursor: true,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  icon: Icon(Icons.search,
                    color: Colors.blueGrey,
                  ),
                  hintText: "Search name, email",
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              actions: <Widget>[
                isSearching ? IconButton(
                  icon: const Icon(
                    Icons.cancel,
                  ),
                  onPressed: (){
                    setState(() {
                      isSearching = false;
                    });
                  },
                ) : IconButton(
                  icon: const Icon(
                    Icons.search,
                  ),
                  onPressed: (){
                    setState(() {
                      isSearching = true;
                    });
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getEmployeeNamee(int accountId){
    String name = '';
    for(int i = 0; i < _employeeList.length; i++){
      if(accountId == _employeeList[i].accountId){
        name = _employeeList[i].fullname!;
      }
    }
    return name;
  }


  void _getAllEmployee() async {
    List<Account> accountList = await AccountListViewModel().getAllAccount(isRefresh: true, currentPage: 0, accountId: 0, limit: 100000);

    setState(() {
      _employeeList.addAll(accountList);
    });
  }

  // void _getAllIssue() async {
  //   List<Issue>? issueList = await IssueListViewModel().getAllIssue();
  //
  //   if(issueList != null){
  //     setState(() {
  //       issues.addAll(issueList);
  //     });
  //   }
  // }
}

//==============================================================================Sort icon===============

class SortItems {
  static const List<SortItem> firstItems = [asc, des];

  static const asc = SortItem(text: 'Ngày hạn chót tăng dần', icon: Icons.arrow_drop_up);
  static const des = SortItem(text: 'Ngày hạn chót giảm dần', icon: Icons.arrow_drop_down);


  static Widget buildItem(SortItem item) {
    return Row(
      children: [
        Icon(
            item.icon,
            color: Colors.white,
            size: 22
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, SortItem item) {
    switch (item) {
      case SortItems.asc:
        return true;
      case SortItems.des:
      //Do something
        return false;
    }
  }
}