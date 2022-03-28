import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/fromDateToDate.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/hr_manager/hr_manager_attendance_report_list.dart';
import 'package:login_sample/views/sale_employee/sale_emp_date_filter.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:number_paginator/number_paginator.dart';

class HrManagerLateExcuseList extends StatefulWidget {
  const HrManagerLateExcuseList({Key? key, required this.attendanceType, required this.userLateExcuses}) : super(key: key);

  final String attendanceType;
  final List<UserAttendance> userLateExcuses;

  @override
  _HrManagerLateExcuseListState createState() => _HrManagerLateExcuseListState();
}

class _HrManagerLateExcuseListState extends State<HrManagerLateExcuseList> {

  String _lateExcuseFromDateToDateString = 'Ngày gửi đơn';
  String _lateFromDateToDateString = 'Ngày xin đi trễ';
  bool isSearching = false;
  bool isUpdatedAttendance = false;
  int currentIndex = 0;

  DateTime? _fromDate, _toDate;

  TextEditingController lateExcuseController = TextEditingController();
  List<UserAttendance> userLateExcuses = [];

  @override
  void initState() {
    userLateExcuses = widget.userLateExcuses;
    super.initState();
  }

  @override
  void dispose() {
    lateExcuseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Card(
        elevation: 10.0,
        child: NumberPaginator(
          numberPages: 10,
          buttonSelectedBackgroundColor: mainBgColor,
          onPageChange: (int index) {
          },
        ) ,
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
                  padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                  child: Row(
                    children: <Widget>[
                      const Text('Lọc theo:', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                      const SizedBox(width: 10.0,),
                      Expanded(
                        child: CustomOutlinedButton(
                          title: _lateExcuseFromDateToDateString,
                          radius: 10.0,
                          color: mainBgColor,
                          onPressed: () async {
                            final data = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SaleEmpDateFilter(),
                            ));
                            if(data != null){
                              FromDateToDate fromDateToDate = data;
                              setState(() {
                                _fromDate = fromDateToDate.fromDate;
                                _toDate = fromDateToDate.toDate;
                                _lateExcuseFromDateToDateString = '${fromDateToDate.fromDateString} → ${fromDateToDate.toDateString}';
                              });
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomOutlinedButton(
                          title: _lateFromDateToDateString,
                          radius: 10.0,
                          color: mainBgColor,
                          onPressed: () async {
                            final data = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SaleEmpDateFilter(),
                            ));
                            if(data != null){
                              FromDateToDate fromDateToDate = data;
                              setState(() {
                                _fromDate = fromDateToDate.fromDate;
                                _toDate = fromDateToDate.toDate;
                                _lateFromDateToDateString = '${fromDateToDate.fromDateString} → ${fromDateToDate.toDateString}';
                              });
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomOutlinedButton(
                          title: 'Trạng thái',
                          radius: 10,
                          color: mainBgColor,
                          onPressed: (){},
                        ),
                      ),
                      IconButton(
                          onPressed: (){
                            setState(() {
                              _fromDate = null;
                              _toDate = null;
                              _lateExcuseFromDateToDateString = 'Ngày gửi đơn';
                            });
                          },
                          icon: const Icon(Icons.refresh, color: mainBgColor, size: 30,)
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.22),
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
                  child: ListView.builder(
                    itemCount: userLateExcuses.length,
                    itemBuilder: (context, index) {
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
                              title: Text(userLateExcuses[index].name, style: const TextStyle(fontSize: 12.0),),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, right: 40.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text('Phòng: ${userLateExcuses[index].department}', style: const TextStyle(fontSize: 12.0),),
                                        const SizedBox(height: 5.0,),
                                        Text(userLateExcuses[index].team,style: const TextStyle(fontSize: 12.0),),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 40.0,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Column(
                                        children: <Widget>[
                                          if(userLateExcuses[index].attendance == 'Mới')  const Text('Mới', style: TextStyle(fontSize: 12.0, color: Colors.green),),
                                          if(userLateExcuses[index].attendance == 'Duyệt') const Text('Duyệt', style: TextStyle(fontSize: 12.0, color: Colors.blue),),
                                          if(userLateExcuses[index].attendance == 'Từ chối') const Text('Từ chối', style: TextStyle(fontSize: 12.0, color: Colors.red),),
                                          _customDropdownButton(userLateExcuses[index].attendance, userLateExcuses.indexOf(userLateExcuses[index])),
                                        ]
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: const Text('Nhân viên kinh doanh'),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                                  child: Align(
                                      child: Text(
                                          'Xin đi trễ ngày: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                                        style: const TextStyle(color: Colors.blue, fontSize: 14.0),
                                      ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0),
                                  child: Align(
                                    child: Text('Thời gian dự kiến có mặt: ${DateFormat.Hm().format(DateTime.now())}',
                                      style: const TextStyle(color: Colors.blue, fontSize: 14.0),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                                  child: Align(
                                      child: Text('Lý do: Xe xẹp lốp',
                                        style: TextStyle(color: Colors.blue, fontSize: 14.0),
                                      ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
              ),
            ),
          ),

          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey,),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: !isSearching
                  ? Text(widget.attendanceType, style: const TextStyle(color: Colors.blueGrey, fontSize: 18.0),)
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

  Widget _customDropdownButton(String attendType, int index){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: attendType == 'Mới' ? const Icon(Icons.watch_later_rounded, size: 30, color: Colors.green,)
            : attendType == 'Duyệt' ? const Icon(Icons.check, size: 30, color: Colors.blue,)
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
                currentIndex = index;
                lateExcuseController.text = _attendanceType;
                _updateLateExcuse(attendType);
                print(currentIndex);
                print(lateExcuseController.text);
              });
            }else{
              setState(() {
                currentIndex = index;
                lateExcuseController.text = _attendanceType;
                _updateLateExcuse(attendType);
                print(currentIndex);
                print(lateExcuseController.text);
              });
            }
          }
        },
        itemHeight: 48,
        itemPadding: const EdgeInsets.only(left: 10),
        dropdownWidth: 150,
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
        ),
        dropdownElevation: 8,
        offset: const Offset(0, 8),
      ),
    );
  }

  void _updateLateExcuse(String attendType){
    if(attendType != lateExcuseController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Thay đổi trạng thái từ $attendType thành ${lateExcuseController.text}',
            style: const TextStyle(fontSize: 14.0, color: defaultFontColor),
          ),
          actions: [
            TextButton(
              child: const Text("Huỷ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Lưu"),
              onPressed: () {
                setState(() {
                  userLateExcuses[currentIndex].attendance = lateExcuseController.text;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      );
    }
  }
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
        return 'Duyệt';
      case MenuItems.deny:
        return 'Từ chối';
    }
  }
}
