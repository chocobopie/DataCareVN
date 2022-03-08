import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/screens/providers/account_provider.dart';
import 'package:login_sample/screens/sale_employee/sale_emp_filter.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomReadOnlyTextField.dart';
import 'package:provider/provider.dart';

class EmpContactDetail extends StatefulWidget {
  const EmpContactDetail({Key? key, required this.contact, required this.account}) : super(key: key);

  final Contact contact;
  final Account account;

  @override
  _EmpContactDetailState createState() => _EmpContactDetailState();
}

class _EmpContactDetailState extends State<EmpContactDetail> {

  String fullname = '';
  bool _readOnly = true;

  final TextEditingController _contactName = TextEditingController();
  final TextEditingController _contactEmail = TextEditingController();
  final TextEditingController _contactPhoneNumber = TextEditingController();
  final TextEditingController _contactCompanyName = TextEditingController();
  final TextEditingController _contactOwnerId = TextEditingController();
  final TextEditingController _contactGender = TextEditingController();

  late Future<Account> _futureAccount;

  @override
  void initState() {
    super.initState();
    if(_contactOwnerId.text.isEmpty){
      _getAccountFullnameById(widget.contact.contactOwnerId);
    }
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
    final _account = Provider.of<AccountProvider>(context).account;
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
                child: fullname.isNotEmpty ? ListView(
                  children: <Widget>[
                    //Id khách hàng
                    CustomReadOnlyTextField(text: '${widget.contact.contactId}', title: 'ID khách hàng'),
                    const SizedBox(height: 20.0,),

                    //Tên khách hàng
                    CustomEditableTextField(
                        text: widget.contact.fullname,
                        title: 'Tên khách hàng',
                        readonly: _readOnly,
                        textEditingController: _contactName
                    ),
                    const SizedBox(height: 20.0,),
                    
                    CustomDropdownFormField2(
                        label: 'Giới tính', 
                        hintText: Text(gendersUtilities[int.parse('${widget.contact.genderId}')]), 
                        items: gendersUtilities, 
                        onChanged: _readOnly != true ? (value){
                          if(value.toString() == gendersUtilities[0]){
                            _contactGender.text = '0';
                          }else if(value.toString() == gendersUtilities[1]){
                            _contactGender.text = '1';
                          }else if(value.toString() == gendersUtilities[2]){
                            _contactGender.text = '2';
                          }
                          print(_contactGender.text);
                        } : null
                    ),
                    const SizedBox(height: 20.0,),

                    //Email của khách hàng
                    CustomEditableTextField(
                        inputEmailOnly: true,
                        text: widget.contact.email,
                        title: 'Email của khách hàng',
                        readonly: _readOnly,
                        textEditingController: _contactEmail
                    ),
                    const SizedBox(height: 20.0,),

                    //Số điện thoại
                    CustomEditableTextField(
                        inputNumberOnly: true,
                        text: widget.contact.phoneNumber,
                        title: 'Số điện thoại',
                        readonly: _readOnly,
                        textEditingController: _contactPhoneNumber
                    ),
                    const SizedBox(height: 20.0,),

                    //Tên công ty của khách hàng
                    CustomEditableTextField(
                        text: widget.contact.companyName,
                        title: 'Tên công ty',
                        readonly: _readOnly,
                        textEditingController: _contactCompanyName
                    ),
                    const SizedBox(height: 10.0,),

                    //Khách hàng của
                    if(fullname.isNotEmpty) OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: defaultFontColor,
                          side: BorderSide(width: 2.0, color: Colors.grey.shade300),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        ),
                        onPressed: _readOnly != true ? () async {
                          final data = await Navigator.push(context, MaterialPageRoute(
                            builder: (context) => SaleEmpFilter(account: _account,),
                          ));
                          if(data != null){
                            setState(() {
                              _contactOwnerId.text = data.toString();
                            });
                            _getAccountFullnameById(int.parse(_contactOwnerId.text));
                            print('Contact owner Id: ${_contactOwnerId.text}');
                          }
                        } : null,
                        child: Text('Khách hàng của: $fullname')
                    ),
                    const SizedBox(height: 20.0,),


                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        children: <Widget>[
                          //Nút xoá
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.red,
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
                                ApiService().deleteContact(widget.contact.contactId);
                                Future.delayed(const Duration(seconds: 3), (){
                                  Navigator.pop(context);
                                });
                              },
                              child: const Text(
                                'Xoá khách hàng',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 30.0,),

                          //Nút chỉnh sửa
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
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: _readOnly == true ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    _readOnly = false;
                                    print('Chỉnh sửa');
                                  });
                                },
                                child: const Text('Chỉnh sửa', style: TextStyle(color: Colors.white),),
                              ) : TextButton(
                                onPressed: () {
                                  setState(() {
                                      Contact contact = Contact(
                                          contactId: widget.contact.contactId,
                                          fullname: _contactName.text.isEmpty ? widget.contact.fullname : _contactName.text,
                                          email: _contactEmail.text.isEmpty ? widget.contact.email : _contactEmail.text,
                                          phoneNumber: _contactPhoneNumber.text.isEmpty ? widget.contact.phoneNumber : _contactPhoneNumber.text,
                                          companyName: _contactCompanyName.text.isEmpty ? widget.contact.companyName : _contactCompanyName.text,
                                          contactOwnerId: _contactOwnerId.text.isEmpty ? widget.contact.contactOwnerId : int.parse(_contactOwnerId.text),
                                          genderId: _contactGender.text.isEmpty ? widget.contact.genderId : int.parse(_contactGender.text),
                                          leadSourceId: 0,
                                      );
                                      ApiService().updateAContact(contact);
                                      _readOnly = true;
                                      Future.delayed(const Duration(seconds: 3), (){
                                        Navigator.pop(context);
                                      });
                                    print('Lưu');
                                  });
                                },
                                child: const Text('Lưu', style: TextStyle(color: Colors.white),),
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ) : const Center(child: CircularProgressIndicator())
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
              title: Text(
                widget.contact.fullname.toString(),
                style: const TextStyle(
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

  void _getAccountFullnameById(int accountId){
    _futureAccount = ApiService().getAccountById(accountId);
    _futureAccount.then((value) {
      setState(() {
        fullname = value.fullname!;
      });
    });
  }

  // String _getContactOwnerName(int contactOwnerId){
  //   String contactOwnerName = '';
  //   for(int i = 0; i < accountIdNames.length; i++){
  //     if(contactOwnerId == int.parse(accountIdNames[i].substring(0,  accountIdNames[i].indexOf(',')))){
  //       contactOwnerName = accountIdNames[i].substring(accountIdNames[i].indexOf(',')+2, accountIdNames[i].length);
  //     }
  //   }
  //   return contactOwnerName;
  // }
}
