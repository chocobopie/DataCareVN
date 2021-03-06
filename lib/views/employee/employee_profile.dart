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
                          text: _currentAccount.email == null ? 'Ch??a c???p nh???t' : _currentAccount.email!,
                          title: 'Email',
                          readonly: _readOnly,
                          textEditingController: _email
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.fullname == null ? 'Ch??a c???p nh???t' : _currentAccount.fullname!,
                          title: 'H??? v?? t??n',
                          readonly: _readOnly,
                          textEditingController: _fullname
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.phoneNumber == null ? 'Ch??a c???p nh???t' : _currentAccount.phoneNumber!,
                          title: 'S??? ??i???n tho???i',
                          readonly: _readOnly,
                          textEditingController: _phonenumber
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.address == null ? 'Ch??a c???p nh???t' : _currentAccount.address!,
                          title: '?????a ch???',
                          readonly: _readOnly,
                          textEditingController: _address
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.citizenIdentityCardNumber == null ? 'Ch??a c???p nh???t' : _currentAccount.citizenIdentityCardNumber!,
                          title: 'CMND ho???c CCCD',
                          readonly: _readOnly,
                          textEditingController: _citizenIdentityCardNumber
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.nationality == null ? 'Ch??a c???p nh???t' : _currentAccount.nationality!,
                          title: 'Qu???c t???ch',
                          readonly: _readOnly,
                          textEditingController: _nationality
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.bankName == null ? 'Ch??a c???p nh???t' : _currentAccount.bankName!,
                          title: 'T??n ng??n h??ng',
                          readonly: _readOnly,
                          textEditingController: _bankName
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.bankAccountName == null ? 'Ch??a c???p nh???t' : _currentAccount.bankAccountName!,
                          title: 'T??n ch??? t??i kho???n',
                          readonly: _readOnly,
                          textEditingController: _bankAccountName
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.bankAccountNumber == null ? 'Ch??a c???p nh???t' : _currentAccount.bankAccountNumber!,
                          title: 'S??? t??i kho???n',
                          readonly: _readOnly,
                          textEditingController: _bankAccountNumber
                      ),
                      const SizedBox(height: 20.0,),

                      CustomDropdownFormField2(
                          label: 'Gi???i t??nh',
                          hintText: _currentAccount.genderId != null ? Text(gendersNames[_currentAccount.genderId!]) : const Text('Ch??a c???p nh???t'),
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

                      //Ng??y sinh
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
                                _dateOfBirthString = 'Ng??y ${DateFormat('dd-MM-yyyy').format(date)}';
                              });
                            }
                          } : null,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.only(left: 20.0),
                            labelText: 'Ng??y sinh',
                            hintText: _dateOfBirthString.isNotEmpty ? _dateOfBirthString : _currentAccount.dateOfBirth == null ? 'Ch??a c???p nh???t' : 'Ng??y ${DateFormat('dd-MM-yyyy').format(_currentAccount.dateOfBirth!)}',
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
                'Th??ng tin c?? nh??n',
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
