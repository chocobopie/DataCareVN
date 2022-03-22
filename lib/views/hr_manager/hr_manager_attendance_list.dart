import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:login_sample/views/hr_manager/hr_manager_attendance_report.dart';
import 'package:login_sample/widgets/IconTextButtonSmall3.dart';
import 'package:login_sample/utilities/utils.dart';

class HrManagerAttendanceList extends StatefulWidget {
  const HrManagerAttendanceList({Key? key, required this.attendanceType, required this.userAttendances}) : super(key: key);

  final String attendanceType;
  final List<UserAttendance> userAttendances;

  @override
  _HrManagerAttendanceListState createState() => _HrManagerAttendanceListState();
}

class _HrManagerAttendanceListState extends State<HrManagerAttendanceList> {

  bool isSearching = false;
  bool isUpdatedAttendance = false;
  int currentIndex = 0;
  List<int> listUpdateAttendId = [];

  TextEditingController attendanceController = TextEditingController();
  List<UserAttendance> userAttendances = [];
  List<UserAttendance> userAttends = [];
  List<UserAttendance> userLates = [];
  List<UserAttendance> userAbsents = [];
  List<UserAttendance> userLateAlloweds = [];

  getAttend(){
    if(userAttends.isNotEmpty){
      userAttends.clear();
    }
    for(int i = 0; i < userAttendances.length; i++){
      if(userAttendances[i].attendance == 'Đúng giờ'){
        userAttends.add(userAttendances[i]);
      }
    }
  }

  getLate(){
    if(userLates.isNotEmpty){
      userLates.clear();
    }
    for(int i = 0; i < userAttendances.length; i++){
      if(userAttendances[i].attendance == 'Trễ'){
        userLates.add(userAttendances[i]);
      }
    }
  }

  getAbsent(){
    if(userAbsents.isNotEmpty){
      userAbsents.clear();
    }
    for(int i = 0; i < userAttendances.length; i++){
      if(userAttendances[i].attendance == 'Vắng'){
        userAbsents.add(userAttendances[i]);
      }
    }
  }

  getLateAllowed(){
    if(userLateAlloweds.isNotEmpty){
      userLateAlloweds.clear();
    }
    for(int i = 0; i < userAttendances.length; i++){
      if(userAttendances[i].attendance == 'Được đi trễ'){
        userLateAlloweds.add(userAttendances[i]);
      }
    }
  }

  @override
  void initState() {
    userAttendances = widget.userAttendances;
    getAttend();
    getAbsent();
    getLate();
    getLateAllowed();
    super.initState();
  }

  @override
  void dispose() {
    attendanceController.dispose();
    super.dispose();
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
              height: MediaQuery.of(context).size.height * 0.2
          ),
          Card(
            elevation: 20.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            margin: const EdgeInsets.only(top: 80.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconTextButtonSmall3(
                            title: 'Đúng giờ',
                            subtitle: '${userAttends.length}',
                            colorsButton: const [Colors.green, Colors.white],
                          ),
                          const SizedBox(width: 10.0,),
                          IconTextButtonSmall3(
                            title: 'Trễ',
                            subtitle: '${userLates.length}',
                            colorsButton: const [Colors.yellow, Colors.white],
                          ),
                          const SizedBox(width: 10.0,),
                          IconTextButtonSmall3(
                            title: 'Vắng',
                            subtitle: '${userAbsents.length}',
                            colorsButton: const [Colors.red, Colors.white],
                          ),
                          const SizedBox(width: 10.0,),
                          IconTextButtonSmall3(
                            title: 'Được đi trễ',
                            subtitle: '${userLateAlloweds.length}',
                            colorsButton: const [Colors.blue, Colors.white],
                          ),
                        ],
                      )
                    ],
                  ),
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
                    itemCount: userAttendances.length,
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
                          child: ListTile(
                            title: Text(userAttendances[index].name, style: const TextStyle(fontSize: 12.0),),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, right: 40.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text('Phòng: ${userAttendances[index].department}', style: const TextStyle(fontSize: 12.0),),
                                      const SizedBox(height: 5.0,),
                                      Text(userAttendances[index].team,style: const TextStyle(fontSize: 12.0),),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 40.0,),
                                Column(
                                    children: <Widget>[
                                      if(userAttendances[index].attendance == 'Đúng giờ')  const Text('Đúng giờ', style: TextStyle(fontSize: 12.0, color: Colors.green),),
                                      if(userAttendances[index].attendance == 'Trễ') const Text('Trễ', style: TextStyle(fontSize: 12.0, color: Colors.yellow),),
                                      if(userAttendances[index].attendance == 'Vắng') const Text('Vắng', style: TextStyle(fontSize: 12.0, color: Colors.red),),
                                      if(userAttendances[index].attendance == 'Được đi trễ') const Text('Được đi trễ', style: TextStyle(fontSize: 12.0, color: Colors.blue),),
                                      if(userAttendances[index].attendance == 'Xin đi trễ') const Text('Xin đi trễ', style: TextStyle(fontSize: 12.0, color: Colors.blue),),
                                      _customDropdownButton(userAttendances[index].attendance, userAttendances.indexOf(userAttendances[index])),
                                    ]
                                ),
                              ],
                            ),
                            dense: true,
                            subtitle: const Text('Nhân viên kinh doanh'),
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
        customButton: attendType == 'Đúng giờ' ? const Icon(Icons.access_time_filled, size: 30, color: Colors.green,)
            : attendType == 'Trễ' ? const Icon(Icons.access_time_filled, size: 30, color: Colors.yellow,)
            : attendType == 'Vắng' ? const Icon(Icons.access_time_filled, size: 30, color: Colors.red,)
            : const Icon(Icons.access_time_filled, size: 30, color: Colors.blue,),
        customItemsIndexes: const [4],
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
            if(_attendanceType == 'Đúng giờ'){
              setState(() {
                currentIndex = index;
                attendanceController.text = _attendanceType;
                listUpdateAttendId.add(currentIndex);
                _updateAttendances(attendType);
                print(currentIndex);
                print(attendanceController.text);
              });
            }else if(_attendanceType == 'Vắng'){
              setState(() {
                currentIndex = index;
                attendanceController.text = _attendanceType;
                listUpdateAttendId.add(currentIndex);
                _updateAttendances(attendType);
                print(currentIndex);
                print(attendanceController.text);
              });
            }else if(_attendanceType == 'Được đi trễ'){
              setState(() {
                currentIndex = index;
                attendanceController.text = _attendanceType;
                listUpdateAttendId.add(currentIndex);
                _updateAttendances(attendType);
                print(currentIndex);
                print(attendanceController.text);
              });
            }else{
              setState(() {
                currentIndex = index;
                attendanceController.text = _attendanceType;
                listUpdateAttendId.add(currentIndex);
                _updateAttendances(attendType);
                print(currentIndex);
                print(attendanceController.text);
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

  void _updateAttendances(String attendType){
    if(attendType != attendanceController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Thay đổi trạng thái từ $attendType thành ${attendanceController.text}',
            style: const TextStyle(fontSize: 18.0, color: defaultFontColor),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Huỷ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Lưu"),
              onPressed: () {
                setState(() {
                  userAttendances[currentIndex].attendance = attendanceController.text;
                  getAttend();
                  getAbsent();
                  getLate();
                  getLateAllowed();
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
  static const List<MenuItem> firstItems = [attend, late, absent, lateAccepted];

  static const attend = MenuItem(text: 'Có mặt', icon: Icon(Icons.access_time_filled, color: Colors.green));
  static const absent = MenuItem(text: 'Vắng', icon: Icon(Icons.access_time_filled, color: Colors.red));
  static const late = MenuItem(text: 'Trễ', icon: Icon(Icons.access_time_filled, color: Colors.yellow));
  static const lateAccepted = MenuItem(text: 'Được đi trễ', icon: Icon(Icons.access_time_filled, color: Colors.blue));

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
      case MenuItems.attend:
        return 'Đúng giờ';
      case MenuItems.late:
        return 'Trễ';
      case MenuItems.absent:
        return 'Vắng';
      case MenuItems.lateAccepted:
        return 'Được đi trễ';
    }
  }
}

