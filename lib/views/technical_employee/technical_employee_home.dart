import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/employee/employee_received_issue_list.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/widgets/ImageTextButton.dart';
import 'package:login_sample/widgets/SideBar.dart';
import 'package:provider/provider.dart';

class TechnicalEmployeeHome extends StatefulWidget {
  const TechnicalEmployeeHome({Key? key}) : super(key: key);

  @override
  State<TechnicalEmployeeHome> createState() => _TechnicalEmployeeHomeState();
}

class _TechnicalEmployeeHomeState extends State<TechnicalEmployeeHome> {

  Account? _currentAccount;

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(context,
        name: _currentAccount!.fullname!,
        role: rolesNames[_currentAccount!.roleId!],
        imageUrl: 'assets/images/logo.png',
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
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              margin: const EdgeInsets.only(top: 100.0),
              child: ListView(
                padding: const EdgeInsets.only(top: 10.0, left: 35.0, bottom: 5.0),
                children: <Widget>[
                  Row(
                    children: [
                      ImageTextButton(
                          imageUrl: 'assets/images/issue.png',
                          text: 'Xem vấn đề',
                          buttonColors: const [Colors.grey, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const EmployeeReceivedIssue(),
                            ));
                          }
                      ),
                      const SizedBox(width: 20.0,),
                    ],
                  ),
                ],
              )
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Phòng kinh doanh",
                style: TextStyle(
                  letterSpacing: 0.0,
                  fontSize: 20.0,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
