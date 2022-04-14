import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/change_password.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/change_password_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';
import 'package:provider/provider.dart';

class EmployeeChangePassword extends StatefulWidget {
  const EmployeeChangePassword({Key? key}) : super(key: key);

  @override
  State<EmployeeChangePassword> createState() => _EmployeeChangePasswordState();
}

class _EmployeeChangePasswordState extends State<EmployeeChangePassword> {

  late Account _currentAccount;

  final GlobalKey<FormState> _formKey = GlobalKey();
  late bool _isSimilar = true;

  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword  = TextEditingController();
  final TextEditingController _newPasswordConfirm = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
  }

  @override
  void dispose() {
    super.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    _newPasswordConfirm.dispose();
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
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 40.0,),
                        CustomEditableTextFormField(
                          obscureText: true,
                          text: _currentPassword.text.isEmpty ? '' : _currentPassword.text,
                          title: 'Mật khẩu hiện tại của bạn',
                          readonly: false,
                          width: 400.0,
                          textEditingController: _currentPassword,
                        ),
                        const SizedBox(height: 20.0,),
                        CustomEditableTextFormField(
                          obscureText: true,
                          text: _newPassword.text.isEmpty ? '' : _newPassword.text,
                          title: 'Mật khẩu mới',
                          readonly: false,
                          width: 400.0,
                          textEditingController: _newPassword,
                        ),
                        const SizedBox(height: 20.0,),
                        CustomEditableTextFormField(
                          obscureText: true,
                          text: _newPasswordConfirm.text.isEmpty ? '' : _newPasswordConfirm.text,
                          title: 'Nhập lại mật khẩu mới',
                          readonly: false,
                          width: 400.0,
                          textEditingController: _newPasswordConfirm
                        ),
                        const SizedBox(height: 10.0,),
                        if(_isSimilar == false) const Text('Mật khẩu mới của bạn không khớp', style: TextStyle(color: Colors.red),),
                        const SizedBox(height: 20.0,),
                        CustomTextButton(
                            color: Colors.blueAccent,
                            text: 'Đổi mật khẩu',
                            onPressed: () async {
                              if(!_formKey.currentState!.validate()) {
                                return;
                              }
                              if(_newPassword.text != _newPasswordConfirm.text){
                                setState(() {
                                  _isSimilar = false;
                                });
                              }else{
                                setState(() {
                                  _isSimilar = true;
                                });

                                showLoaderDialog(context);

                                bool data = await _changePassword();
                                if(data == true){
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Đổi mật khẩu thành công')),
                                  );
                                  Navigator.pop(context);
                                }else{
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Mật khẩu hiện tại của bạn không chính xác')),
                                  );
                                }

                              }

                            },

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

  Future<bool> _changePassword() async {
    ChangePassword changePassword = ChangePassword(
        accountId: _currentAccount.accountId!,
        email: _currentAccount.email!,
        currentPassword: _currentPassword.text,
        newPassword: _newPasswordConfirm.text
    );

    bool result = await ChangePasswordViewModel().changePassword(changePassword);

    return result;
  }
}
