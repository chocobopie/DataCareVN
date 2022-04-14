import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/authentication_view_model.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';

class EmployeeForgetPassword extends StatefulWidget {
  const EmployeeForgetPassword({Key? key}) : super(key: key);

  @override
  State<EmployeeForgetPassword> createState() => _EmployeeForgetPasswordState();
}

class _EmployeeForgetPasswordState extends State<EmployeeForgetPassword> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
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
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const Text('Vui lòng nhập email của bạn.', style: TextStyle(color: defaultFontColor),),
                      const SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Expanded(
                            child: CustomEditableTextFormField(
                                text: _email.text.isEmpty ? '' : _email.text,
                                title: 'Email',
                                readonly: false,
                                textEditingController: _email,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextButton(
                                color: mainBgColor,
                                text: 'Xác nhận',
                                onPressed: () async {
                                  if(!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  showLoaderDialog(context);
                                  bool result = await _resetPassword(_email.text.toString());

                                  if(result == true){
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Mật khẩu mới đã gửi đến email của bạn')),
                                    );
                                    Navigator.pop(context);
                                  }else{
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Email không tồn tại')),
                                    );
                                  }
                                },
                            ),
                          ),
                        ],
                      ),
                    ],
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

  Future<bool> _resetPassword(String email) async {
    bool result = await AuthenticationViewModel().resetPassword(email);
    return result;
  }
}
