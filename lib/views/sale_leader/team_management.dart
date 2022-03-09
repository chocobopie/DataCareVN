import 'package:flutter/material.dart';
import 'package:login_sample/widgets/IconTextButtonSmall.dart';
import 'package:login_sample/utilities/utils.dart';

class TeamManagement extends StatelessWidget {
  const TeamManagement({Key? key}) : super(key: key);

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
                padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 5.0),
                children: <Widget>[
                  Column(
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: IconTextButtonSmall(
                          text: 'Danh sách khách hàng của nhóm',
                          imageUrl: 'assets/customer-contact-info.png',
                          colorsButton: [Colors.blue, Colors.white],
                          route: 'team_contact_list',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: IconTextButtonSmall(
                          text: 'Danh sách hợp đồng của nhóm',
                          imageUrl: 'assets/contracts.png',
                          colorsButton: [Colors.green, Colors.white],
                          route: 'team_deal_list',
                        ),
                      ),
                    ],
                  )
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
                "Quản lý nhóm",
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


