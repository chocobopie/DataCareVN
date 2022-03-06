import 'package:flutter/material.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/screens/sale_employee/emp_received_issue_list.dart';
import 'package:login_sample/screens/sale_employee/emp_sent_issue_list.dart';

class EmpIssue extends StatefulWidget {
  const EmpIssue({Key? key}) : super(key: key);

  @override
  _EmpIssueState createState() => _EmpIssueState();
}

class _EmpIssueState extends State<EmpIssue> {
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
              height: MediaQuery.of(context).size.height * 0.3),
          Card(
              elevation: 20.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
              child: ListView(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 10.0, right: 18.0, bottom: 5.0),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: IconTextButtonSmall2(
                      imageUrl: 'assets/images/sent_issue.png',
                      text: 'Vấn đề gửi đến các thành viên khác',
                      colorsButton: const [Colors.greenAccent, Colors.white],
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EmpSentIssueList()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: IconTextButtonSmall2(
                      imageUrl: 'assets/images/recieved-issue.png',
                      text: 'Vấn đề được giao',
                      colorsButton: const [Colors.lightGreen, Colors.white],
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EmpReceivedIssue()));
                      },
                    ),
                  ),
                ],
              )),
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
              title: const Text(
                "Các vấn đề",
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
