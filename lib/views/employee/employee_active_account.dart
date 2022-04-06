import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/account_view_model.dart';
import 'package:login_sample/views/admin/admin_home.dart';
import 'package:login_sample/views/hr_manager/hr_manager_home.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_home.dart';
import 'package:login_sample/views/sale_leader/sale_leader_home.dart';
import 'package:login_sample/views/sale_manager/sale_manager_home.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';
import 'package:provider/provider.dart';

class EmployeeActiveAccount extends StatefulWidget {
  const EmployeeActiveAccount({Key? key}) : super(key: key);

  @override
  State<EmployeeActiveAccount> createState() => _EmployeeActiveAccountState();
}

class _EmployeeActiveAccountState extends State<EmployeeActiveAccount> {

  late Account _currentAccount;
  late DateTime _accountDob;
  int? _genderId;
  String _dob = '';
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _accountName = TextEditingController();
  final TextEditingController _accountPhoneNumber = TextEditingController();
  final TextEditingController _accountCitizenIdentityCardNumber = TextEditingController();
  final TextEditingController _accountAddress = TextEditingController();
  final TextEditingController _accountNationality = TextEditingController();
  final TextEditingController _accountBankName = TextEditingController();
  final TextEditingController _accountBankAccountOwnerName = TextEditingController();
  final TextEditingController _accountBankAccountNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
  }

  @override
  void dispose() {
    super.dispose();
    _accountName.dispose();
    _accountPhoneNumber.dispose();
    _accountCitizenIdentityCardNumber.dispose();
    _accountAddress.dispose();
    _accountNationality.dispose();
    _accountBankName.dispose();
    _accountBankAccountOwnerName.dispose();
    _accountBankAccountNumber.dispose();
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
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          
                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                  text: _currentAccount.email == null ? '' : _currentAccount.email!,
                                  title: 'Email',
                                  readonly: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),

                          
                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                  borderColor: mainBgColor,
                                  text: _accountName.text.isEmpty ? '' : _accountName.text,
                                  title: 'Họ và tên',
                                  readonly: false,
                                  textEditingController: _accountName,
                                  isLimit: true,
                                  limitNumbChar: 50,
                                  inputNumberOnly: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),

                          Row(
                            children: [
                              Expanded(
                                child: CustomDropdownFormField2(
                                    borderColor: mainBgColor,
                                    label: 'Giới tính',
                                    value: _genderId != null ? gendersUtilities[_genderId!] : null,
                                    hintText: const Text(''),
                                    items: gendersUtilities,
                                    onChanged: (value){
                                      for(int i = 0; i < gendersUtilities.length; i++){
                                        if(value.toString() == genders[i].name){
                                          setState(() {
                                            _genderId = genders[i].genderId;
                                          });
                                        }
                                      }
                                    }
                                ),
                              ),
                              const SizedBox(width: 5.0,),

                              Expanded(
                                child: CustomEditableTextFormField(
                                  borderColor: mainBgColor,
                                  text: _dob,
                                  title: 'Ngày sinh',
                                  readonly: true,
                                  onTap: () async {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    final date = await DatePicker.showDatePicker(
                                      context,
                                      locale : LocaleType.vi,
                                      minTime: DateTime.now().subtract(const Duration(days: 36500)),
                                      currentTime: DateTime.now(),
                                      maxTime: DateTime.now(),
                                    );
                                    if(date != null){
                                      _accountDob = date;
                                      print(_accountDob);
                                      _dob = 'Ngày ${DateFormat('dd-MM-yyyy').format(_accountDob)}';
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),
                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                  textEditingController: _accountPhoneNumber,
                                  borderColor: mainBgColor,
                                  inputNumberOnly: true,
                                  isPhoneNumber: true,
                                  text: _accountPhoneNumber.text.isEmpty ? '' : _accountPhoneNumber.text,
                                  title: 'Số điện thoại',
                                  readonly: false,
                                ),
                              ),
                              const SizedBox(width: 5.0,),
                              Expanded(
                                child: CustomEditableTextFormField(
                                  textEditingController: _accountCitizenIdentityCardNumber,
                                  borderColor: mainBgColor,
                                  inputNumberOnly: true,
                                  citizenIdentity: true,
                                  text: _accountCitizenIdentityCardNumber.text.isEmpty ? '' : _accountCitizenIdentityCardNumber.text,
                                  title: 'CMND hoặc CCCD',
                                  readonly: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),

                          
                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                  textEditingController: _accountAddress,
                                  borderColor: mainBgColor,
                                  text: _accountAddress.text.isEmpty ? '' : _accountAddress.text,
                                  title: 'Địa chỉ',
                                  readonly: false,
                                  isLimit: true,
                                  limitNumbChar: 250,
                                  inputNumberOnly: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),

                          
                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                  textEditingController: _accountNationality,
                                  borderColor: mainBgColor,
                                  text: _accountNationality.text.isEmpty ? '' : _accountNationality.text,
                                  title: 'Quốc tịch',
                                  readonly: false,
                                  isLimit: true,
                                  limitNumbChar: 60,
                                  inputNumberOnly: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),

                          
                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                  textEditingController: _accountBankName,
                                  borderColor: mainBgColor,
                                  text: _accountBankName.text.isEmpty ? '' : _accountBankName.text,
                                  title: 'Tên ngân hàng',
                                  readonly: false,
                                  isLimit: true,
                                  limitNumbChar: 70,
                                  inputNumberOnly: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),

                          
                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                  textEditingController: _accountBankAccountOwnerName,
                                  borderColor: mainBgColor,
                                  text: _accountBankAccountOwnerName.text.isEmpty ? '' : _accountBankAccountOwnerName.text,
                                  title: 'Tên chủ tài khoản ngân hàng',
                                  readonly: false,
                                  isLimit: true,
                                  inputNumberOnly: false,
                                  limitNumbChar: 50,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),

                          
                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                  textEditingController: _accountBankAccountNumber,
                                  borderColor: mainBgColor,
                                  isBankAccountNumber: true,
                                  text: _accountBankAccountNumber.text.isEmpty ? '' : _accountBankAccountNumber.text,
                                  title: 'Số tài khoản ngân hàng',
                                  readonly: false,
                                  inputNumberOnly: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),

                          const SizedBox(height: 20.0,),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextButton(
                                    color: mainBgColor,
                                    text: 'Xác nhận',
                                    onPressed: () async {
                                      if(!_formKey.currentState!.validate()){
                                        return;
                                      }
                                      showLoaderDialog(context);

                                      final data = await _updateAnAccount();
                                      if(data != null){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Cập nhật tài khoản thành công')),
                                        );

                                        Provider.of<AccountProvider>(context, listen: false).setAccount(data);

                                        Navigator.pop(context);
                                        Future.delayed(const Duration(seconds: 1), (){
                                          if(data.roleId == 0){
                                            Navigator.pushReplacement(context, MaterialPageRoute(
                                              builder: (context) => const HomeAdmin(),
                                            ));
                                          }else if(data.roleId == 1){
                                            Navigator.pushReplacement(context, MaterialPageRoute(
                                              builder: (context) => const HomeHRManager(),
                                            ));
                                          }else if(data.roleId == 2){
                                            Navigator.pushReplacement(context, MaterialPageRoute(
                                              builder: (context) => const HomeHRManager(),
                                            ));
                                          }else if(data.roleId == 3){
                                            Navigator.pushReplacement(context, MaterialPageRoute(
                                              builder: (context) => const HomeSaleManager(),
                                            ));
                                          }else if(data.roleId == 4){
                                            Navigator.pushReplacement(context, MaterialPageRoute(
                                              builder: (context) => const HomeSaleLeader(),
                                            ));
                                          }else if(data.roleId == 5){
                                            Navigator.pushReplacement(context, MaterialPageRoute(
                                              builder: (context) => const HomeSaleEmployee(),
                                            ));
                                          }else if(data.roleId == 6){
                                            Navigator.pushReplacement(context, MaterialPageRoute(
                                              builder: (context) => const HomeSaleManager(),
                                            ));
                                          }
                                        });
                                      }else{
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Cập nhật tài thất bại')),
                                        );
                                      }
                                    },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40.0,),
                        ],
                      )
                  ),
                ),
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

  Future<Account?> _updateAnAccount() async {
    Account account = Account(
      accountId: _currentAccount.accountId,
      email: _currentAccount.email,
      fullname: _accountName.text,
      phoneNumber: _accountPhoneNumber.text,
      address: _accountAddress.text,
      citizenIdentityCardNumber: _accountCitizenIdentityCardNumber.text,
      nationality: _accountNationality.text,
      bankName: _accountBankName.text,
      bankAccountName: _accountBankAccountOwnerName.text,
      bankAccountNumber: _accountBankAccountNumber.text,
      roleId: _currentAccount.roleId,
      blockId: _currentAccount.blockId,
      departmentId: _currentAccount.departmentId,
      teamId: _currentAccount.teamId,
      permissionId: _currentAccount.permissionId,
      statusId: 1,
      genderId: _genderId,
      dateOfBirth: _accountDob,
    );

    Account? result = await AccountViewModel().updateAnAccount(account);

    return result;
  }
}
