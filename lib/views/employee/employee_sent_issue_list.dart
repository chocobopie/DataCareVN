import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/fromDateToDate.dart';
import 'package:login_sample/models/issue.dart';
import 'package:login_sample/models/sort_item.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/view_models/issue_list_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_date_filter.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';
import 'package:login_sample/models/temp/deal_temp.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/sale_employee/sale_emp_deal_detail.dart';
import 'package:login_sample/views/employee/employee_issue_add_new.dart';
import 'package:login_sample/views/employee/employee_issue_detail.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';

class EmployeeSentIssueList extends StatefulWidget {
  const EmployeeSentIssueList({Key? key}) : super(key: key);

  @override
  _EmployeeSentIssueListState createState() => _EmployeeSentIssueListState();
}

class _EmployeeSentIssueListState extends State<EmployeeSentIssueList> {

  List<Issue> issues = [];
  bool isSearching = false;
  late String _fromDatetoDateString = 'Ngày deadline';
  DateTime? fromDate, toDate;
  late Account _currentAccount;

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getAllIssue();
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
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10.0),
                  child: Row(
                    children: <Widget>[
                      const Text('Lọc theo:', style: TextStyle(color: defaultFontColor),),
                      const SizedBox(width: 10.0,),
                      Expanded(
                        child: CustomOutlinedButton(
                          title: 'Tên nhân viên được giao',
                          radius: 10,
                          color: mainBgColor,
                          onPressed: () async {
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomOutlinedButton(
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
                        dropdownWidth: 240,
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
              ],
            ),
          ),

          //Card dưới
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.22),
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
                                        Text(issue.title),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: const <Widget>[
                                        Text('Nhân viên được giao:'),
                                        Spacer(),
                                        Text('Nguyễn Thành Tiến'),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        const Text('Deadline:'),
                                        const Spacer(),
                                        Text('Ngày ${DateFormat('dd-MM-yyyy').format(issue.dealineDate)}'),
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
                  ? const Text("Danh sách vấn đề đã gửi",style: TextStyle(color: Colors.blueGrey),)
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

  void _getAllIssue() async {
    List<Issue>? issueList = await IssueListViewModel().getAllIssue();

    if(issueList != null){
      setState(() {
        issues.addAll(issueList);
      });
    }
  }
}

class SortItems {
  static const List<SortItem> firstItems = [asc, des];

  static const asc = SortItem(text: 'Ngày deadline tăng dần', icon: Icons.arrow_drop_up);
  static const des = SortItem(text: 'Ngày deadline giảm dần', icon: Icons.arrow_drop_down);


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