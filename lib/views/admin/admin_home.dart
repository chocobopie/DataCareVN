import 'package:flutter/material.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/widgets/ImageTextButton.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/admin/admin_account_list.dart';
import 'package:login_sample/widgets/SideBar.dart';
import 'package:provider/provider.dart';


class HomeAdmin extends StatelessWidget {
  const HomeAdmin({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var _account = Provider.of<AccountProvider>(context).account;
    return Scaffold(
      drawer: SideBar(context,
        name: 'Admin',
        role: rolesNames[_account.roleId!],
        imageUrl: 'assets/images/logo.png',
        roleId: _account.roleId!,
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
                padding: const EdgeInsets.only(top: 20.0, left: 30.0),
                children: <Widget>[
                  Row(
                    children: [
                      ImageTextButton(
                          imageUrl: 'assets/images/account_list.png',
                          text: 'Xem danh sách nhân viên',
                          buttonColors: const [Colors.blue, Colors.white],
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const AdminAccountList(),
                            ));
                          }
                      ),
                      const SizedBox(width: 30.0,),
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
              iconTheme: const IconThemeData(color: Colors.blueGrey,),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Quản trị viên",
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
