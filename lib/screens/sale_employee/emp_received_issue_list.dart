import 'package:flutter/material.dart';
import 'package:login_sample/models/temp/deal_temp.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/screens/sale_employee/emp_deal_detail.dart';

class EmpReceivedIssue extends StatefulWidget {
  const EmpReceivedIssue({Key? key}) : super(key: key);

  @override
  _EmpReceivedIssueState createState() => _EmpReceivedIssueState();
}

class _EmpReceivedIssueState extends State<EmpReceivedIssue> {
  bool isSearching = false;

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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,),
                  child: Row(
                    children: <Widget>[
                      //Số vấn đề nhận được
                      SizedBox(
                        child: TextField(
                          autofocus: true,
                          readOnly: true,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.only(left: 20.0),
                            labelText: 'Số lượng hợp đồng có vấn đề nhận được',
                            hintText: '${deals.length}',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 107, 106, 144),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.92,
                      ),
                    ],
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
                child: ListView.builder(
                    itemCount: deals.length,
                    itemBuilder: (context, index){
                      return Theme(
                        data: ThemeData().copyWith(dividerColor: Colors.transparent),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
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
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ExpansionTile(
                              trailing: const Text('[Tiêu đề]'),
                              title: Align(
                                alignment: Alignment.topLeft,
                                child: TextButton(
                                  child: Text('Hợp đồng: ${deals[index].dealId}'),
                                  onPressed: () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => EmpDealDetail(deal: deals[index])));
                                  },
                                ),
                              ),
                              children: const <Widget>[
                                ListTile(
                                  title: Text('[Nội dung]', style: TextStyle(color: defaultFontColor, fontSize: 12.0),),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
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
}
