import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/view_models/contact_view_model.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_filter.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:provider/provider.dart';

class SaleEmpContactAddNew extends StatefulWidget {
  const SaleEmpContactAddNew({Key? key, required this.account}) : super(key: key);

  final Account account;

  @override
  _SaleEmpContactAddNewState createState() => _SaleEmpContactAddNewState();
}

class _SaleEmpContactAddNewState extends State<SaleEmpContactAddNew> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _fullname = '', _gender = '', _leadSource = '';

  final TextEditingController _contactName = TextEditingController();
  final TextEditingController _contactEmail = TextEditingController();
  final TextEditingController _contactPhoneNumber = TextEditingController();
  final TextEditingController _contactCompanyName = TextEditingController();
  final TextEditingController _contactOwnerId = TextEditingController();
  final TextEditingController _contactGender = TextEditingController();
  final TextEditingController _contactLeadSourceId = TextEditingController();

  late Account _currentAccount;


  @override
  void dispose() {
    _contactName.dispose();
    _contactEmail.dispose();
    _contactPhoneNumber.dispose();
    _contactCompanyName.dispose();
    _contactOwnerId.dispose();
    _contactGender.dispose();
    _contactLeadSourceId.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _fullname = _currentAccount.fullname!;
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
              height: MediaQuery.of(context).size.height * 0.3
          ),
          Card(
              elevation: 20.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              margin: const EdgeInsets.only(top: 100.0),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: _fullname.isNotEmpty ? ListView(
                    children: <Widget>[
                      //Tên khách hàng
                      CustomEditableTextFormField(
                          borderColor: mainBgColor,
                          text: _contactName.text,
                          title: 'Tên khách hàng',
                          readonly: false,
                          textEditingController: _contactName,
                          isLimit: true,
                          limitNumbChar: 50,
                          inputNumberOnly: false,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomDropdownFormField2(
                          value: _contactGender.text.isNotEmpty ? _gender : null,
                          borderColor: mainBgColor,
                          label: 'Giới tính',
                          hintText: const Text(''),
                          items: gendersNames,
                          onChanged: (value){
                            setState(() {
                              _gender = value.toString();
                            });
                            if(value.toString() == gendersNames[0]){
                              _contactGender.text = '0';
                            }else if(value.toString() == gendersNames[1]){
                              _contactGender.text = '1';
                            }else if(value.toString() == gendersNames[2]){
                              _contactGender.text = '2';
                            }
                          }
                      ),
                      const SizedBox(height: 20.0,),
                      CustomEditableTextFormField(
                          borderColor: mainBgColor,
                          inputNumberOnly: true,
                          isPhoneNumber: true,
                          text: _contactPhoneNumber.text,
                          title: 'Số điện thoại',
                          readonly: false,
                          textEditingController: _contactPhoneNumber
                      ),
                      const SizedBox(height: 20.0,),

                      //Tên công ty
                      CustomEditableTextFormField(
                          borderColor: mainBgColor,
                          text: _contactCompanyName.text,
                          title: 'Tên công ty khách hàng',
                          readonly: false,
                          textEditingController: _contactCompanyName,
                          inputNumberOnly: false,
                          limitNumbChar: 70,
                          isLimit: true,
                      ),
                      const SizedBox(height: 20.0,),

                      //Email khách hàng
                      CustomEditableTextFormField(
                          isNull: false,
                          isEmailCheck: true,
                          borderColor: mainBgColor,
                          text: _contactEmail.text,
                          title: 'Email của khách hàng',
                          readonly: false,
                          textEditingController: _contactEmail,
                          isLimit: true,
                          limitNumbChar: 40,
                          inputNumberOnly: false,
                      ),
                      const SizedBox(height: 20.0,),

                      if(_fullname.isNotEmpty) CustomEditableTextFormField(
                          borderColor: _currentAccount.roleId != 5 ? mainBgColor : null,
                          text: _fullname,
                          title: 'Nhân viên tạo',
                          readonly: true,
                          textEditingController: _contactOwnerId,
                          onTap: _currentAccount.roleId != 5 ? () async {
                          final data = await Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const SaleEmpFilter(),
                          ));
                          late Account filterAccount;
                          if(data != null){
                            setState(() {
                              filterAccount = data;
                              _contactOwnerId.text = filterAccount.accountId!.toString();
                              _fullname = filterAccount.fullname!;
                            });
                          }
                        } : null,
                      ),
                      const SizedBox(height: 20.0,),

                      //Nguồn
                      CustomDropdownFormField2(
                          value: _contactLeadSourceId.text.isNotEmpty ? _leadSource : null,
                          borderColor: mainBgColor,
                          label: 'Nguồn',
                          hintText: const Text(''),
                          items: leadSourceNames,
                          onChanged: (value){
                            setState(() {
                              _leadSource = value.toString();
                            });
                            if(value.toString() == leadSourceNames[0]){
                              _contactLeadSourceId.text = '0';
                            }else if(value.toString() == leadSourceNames[1]){
                              _contactLeadSourceId.text = '1';
                            }else if(value.toString() == leadSourceNames[2]){
                              _contactLeadSourceId.text = '2';
                            }
                          }
                      ),
                      const SizedBox(height: 20.0,),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: mainBgColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 1,
                                    offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  if(!_formKey.currentState!.validate()){
                                    return;
                                  }
                                  showLoaderDialog(context);
                                  bool data = await _createNewContact();
                                  if(data == true){
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Tạo khách hàng thành công')),
                                    );
                                    Future.delayed(const Duration(seconds: 2), (){
                                      Navigator.pop(context);
                                    });
                                  }else{
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Tạo khách hàng thất bại')),
                                    );
                                  }

                                },
                                child: const Text(
                                  'Thêm khách hàng',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ) : const Center(child: CircularProgressIndicator())
                ),
              )
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                'Thêm khách hàng mới',
                style: TextStyle(
                  letterSpacing: 0.0,
                  fontSize: 20.0,
                  color: Colors.blueGrey
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _createNewContact() async {

    Contact contact = Contact(
        contactId: 0,
        fullname: _contactName.text,
        companyName: _contactCompanyName.text,
        contactOwnerId: _contactOwnerId.text.isEmpty ? _currentAccount.accountId! : int.parse(_contactOwnerId.text),
        phoneNumber: _contactPhoneNumber.text,
        email: _contactEmail.text,
        genderId: int.parse(_contactGender.text),
        leadSourceId: int.parse(_contactLeadSourceId.text),
        createdDate: DateTime.now()
    );

    bool result = await ContactViewModel().createNewContact(contact);

    return result;
  }
}
