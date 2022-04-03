import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:provider/provider.dart';

class EmployeeActiveAccount extends StatefulWidget {
  const EmployeeActiveAccount({Key? key}) : super(key: key);

  @override
  State<EmployeeActiveAccount> createState() => _EmployeeActiveAccountState();
}

class _EmployeeActiveAccountState extends State<EmployeeActiveAccount> {

  late Account _currentAccount;

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
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
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: <Widget>[
                      CustomEditableTextFormField(
                        text: _currentAccount.email == null ? '' : _currentAccount.email!,
                        title: 'Email',
                        readonly: false,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                        text: _currentAccount.fullname == null ? '' : _currentAccount.fullname!,
                        title: 'Họ và tên',
                        readonly: false,
                      ),
                      const SizedBox(height: 20.0,),

                      Row(
                        children: [
                          Expanded(
                            child: CustomEditableTextFormField(
                              text: _currentAccount.phoneNumber == null ? '' : _currentAccount.phoneNumber!,
                              title: 'Số điện thoại',
                              readonly: false,
                            ),
                          ),
                          const SizedBox(width: 5.0,),
                          Expanded(
                            child: CustomEditableTextFormField(
                              text: _currentAccount.citizenIdentityCardNumber == null ? '' : _currentAccount.citizenIdentityCardNumber!,
                              title: 'CMND hoặc CCCD',
                              readonly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                        text: _currentAccount.address == null ? '' : _currentAccount.address!,
                        title: 'Địa chỉ',
                        readonly: false,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                        text: _currentAccount.nationality == null ? '' : _currentAccount.nationality!,
                        title: 'Quốc tịch',
                        readonly: false,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                        text: _currentAccount.bankName == null ? '' : _currentAccount.bankName!,
                        title: 'Tên ngân hàng',
                        readonly: false,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                        text: _currentAccount.bankAccountName == null ? '' : _currentAccount.bankAccountName!,
                        title: 'Tên chủ tài khoản',
                        readonly: false,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                        text: _currentAccount.bankAccountNumber == null ? '' : _currentAccount.bankAccountNumber!,
                        title: 'Số tài khoản',
                        readonly: false,
                      ),
                      const SizedBox(height: 20.0,),

                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdownFormField2(
                                label: 'Giới tính',
                                hintText: _currentAccount.genderId != null ? Text(gendersUtilities[_currentAccount.genderId!]) : const Text(''),
                                items: gendersUtilities,
                                onChanged: null
                            ),
                          ),
                          const SizedBox(width: 5.0,),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.only(left: 20.0),
                                labelText: 'Ngày sinh',
                                hintText: _currentAccount.dateOfBirth == null ? '' : 'Ngày ${DateFormat('dd-MM-yyyy').format(_currentAccount.dateOfBirth!)}',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 107, 106, 144),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),


                    ],
                  )
              )),
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
                'Cập nhật thông tin cá nhân',
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
