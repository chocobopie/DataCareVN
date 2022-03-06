import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/screens/providers/account_provider.dart';
import 'package:login_sample/screens/sale_employee/emp_deal_add_new.dart';
import 'package:login_sample/screens/sale_employee/emp_deal_detail.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomFilterFormField.dart';
import 'package:provider/provider.dart';

class EmpDealList extends StatefulWidget {
  const EmpDealList({Key? key}) : super(key: key);

  @override
  _EmpDealListState createState() => _EmpDealListState();
}

class _EmpDealListState extends State<EmpDealList> {

  final ScrollController _scrollController = ScrollController();
  List<Deal> deals = [];
  bool loading = false, allLoaded = false, isSearching = false;
  int id = 0;
  var rng = Random();

  String? selectedValue;
  String? selectedValue2;
  String? selectedValue3;
  String? selectedValue4;
  String? selectedValue5;

  late List<Account> accounts = [];
  late Future<List<Deal>> futureDeals;

  late int lengthOfDeal = 0;

  mockFetch() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    List<Deal> newData = deals.length >= 60
        ? []
        : List.generate(
        20,
            (index) => Deal(
                dealId: index + deals.length,
                title: 'Đơn mua ${index + deals.length}',
                dealStageId: rng.nextInt(5),
                amount: 1000000,
                closedDate: DateTime.now(),
                dealOwner: rng.nextInt(3),
                vatid: rng.nextInt(1),
                serviceId: rng.nextInt(5),
                dealTypeId: rng.nextInt(1),
                contactId: rng.nextInt(4))
    );
    if (newData.isNotEmpty) {
      deals.addAll(newData);
    }
    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  @override
  void initState() {
    mockFetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent &&
          !loading) {
        mockFetch();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  List<String> roleSMFilter = [
    'Nhân viên kinh doanh',
    'Trưởng nhóm kinh doanh',
    'Trưởng phòng kinh doanh',
  ];

  @override
  Widget build(BuildContext context) {
    final _account = Provider.of<AccountProvider>(context).account;
    double leftRight = MediaQuery.of(context).size.width * 0.05;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const EmpDealAddNew(),
          ));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.plus_one),
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
            margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,),
                  child: Row(
                    children: <Widget>[
                      const Text('LỌC THEO', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                      const SizedBox(width: 10,),
                      CustomFilterFormField(
                        items: roleSMFilter,
                        titleWidth: 150,
                        dropdownWidth: 220,
                        hint: 'Chức vụ',
                        selectedValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                      ),
                      const SizedBox(width: 5.0,),
                      CustomFilterFormField(
                        items: teamTemp,
                        titleWidth: 120,
                        dropdownWidth: 150,
                        hint: 'Nhóm',
                        selectedValue: selectedValue4,
                        onChanged: (value) {
                          setState(() {
                            selectedValue4 = value;
                          });
                        },
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
                child: deals.isNotEmpty
                    ? Stack(
                  children: [
                    ListView.separated(
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          if (index < deals.length) {
                            return ListTile(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => EmpDealDetail(deal: deals[index]),
                                ));
                              },
                              title: const Text('Tên hợp đồng:'),
                              subtitle: Text('Hợp đồng ${deals[index].dealId}'),
                              dense: true,
                              trailing: Column(
                                children: [
                                  Text(
                                      'Số tiền: ${deals[index].amount}'),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text('Tiến trình: ${dealStagesNameUtilities[deals[index].dealStageId]}'),
                                ],
                              ),
                            );
                          } else {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: const Center(
                                  child: Text(
                                      'Bạn đã đến cuối danh sách')),
                            );
                          }
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 1,
                            thickness: 2,
                          );
                        },
                        itemCount: deals.length + (allLoaded ? 1 : 0)),
                    if (loading) ...[
                      Positioned(
                          left: 0,
                          bottom: 0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          )),
                    ]
                  ],
                ) : null,
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
                  ? const Text("Danh sách hợp đồng",style: TextStyle(color: Colors.blueGrey),)
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

  Future<int> _getDealCount() async{
    return await futureDeals.then((value) {
      return value.length;
    });
  }

  void _getOverallInfor(){
    futureDeals = ApiService().getAllDeals();

    _getAccounts();

    _getDealCount().then((value) {
      setState(() {
        if(lengthOfDeal > 0){
          lengthOfDeal = 0;
        }
        lengthOfDeal = value;
      });
    });

  }

  void _getAccounts(){
    ApiService().getAllAccounts().then((value) {
      setState(() {
        if(accounts.isNotEmpty){
          accounts.clear();
        }
        accounts.addAll(value);
      });
    });
  }

  String? _getDealOwnerName(int? id){
    for(int i = 0; i < accounts.length; i++){
      if(id == accounts[i].accountId){
        return accounts[i].fullname;
      }
    }
  }

  void _refreshData() {
    id++;
  }

  onGoBack(dynamic value) {
    _refreshData();
    Future.delayed(const Duration(seconds: 3), (){
      setState(() {
        _getOverallInfor();
      });
    });
  }
}
