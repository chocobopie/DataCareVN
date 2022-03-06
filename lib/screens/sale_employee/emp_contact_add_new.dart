import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';

class EmpContactAddNew extends StatefulWidget {
  const EmpContactAddNew({Key? key, required this.account}) : super(key: key);

  final Account account;

  @override
  _EmpContactAddNewState createState() => _EmpContactAddNewState();
}

class _EmpContactAddNewState extends State<EmpContactAddNew> {
  
  late Future<List<Account>> futureAccounts;
  
  late List<Account> accounts = [];
  late List<String> accountIdFullnames = [];

  final TextEditingController _contactName = TextEditingController();
  final TextEditingController _contactEmail = TextEditingController();
  final TextEditingController _contactPhoneNumber = TextEditingController();
  final TextEditingController _contactCompanyName = TextEditingController();
  final TextEditingController _contactOwnerId = TextEditingController();
  final TextEditingController _contactGender = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getOverallInfo();
  }

  @override
  void dispose() {
    _contactName.dispose();
    _contactEmail.dispose();
    _contactPhoneNumber.dispose();
    _contactCompanyName.dispose();
    _contactOwnerId.dispose();
    _contactGender.dispose();
    super.dispose();
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
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[

                    //Tên khách hàng
                    CustomEditableTextField(
                        text: '',
                        title: 'Tên khách hàng',
                        readonly: false,
                        textEditingController: _contactName
                    ),
                    const SizedBox(height: 20.0,),

                    CustomDropdownFormField2(
                        label: 'Giới tính',
                        hintText: const Text('Giới tính khách hàng'),
                        items: gendersUtilities,
                        onChanged: (value){
                          if(value.toString() == gendersUtilities[0]){
                            _contactGender.text = '0';
                          }else if(value.toString() == gendersUtilities[1]){
                            _contactGender.text = '1';
                          }else if(value.toString() == gendersUtilities[2]){
                            _contactGender.text = '2';
                          }
                        }
                    ),
                    const SizedBox(height: 20.0,),

                    //Tên công ty
                    CustomEditableTextField(
                        text: '',
                        title: 'Tên công ty khách hàng',
                        readonly: false,
                        textEditingController: _contactCompanyName
                    ),
                    const SizedBox(height: 20.0,),

                    //Email khách hàng
                    CustomEditableTextField(
                        text: '',
                        title: 'Email của khách hàng',
                        readonly: false,
                        textEditingController: _contactEmail
                    ),
                    const SizedBox(height: 20.0,),

                    //Phone number
                   CustomEditableTextField(
                       inputNumberOnly: true,
                       text: '',
                       title: 'Số điện thoại',
                       readonly: false,
                       textEditingController: _contactPhoneNumber
                   ),
                    const SizedBox(height: 20.0,),

                    //Contact Owner Id
                    CustomDropdownFormField2(
                        label: 'Khách hàng của',
                        hintText: Text(_getAccountFullname(widget.account.accountId!)),
                        items: accountIdFullnames,
                        onChanged: (value){
                          _contactOwnerId.text = value.toString().substring(0, value.toString().indexOf(','));
                          print(value.toString());
                          print(_contactOwnerId.text);
                        }
                    ),
                    const SizedBox(height: 20.0,),
                    

                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
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
                        onPressed: (){
                          if(_contactName.text.isNotEmpty && _contactCompanyName.text.isNotEmpty && _contactPhoneNumber.text.isNotEmpty
                             && _contactEmail.text.isNotEmpty && _contactGender.text.isNotEmpty){
                            Contact contact = Contact(
                              contactId: 0,
                              fullname: _contactName.text,
                              companyName: _contactCompanyName.text,
                              contactOwnerId: _contactOwnerId.text.isEmpty ? widget.account.accountId! : int.parse(_contactOwnerId.text),
                              phoneNumber: _contactPhoneNumber.text,
                              email: _contactEmail.text,
                              genderId: int.parse(_contactGender.text),
                              leadSourceId: 0,
                              statusId: 0
                            );
                            ApiService().createNewContact(contact);
                            Future.delayed(const Duration(seconds: 3), (){
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: const Text(
                          'Thêm mới',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
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

  void _getOverallInfo(){
    _getAccountListByBlockIdDepartmentId();
  }
  
  void _getAccountListByBlockIdDepartmentId(){
    futureAccounts = ApiService().getAllAccountByBlockIdDepartmentId(widget.account.blockId!, widget.account.departmentId!);

    futureAccounts.then((value) {
      if(accounts.isNotEmpty){
        accounts.clear();
      }
      setState(() {
        accounts.addAll(value);
        for(int i = 0; i < accounts.length; i++){
          if( accounts[i].roleId! < 3 || accounts[i].roleId! > 5){
            accounts.removeAt(i);
          }
        }
        _getAccountIdNames();
      });
    });
  }

  void _getAccountIdNames(){
    if(accountIdFullnames.isNotEmpty){
      accountIdFullnames.clear();
    }

    for(int i = 0; i < accounts.length; i++){
      String idAndName = ('${accounts[i].accountId}_${accounts[i].fullname}');
      String split = '${idAndName.split('_')}';
      accountIdFullnames.add(split.substring(1, split.length-1));
    }
    print(accountIdFullnames);
  }
  
  String _getAccountFullname(int accountId){
    String accountFullname = '';
    for(int i = 0; i < accountIdFullnames.length; i++){
      if(accountId == int.parse(accountIdFullnames[i].substring(0,  accountIdFullnames[i].indexOf(',')))){
        accountFullname = accountIdFullnames[i].substring(accountIdFullnames[i].indexOf(',')+2, accountIdFullnames[i].length);
      }
    }
    return accountFullname;
  }
}
