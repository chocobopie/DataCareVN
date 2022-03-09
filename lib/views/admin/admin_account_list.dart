import 'package:flutter/material.dart';
import 'package:login_sample/models/temp/user_temp.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomFilterFormField.dart';
import 'package:provider/provider.dart';
import 'admin_account_add.dart';

class AdminAccountList extends StatefulWidget {
  const AdminAccountList({Key? key}) : super(key: key);

  @override
  _AdminAccountListState createState() => _AdminAccountListState();
}

class _AdminAccountListState extends State<AdminAccountList> {
  final ScrollController _scrollController = ScrollController();
  List<User> users = [];
  bool loading = false, allLoaded = false, isSearching = false;

  mockFetch() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    List<User> newData = users.length >= 60
        ? []
        : List.generate(
            10,
            (index) => User(
                employeeId: '${index + users.length}',
                email: 'sample${index + users.length}@gmail.com',
                role: 'NVKD',
                name: "Nguyễn Văn ${index + users.length}",
                phoneNumber: '123456789',
                gender: 'Nam',
                joinDate: DateTime.now(),
                dob: DateTime.now(),
                department: 'Học viện',
                team: 'Nhóm ${index + users.length}'));
    if (newData.isNotEmpty) {
      users.addAll(newData);
    }
    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    mockFetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        mockFetch();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  String? selectedValue;
  String? selectedValue2;
  String? selectedValue3;
  String? selectedValue4;
  String? selectedValue5;

  @override
  Widget build(BuildContext context) {
    var account = Provider.of<AccountProvider>(context).account;
    return Scaffold(
       floatingActionButton: account.roleId == 0 ? FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const AdminAccountAdd(),
          ));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.plus_one),
      ) : null,
      body: Stack(
        children: <Widget>[
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomCenter,
                      colors: [mainBgColor, mainBgColor])),
              height: MediaQuery.of(context).size.height * 0.15),
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
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Text('LỌC THEO', style: TextStyle(color: defaultFontColor, fontWeight: FontWeight.w400),),
                          const SizedBox(width: 10,),
                          CustomFilterFormField(
                              items: rolesTemp,
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
                            items: blocksTemp,
                            titleWidth: 130,
                            dropdownWidth: 220,
                            hint: 'Khối',
                            selectedValue: selectedValue2,
                            onChanged: (value) {
                              setState(() {
                                selectedValue2 = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                        children: <Widget>[
                          CustomFilterFormField(
                            items: departmentTemp,
                            titleWidth: 120,
                            dropdownWidth: 220,
                            hint: 'Phòng ban',
                            selectedValue: selectedValue3,
                            onChanged: (value) {
                              setState(() {
                                selectedValue3 = value;
                              });
                            },
                          ),
                          const SizedBox(width: 5.0,),
                          CustomFilterFormField(
                            items: teamTemp,
                            titleWidth: 120,
                            dropdownWidth: 220,
                            hint: 'Nhóm',
                            selectedValue: selectedValue4,
                            onChanged: (value) {
                              setState(() {
                                selectedValue4 = value;
                              });
                            },
                          ),
                          const SizedBox(width: 5.0,),
                          CustomFilterFormField(
                            items: statusTemp,
                            titleWidth: 120,
                            dropdownWidth: 150,
                            hint: 'Trạng thái',
                            selectedValue: selectedValue5,
                            onChanged: (value) {
                              setState(() {
                                selectedValue5 = value;
                              });
                            },
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
            padding: EdgeInsets.only(
                left: 0.0,
                right: 0.0,
                top: MediaQuery.of(context).size.height * 0.27),
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
                  margin: EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                      top: MediaQuery.of(context).size.height * 0.01),
                  child: users.isNotEmpty
                      ? Stack(
                          children: [
                            ListView.separated(
                                controller: _scrollController,
                                itemBuilder: (context, index) {
                                  if (index < users.length) {
                                    return ListTile(
                                      title: Text('Tên: ${users[index].name}'),
                                      subtitle: Text(
                                          'Chức vụ:  ${users[index].role}'),
                                      dense: true,
                                      trailing: Column(
                                        children: [
                                          Text(
                                              'Phòng: ${users[index].department}'),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text('Nhóm: ${users[index].team}'),
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
                                  );
                                },
                                itemCount: users.length + (allLoaded ? 1 : 0)),
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
                        )
                      : const Center(child: CircularProgressIndicator())
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.blueGrey,
              ), // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: !isSearching
                  ? const Text(
                      "Danh sách tài khoản",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    )
                  : const TextField(
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                      showCursor: true,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: Colors.blueGrey,
                        ),
                        hintText: "Search name, email",
                        hintStyle: TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
              actions: <Widget>[
                isSearching
                    ? IconButton(
                        icon: const Icon(
                          Icons.cancel,
                        ),
                        onPressed: () {
                          setState(() {
                            isSearching = false;
                          });
                        },
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.search,
                        ),
                        onPressed: () {
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
