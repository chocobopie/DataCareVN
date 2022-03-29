import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';

class EmployeeChangePassword extends StatefulWidget {
  const EmployeeChangePassword({Key? key}) : super(key: key);

  @override
  State<EmployeeChangePassword> createState() => _EmployeeChangePasswordState();
}

class _EmployeeChangePasswordState extends State<EmployeeChangePassword> {
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
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              margin: const EdgeInsets.only(top: 100.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: const <Widget>[
                        SizedBox(height: 40.0,),
                        CustomEditableTextFormField(
                          obscureText: true,
                          text: '',
                          title: 'Mật khẩu hiện tại của bạn',
                          readonly: false,
                          width: 400.0,
                        ),
                        SizedBox(height: 20.0,),
                        CustomEditableTextFormField(
                          obscureText: true,
                          text: '',
                          title: 'Mật khẩu mới',
                          readonly: false,
                          width: 400.0,
                        ),
                        SizedBox(height: 20.0,),
                        CustomEditableTextFormField(
                          obscureText: true,
                          text: '',
                          title: 'Nhập lại mật khẩu mới',
                          readonly: false,
                          width: 400.0,
                        ),
                        SizedBox(height: 20.0,),
                        CustomTextButton(
                            color: Colors.blueAccent,
                            text: 'Đổi mật khẩu'
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(
                  color: Colors.blueGrey), // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                'Đổi mật khẩu',
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
