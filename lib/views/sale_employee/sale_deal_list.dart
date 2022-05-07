import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/contact_list_view_model.dart';
import 'package:login_sample/view_models/deal_list_view_model.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SaleDealList extends StatefulWidget {
  const SaleDealList({Key? key, required this.saleId, required this.empAccount}) : super(key: key);

  final int saleId;
  final Account empAccount;

  @override
  State<SaleDealList> createState() => _SaleDealListState();
}

class _SaleDealListState extends State<SaleDealList> {

  int _currentPage = 0, _maxPages = 0;

  late final List<Contact> _contactList = [];
  late final List<Deal> _deals = [];

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _getAllContactByAccountId();
    _getDealListBySaleId(isRefresh: true);
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
                  if(index >= _maxPages){
                    index = 0;
                    _currentPage = index;
                  }else{
                    _currentPage = index;
                  }
                  _deals.clear();
                });
                _getDealListBySaleId(isRefresh: false);
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

          //Card dưới
          _maxPages >= 0 ? Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
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
                  child: _deals.isNotEmpty ? SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    onRefresh: () async{
                      setState(() {
                        _deals.clear();
                      });
                      _refreshController.resetNoData();

                      _getDealListBySaleId(isRefresh: false);

                      if(_deals.isNotEmpty){
                        _refreshController.refreshCompleted();
                      }else{
                        _refreshController.refreshFailed();
                      }
                    },
                    child: ListView.builder(
                      itemBuilder: (context, index){
                        final deal = _deals[index];
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0, left: 5.0, right: 5.0),
                            child: Card(
                              elevation: 10.0,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: InkWell(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(
                                  //     builder: (context) => SaleEmpDealDetail(deal: deal, readOnly: widget.issueView,)
                                  // )).then(_onGoBack);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Text('Mã số hợp đồng:', style: TextStyle(fontSize: 12.0),),
                                            const Spacer(),
                                            Text('${deal.dealId}', style: const TextStyle(fontSize: 14.0),),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Text('Tiêu đề:', style: TextStyle(fontSize: 12.0),),
                                            const Spacer(),
                                            SizedBox(
                                                height: 20.0, width: MediaQuery.of(context).size.width * 0.6,
                                                child: Align(alignment: Alignment.bottomRight,child: Text(deal.title, overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 14.0),))
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Text('Tiền trình hợp đồng:', style: TextStyle(fontSize: 12.0),),
                                            const Spacer(),
                                            Text(dealStagesNames[deal.dealStageId], style: const TextStyle(fontSize: 14.0),),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Text('Số tiền:', style: TextStyle(fontSize: 12.0),),
                                            const Spacer(),
                                            Text(deal.amount > 0 ? '${formatNumber(deal.amount.toString().replaceAll('.', ''))} đ' : 'Chưa chốt giá', style: const TextStyle(fontSize: 14.0),),
                                          ],
                                        ),
                                      ),
                                      if(_getContactName(deal.contactId).isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                          child: Row(
                                            children: <Widget>[
                                              const Text('Tên khách hàng:', style: TextStyle(fontSize: 12.0),),
                                              const Spacer(),
                                              Text(_getContactName(deal.contactId), style: const TextStyle(fontSize: 14.0),),
                                            ],
                                          ),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Text('Người quản lý hợp đồng:', style: TextStyle(fontSize: 12.0),),
                                            const Spacer(),
                                            Text(widget.empAccount.fullname!, style: const TextStyle(fontSize: 14.0)),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                        child: Row(
                                          children: <Widget>[
                                            const Text('Ngày chốt hợp đồng:', style: TextStyle(fontSize: 12.0),),
                                            const Spacer(),
                                            Text(DateFormat('dd-MM-yyyy').format(deal.closedDate), style: const TextStyle(fontSize: 14.0),)
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
                  ) : const Center(child: CircularProgressIndicator())
              ),
            ),
          ) : const Center(child: Text('Không có dữ liệu')),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text("Danh sách hợp đồng",style: TextStyle(color: Colors.blueGrey),)
            ),
          ),
        ],
      ),
    );
  }

  void _getDealListBySaleId({required bool isRefresh}) async {
    List<Deal>? result = await DealListViewModel().getDealListBySaleId(saleId: widget.saleId, isRefresh: isRefresh, currentPage: _currentPage);

    if(result!.isNotEmpty){
      setState(() {
        _deals.clear();
        _deals.addAll(result);
        _maxPages = _deals[0].maxPage!;
      });
    }else{
      setState(() {
        _maxPages = -1;
      });
    }
  }

  void _getAllContactByAccountId() async {
    List<Contact> contactList = await ContactListViewModel().getAllContactByAccountId(isRefresh: true, accountId: widget.empAccount.accountId!, currentPage: 0, limit: 1000000);

    if(contactList.isNotEmpty){
      setState(() {
        _contactList.addAll(contactList);
      });
    }
  }

  String _getContactName(int contactId){
    String name = '';
    for(int i = 0; i < _contactList.length; i++){
      if(contactId == _contactList[i].contactId){
        name = _contactList[i].fullname;
      }
    }
    return name;
  }
}
