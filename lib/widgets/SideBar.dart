import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/employee/employee_change_password.dart';
import 'package:login_sample/views/employee/employee_profile.dart';


class SideBar extends StatelessWidget {
  const SideBar(BuildContext context, {Key? key, required this.name, required this.role, required this.imageUrl, this.roleId}) : super(key: key);

  final String name;
  final String role;
  final String imageUrl;
  final int? roleId;

  @override
  Widget build(BuildContext context) {
    double widthDrawer = MediaQuery.of(context).size.width * 0.65;
    double logoutHeight = MediaQuery.of(context).size.height * 0.55;
    return Drawer(
      child: Container(
        color: mainBgColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: UserAccountsDrawerHeader(
                currentAccountPictureSize: Size(widthDrawer, 120),
                currentAccountPicture: Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 120.0,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(imageUrl),
                        radius: 32.0,
                      ),
                    ),
                  ),
                ),

                accountName: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SizedBox(
                    height: 18.0,
                    width: widthDrawer,
                    child: Center(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
                accountEmail: SizedBox(
                  width: widthDrawer,
                  child: Center(
                    child: Text(
                      role,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),

                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
                ),
              ),
            ),
            if(roleId != 0) ListTile(
              contentPadding: const EdgeInsets.only(left: 15.0),
              leading: const Icon(
                Icons.person,
                color: Colors.blueGrey,
              ),
              title: const Text(
                'Xem thông tin cá nhân',
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const EmployeeProfile(),
                ));
              }
            ),
            ListTile(
                contentPadding: const EdgeInsets.only(left: 15.0),
                leading: const Icon(
                  Icons.password,
                  color: Colors.blueGrey,
                ),
                title: const Text(
                  'Đổi mật khẩu',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const EmployeeChangePassword(),
                  ));
                }
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.only(left: 15.0, top: logoutHeight),
              leading: const Icon(
                  Icons.logout,
                color: Colors.blueGrey,
              ),
              title: const Text(
                  'Logout',
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
              onTap: () => print('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
