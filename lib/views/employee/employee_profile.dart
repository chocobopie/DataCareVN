import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:provider/provider.dart';

class EmployeeProfile extends StatefulWidget {
  const EmployeeProfile({Key? key}) : super(key: key);

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {

  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _fullname = TextEditingController();
  late final TextEditingController _phonenumber = TextEditingController();
  late final TextEditingController _address = TextEditingController();
  late final TextEditingController _citizenIdentityCardNumber = TextEditingController();
  late final TextEditingController _nationality = TextEditingController();
  late final TextEditingController _bankName = TextEditingController();
  late final TextEditingController _bankAccountName = TextEditingController();
  late final TextEditingController _bankAccountNumber = TextEditingController();
  late final TextEditingController _dateOfBirth = TextEditingController();
  late final TextEditingController _gender = TextEditingController();

  final bool _readOnly = true;
  late Account _currentAccount;
  late String _dateOfBirthString = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentAccount = Provider.of<AccountProvider>(context, listen: true).account;
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _fullname.dispose();
    _phonenumber.dispose();
    _address.dispose();
    _citizenIdentityCardNumber.dispose();
    _nationality.dispose();
    _bankName.dispose();
    _bankAccountName.dispose();
    _bankAccountNumber.dispose();
    _dateOfBirth.dispose();
    _gender.dispose();
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
                          text: _currentAccount.email == null ? 'Chưa cập nhật' : _currentAccount.email!,
                          title: 'Email',
                          readonly: _readOnly,
                          textEditingController: _email
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.fullname == null ? 'Chưa cập nhật' : _currentAccount.fullname!,
                          title: 'Họ và tên',
                          readonly: _readOnly,
                          textEditingController: _fullname
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.phoneNumber == null ? 'Chưa cập nhật' : _currentAccount.phoneNumber!,
                          title: 'Số điện thoại',
                          readonly: _readOnly,
                          textEditingController: _phonenumber
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.address == null ? 'Chưa cập nhật' : _currentAccount.address!,
                          title: 'Địa chỉ',
                          readonly: _readOnly,
                          textEditingController: _address
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.citizenIdentityCardNumber == null ? 'Chưa cập nhật' : _currentAccount.citizenIdentityCardNumber!,
                          title: 'CMND hoặc CCCD',
                          readonly: _readOnly,
                          textEditingController: _citizenIdentityCardNumber
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.nationality == null ? 'Chưa cập nhật' : _currentAccount.nationality!,
                          title: 'Quốc tịch',
                          readonly: _readOnly,
                          textEditingController: _nationality
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.bankName == null ? 'Chưa cập nhật' : _currentAccount.bankName!,
                          title: 'Tên ngân hàng',
                          readonly: _readOnly,
                          textEditingController: _bankName
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.bankAccountName == null ? 'Chưa cập nhật' : _currentAccount.bankAccountName!,
                          title: 'Tên chủ tài khoản',
                          readonly: _readOnly,
                          textEditingController: _bankAccountName
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.bankAccountNumber == null ? 'Chưa cập nhật' : _currentAccount.bankAccountNumber!,
                          title: 'Số tài khoản',
                          readonly: _readOnly,
                          textEditingController: _bankAccountNumber
                      ),
                      const SizedBox(height: 20.0,),

                      CustomDropdownFormField2(
                          label: 'Giới tính',
                          hintText: _currentAccount.genderId != null ? Text(gendersNames[_currentAccount.genderId!]) : const Text('Chưa cập nhật'),
                          items: gendersNames,
                          onChanged: _readOnly != true ? (value) {
                            if(value.toString() == gendersNames[0]){
                              _gender.text = '0';
                            } else {
                              _gender.text = '1';
                            }
                          } : null,
                      ),
                      const SizedBox(height: 20.0,),

                      //Ngày sinh
                      SizedBox(
                        child: TextField(
                          readOnly: _readOnly,
                          onTap: _readOnly != true ? () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final date = await DatePicker.showDatePicker(
                              context,
                              locale: LocaleType.vi,
                              minTime: DateTime.now().subtract(const Duration(days: 18250)),
                              currentTime: DateTime.now(),
                              maxTime: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (date != null) {
                              setState(() {
                                _dateOfBirth.text = date.toString();
                                _dateOfBirthString = 'Ngày ${DateFormat('dd-MM-yyyy').format(date)}';
                                print(date);
                              });
                            }
                          } : null,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.only(left: 20.0),
                            labelText: 'Ngày sinh',
                            hintText: _dateOfBirthString.isNotEmpty ? _dateOfBirthString : _currentAccount.dateOfBirth == null ? 'Chưa cập nhật' : 'Ngày ${DateFormat('dd-MM-yyyy').format(_currentAccount.dateOfBirth!)}',
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
                        width: 150.0,
                      ),
                      const SizedBox(height: 20.0,),


                    ],
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
                'Thông tin cá nhân',
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
