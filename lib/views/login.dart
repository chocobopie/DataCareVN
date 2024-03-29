import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/views/admin/admin_home.dart';
import 'package:login_sample/views/employee/employee_active_account.dart';
import 'package:login_sample/views/employee/employee_forget_password.dart';
import 'package:login_sample/views/hr/hr_home.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/views/sale_leader/sale_leader_home.dart';
import 'package:login_sample/views/sale_employee/sale_emp_home.dart';
import 'package:login_sample/views/sale_manager/sale_manager_home.dart';
import 'package:login_sample/services/authenticate.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/technical_employee/technical_employee_home.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _loginFailed = false, _isEmailEmpty = false, _isPasswordEmpty = false;
  Account? account;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Image.asset('assets/images/logo.png'),
                const SizedBox(height: 40,),
                TextField(
                  onChanged: (val){
                    setState(() {
                      email.text = val.toString();
                    });
                  },
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    labelText: 'Email',
                    hintText: 'Email của bạn',
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 107, 106, 144),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: const Icon(Icons.mail, color: Color.fromARGB(255, 107, 106, 144), size: 18,),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Color.fromARGB(255, 107, 106, 144),
                      fontSize: 18,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color.fromARGB(255, 107, 106, 144), width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                if(_isEmailEmpty == true) const Text('Email không được để trống', style: TextStyle(color: Colors.red),),
                const SizedBox(height: 20,),

                TextField(
                  onChanged: (val){
                    setState(() {
                      password.text = val.toString();
                    });
                  },
                  obscureText: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      labelText: 'Mật khẩu',
                      hintText: 'Mật khẩu của bạn',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 107, 106, 144),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: const Icon(Icons.password, color: Color.fromARGB(255, 107, 106, 144), size: 18),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color.fromARGB(255, 107, 106, 144),
                        fontSize: 18.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color.fromARGB(255, 107, 106, 144), width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                      )
                  ),
                ),
                if(_isPasswordEmpty == true) const Text('Mật khẩu không được để trống', style: TextStyle(color: Colors.red),),
                const SizedBox(height: 30,),

                if(_loginFailed == true) const Text('Tên đăng nhập hoặc mật khẩu không đúng', style: TextStyle(color: Colors.red),),
                if(_loginFailed == true) const SizedBox(height: 30,),

                MaterialButton(
                  onPressed: () async {

                    showLoaderDialog(context);

                    setState(() {
                      _loginFailed = false;
                    });

                    if(email.text.isEmpty){
                      setState(() {_isEmailEmpty = true;});
                    }else{
                      setState(() {_isEmailEmpty = false;});
                    }

                    if(password.text.isEmpty){
                      setState(() {_isPasswordEmpty = true;});
                    }else{
                      setState(() {_isPasswordEmpty = false;});
                    }

                    if(_isEmailEmpty == true && _isPasswordEmpty == true){
                      Navigator.pop(context);
                    }

                    if(_isPasswordEmpty == false && _isEmailEmpty == false){
                      account = await auth.login( email.text, password.text );

                      if(account != null){

                        Provider.of<AccountProvider>(context, listen: false).setAccount(account!);

                        if(account!.statusId == 1){
                          if(account!.roleId == 0){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                              builder: (context) => const HomeAdmin()),
                                    (Route<dynamic> route) => false
                            );
                          }else if(account!.roleId == 1){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                              builder: (context) => const HomeHRManager(),),
                                    (Route<dynamic> route) => false
                            );
                          }else if(account!.roleId == 2){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                              builder: (context) => const HomeHRManager(),),
                                    (Route<dynamic> route) => false
                            );
                          }else if(account!.roleId == 3){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                              builder: (context) => const HomeSaleManager(),),
                                    (Route<dynamic> route) => false
                            );
                          }else if(account!.roleId == 4){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                              builder: (context) => const HomeSaleLeader(),),
                                    (Route<dynamic> route) => false
                            );
                          }else if(account!.roleId == 5){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                              builder: (context) => const HomeSaleEmployee(),),
                                    (Route<dynamic> route) => false
                            );
                          }else if(account!.roleId == 6){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                              builder: (context) => const TechnicalEmployeeHome(),),
                                    (Route<dynamic> route) => false
                            );
                          }

                        }else if(account!.statusId == 0){
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => const EmployeeActiveAccount(),
                          ));
                        }
                      }else{
                        setState(() {
                          _loginFailed = true;
                        });
                        Navigator.pop(context);
                      }
                    }

                  },
                  height: 45,
                  color: mainBgColor,
                  child: const Text("Đăng nhập", style: TextStyle(color: Colors.white, fontSize: 16.0),),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                const SizedBox(height: 10.0,),
                TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const EmployeeForgetPassword(),
                      ));
                    },
                    child: const Text('Quên mật khẩu', style: TextStyle(color: defaultFontColor),)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
