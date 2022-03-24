import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';

class EmployeeForgetPassword extends StatefulWidget {
  const EmployeeForgetPassword({Key? key}) : super(key: key);

  @override
  State<EmployeeForgetPassword> createState() => _EmployeeForgetPasswordState();
}

class _EmployeeForgetPasswordState extends State<EmployeeForgetPassword> {
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
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),

              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: const <Widget>[
                        Text('Vui lòng nhập email của bạn để hệ thống gửi mật khẩu mới đến email của bạn', style: TextStyle(color: defaultFontColor),),
                        SizedBox(height: 20.0,),
                        CustomEditableTextFormField(
                            text: 'Email của bạn',
                            title: 'Email',
                            readonly: false,
                            width: 300.0,
                        ),
                        SizedBox(height: 20.0,),
                        CustomTextButton(
                            color: Colors.blueAccent,
                            text: 'Xác nhận'
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
                'Quên mật khẩu',
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
