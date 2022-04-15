import 'package:flutter/material.dart';
import 'package:login_sample/models/temp/user_temp.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/hr_manager/hr_manager_account_detail.dart';

class HrManagerAccountList extends StatefulWidget {
  const HrManagerAccountList({Key? key}) : super(key: key);

  @override
  _HrManagerAccountListState createState() => _HrManagerAccountListState();
}

class _HrManagerAccountListState extends State<HrManagerAccountList> {
  bool isSearching = false;

  List<User> users = [];

  bool loading = false, allLoaded = false;

  mockFetch() async{
    if(allLoaded){
      return;
    }
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    List<User> newData = users.length >= 60 ? [] : List.generate(10, (index)
    =>  User(employeeId: '${index + users.length}', email: 'sample${index + users.length}@gmail.com', role: 'NVKD', name: "Nguyễn Văn ${index + users.length}", phoneNumber: '123456789', gender: 'Nam', joinDate: DateTime.now(), dob: DateTime.now(), department: 'Học viện', team: 'Nhóm ${index + users.length}'));
    if(newData.isNotEmpty){
      users.addAll(newData);
    }
    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    double leftRight = MediaQuery.of(context).size.width * 0.05;
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
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      //Số tài khoản
                      SizedBox(
                        child: TextField(
                          autofocus: true,
                          readOnly: true,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.only(left: 20.0),
                            labelText: 'Số tài khoản',
                            hintText: '${users.length}',
                            labelStyle: const TextStyle(
                              color: defaultFontColor,
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

          //Danh sách tài khoản trong widget Card
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
                    itemCount: users.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.only(left: leftRight, right: leftRight, bottom: leftRight),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: ListTile(
                            title: Text(users[index].name),
                            leading: const Icon(Icons.supervised_user_circle),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            dense: true,
                            subtitle: Text(users[index].role),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HrManagerAccountDetail(user: users[index])),
                              );
                            },
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
              iconTheme: const IconThemeData(color: Colors.blueGrey,),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: !isSearching
                  ? const Text("Danh sách tài khoản",style: TextStyle(color: Colors.blueGrey,),)
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
