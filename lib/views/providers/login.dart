import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/views/admin/admin_home.dart';
import 'package:login_sample/views/hr_manager/hr_manager_home.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_leader/sale_leader_home.dart';
import 'package:login_sample/views/sale_employee/sale_emp_home.dart';
import 'package:login_sample/views/sale_manager/sale_manager_home.dart';
import 'package:login_sample/views/providers/authenticate.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  late Account _account = Account();
  bool _loginFailed = false;
  late final Status _loggedInStatus = Status.notLoggedIn;

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
                const SizedBox(height: 30,),

                if(_loginFailed == true) const Text('Tên đăng nhập hoặc mật khẩu không đúng'),
                if(_loginFailed == true) const SizedBox(height: 30,),

                MaterialButton(
                  onPressed: () async {
                    Account account = await auth.login( email.text, password.text );

                    if(_loggedInStatus == Status.loggedInFailed){
                      setState(() {
                        _loginFailed = true;
                      });
                    }
                    
                    if(account.accountId.toString().isNotEmpty){
                          _account = account;
                          Provider.of<AccountProvider>(context, listen: false).setAccount(_account);

                          if(_account.roleId == 0){
                            print('0');
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const HomeAdmin(),
                            ));
                          }else if(_account.roleId == 1){
                            print('1');
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const HomeHRManager(),
                            ));
                          }else if(_account.roleId == 2){
                            print('2');
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const HomeHRManager(),
                            ));
                          }else if(_account.roleId == 3){
                            print('3');
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const HomeSaleManager(),
                            ));
                          }else if(_account.roleId == 4){
                            print('4');
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const HomeSaleLeader(),
                            ));
                          }else if(_account.roleId == 5){
                            print('5');
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const HomeSaleEmployee(),
                            ));
                          }
                    }

                  },
                  height: 45,
                  color: Colors.blue,
                  child: const Text("Đăng nhập", style: TextStyle(color: Colors.white, fontSize: 16.0),),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                const SizedBox(height: 10.0,),
                TextButton(
                    onPressed: (){},
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
