import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/fromDateToDate.dart';
import 'package:login_sample/views/sale_employee/sale_emp_date_filter.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';
import 'package:login_sample/models/temp/deal_temp.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/sale_employee/sale_emp_deal_detail.dart';
import 'package:login_sample/views/sale_employee/emp_issue_add_new.dart';
import 'package:login_sample/views/sale_employee/emp_issue_detail.dart';

class EmpSentIssueList extends StatefulWidget {
  const EmpSentIssueList({Key? key}) : super(key: key);

  @override
  _EmpSentIssueListState createState() => _EmpSentIssueListState();
}

class _EmpSentIssueListState extends State<EmpSentIssueList> {

  bool isSearching = false;
  late String _fromDatetoDateString = 'Ngày deadline';
  DateTime? fromDate, toDate;

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
                child: Column(),
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
}
