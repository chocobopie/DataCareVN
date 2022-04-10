import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/view_models/account_view_model.dart';
import 'package:login_sample/view_models/contact_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_filter.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomReadOnlyTextField.dart';
import 'package:provider/provider.dart';

class SaleEmpContactDetail extends StatefulWidget {
  const SaleEmpContactDetail({Key? key, required this.contact, required this.account}) : super(key: key);

  final Contact contact;
  final Account account;

  @override
  _SaleEmpContactDetailState createState() => _SaleEmpContactDetailState();
}

class _SaleEmpContactDetailState extends State<SaleEmpContactDetail> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _fullname = '';
  bool _readOnly = true;

  final TextEditingController _contactName = TextEditingController();
  final TextEditingController _contactEmail = TextEditingController();
  final TextEditingController _contactPhoneNumber = TextEditingController();
  final TextEditingController _contactCompanyName = TextEditingController();
  final TextEditingController _contactOwnerId = TextEditingController();
  final TextEditingController _contactGender = TextEditingController();
  final TextEditingController _contactLeadSourceId = TextEditingController();
  
  late Account _currentAccount = Account();

  @override
  void initState() {
    super.initState();
    if(_contactOwnerId.text.isEmpty){
      _getAccountFullnameById(accountId: widget.contact.contactOwnerId);
    }
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    print(widget.contact.createdDate);
  }

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
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _fullname.isNotEmpty ? ListView(
                    children: <Widget>[
                      //Id khách hàng
                      CustomReadOnlyTextField(text: '${widget.contact.contactId}', title: 'Mã số khách hàng'),
                      const SizedBox(height: 20.0,),

                      //Tên khách hàng
                      CustomEditableTextFormField(
                          borderColor: _readOnly != true ? mainBgColor : null,
                          text: widget.contact.fullname,
                          title: 'Tên khách hàng',
                          readonly: _readOnly,
                          textEditingController: _contactName
                      ),
                      const SizedBox(height: 20.0,),

                      //Email của khách hàng
                      CustomEditableTextFormField(
                          borderColor: _readOnly != true ? mainBgColor : null,
                          inputEmailOnly: true,
                          text: widget.contact.email,
                          title: 'Email của khách hàng',
                          readonly: _readOnly,
                          textEditingController: _contactEmail
                      ),
                      const SizedBox(height: 20.0,),

                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CustomDropdownFormField2(
                                value: _contactGender.text.isEmpty ? gendersUtilities[widget.contact.genderId] : gendersUtilities[int.parse(_contactGender.text)],
                                borderColor: _readOnly != true ? mainBgColor : null,
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
                          ),
                          const SizedBox(width: 5.0,),
                          Expanded(
                            child: CustomReadOnlyTextField(
                                text: 'Ngày ${DateFormat('dd-MM-yyyy').format(widget.contact.createdDate)}',
                                title: 'Ngày tạo'
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),

                      //Số điện thoại
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CustomEditableTextFormField(
                                borderColor: _readOnly != true ? mainBgColor : null,
                                inputNumberOnly: true,
                                text: widget.contact.phoneNumber,
                                title: 'Số điện thoại',
                                readonly: _readOnly,
                                textEditingController: _contactPhoneNumber
                            ),
                          ),
                          const SizedBox(width: 5.0,),
                          Expanded(
                            child: CustomDropdownFormField2(
                                value: _contactLeadSourceId.text.isEmpty ? leadSourceNameUtilities[widget.contact.leadSourceId] : leadSourceNameUtilities[int.parse(_contactLeadSourceId.text)],
                                borderColor: _readOnly != true ? mainBgColor : null,
                                label: 'Nguồn',
                                hintText: Text(leadSourceNameUtilities[int.parse('${widget.contact.leadSourceId}')]),
                                items: leadSourceNameUtilities,
                                onChanged: _readOnly != true ? (value){
                                  if(value.toString() == leadSourceNameUtilities[0]){
                                    _contactLeadSourceId.text = '0';
                                  }else if(value.toString() == leadSourceNameUtilities[1]){
                                    _contactLeadSourceId.text = '1';
                                  }else if(value.toString() == leadSourceNameUtilities[2]){
                                    _contactLeadSourceId.text = '2';
                                  }
                                  print(_contactLeadSourceId.text);
                                } : null
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),

                      //Tên công ty của khách hàng
                      CustomEditableTextFormField(
                          borderColor: _readOnly != true ? mainBgColor : null,
                          text: widget.contact.companyName,
                          title: 'Tên công ty',
                          readonly: _readOnly,
                          textEditingController: _contactCompanyName
                      ),
                      const SizedBox(height: 20.0,),

                      //Khách hàng của
                      // if(fullname.isNotEmpty) OutlinedButton(
                      //     style: OutlinedButton.styleFrom(
                      //       primary: defaultFontColor,
                      //       side: BorderSide(width: 2.0, color: Colors.grey.shade300),
                      //       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      //     ),
                      //     onPressed: _readOnly != true ? () async {
                      //       final data = await Navigator.push(context, MaterialPageRoute(
                      //         builder: (context) => const SaleEmpFilter(),
                      //       ));
                      //       late Account filterAccount;
                      //       if(data != null){
                      //         setState(() {
                      //           filterAccount = data;
                      //           _contactOwnerId.text = filterAccount.accountId!.toString();
                      //           fullname = filterAccount.fullname!;
                      //         });
                      //         print('Contact owner Id: ${_contactOwnerId.text}');
                      //       }
                      //     } : null,
                      //     child: Text('Khách hàng của: $fullname')
                      // ),
                      if(_fullname.isNotEmpty) CustomEditableTextFormField(
                        borderColor: _currentAccount.roleId != 5 ? _readOnly != true ? mainBgColor : null : null,
                        text: _fullname,
                        title: 'Nhân viên tạo',
                        readonly: true,
                        textEditingController: _contactOwnerId,
                        onTap: _currentAccount.roleId != 5 ? _readOnly != true ? () async {
                          final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => const SaleEmpFilter(salesForContact: true),));
                          late Account filterAccount;
                          if (data != null) {
                            setState(() {
                              filterAccount = data;
                              _contactOwnerId.text = filterAccount.accountId!.toString();
                              _fullname = filterAccount.fullname!;
                            });
                          }
                        } : null : null,
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
                                onPressed: () async {

                                  showLoaderDialog(context);
                                  bool data = await _deleteContact(widget.contact.contactId);
                                  if(data == true){
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Xóa thông tin khách hàng thành công')),
                                    );
                                    Future.delayed(const Duration(seconds: 1), (){
                                      Navigator.pop(context);
                                    });
                                  }else{
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Xóa thông tin khách hàng thất bại')),
                                    );
                                  }
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
                                  color: mainBgColor,
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
                                  onPressed: () async {
                                    if(!_formKey.currentState!.validate()){
                                      return;
                                    }
                                    showLoaderDialog(context);
                                    bool data = await _updateAContact();
                                    if(data == true){
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Chỉnh sửa thông tin khách hàng thành công')),
                                      );
                                      Future.delayed(const Duration(seconds: 1), (){
                                        Navigator.pop(context);
                                      });
                                    }else{
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Chỉnh sửa thông tin khách hàng thất bại')),
                                      );
                                    }
                                  },
                                  child: const Text('Lưu', style: TextStyle(color: Colors.white),),
                                )
                            ),
                          ],
                        ),
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

  void _getAccountFullnameById({required accountId}) async {
    Account account = await AccountViewModel().getAccountFullnameById(accountId: accountId);
    setState(() {
      _fullname = account.fullname!;
    });
  }

  Future<bool> _deleteContact(int contactId) async {
    bool result = await ContactViewModel().deleteContact(contactId);
     return result;
  }

  Future<bool> _updateAContact() async {

    Contact contact = Contact(
      contactId: widget.contact.contactId,
      fullname: _contactName.text.isEmpty ? widget.contact.fullname : _contactName.text,
      email: _contactEmail.text.isEmpty ? widget.contact.email : _contactEmail.text,
      phoneNumber: _contactPhoneNumber.text.isEmpty ? widget.contact.phoneNumber : _contactPhoneNumber.text,
      companyName: _contactCompanyName.text.isEmpty ? widget.contact.companyName : _contactCompanyName.text,
      contactOwnerId: _contactOwnerId.text.isEmpty ? widget.contact.contactOwnerId : int.parse(_contactOwnerId.text),
      genderId: _contactGender.text.isEmpty ? widget.contact.genderId : int.parse(_contactGender.text),
      leadSourceId: _contactLeadSourceId.text.isEmpty ? widget.contact.leadSourceId : int.parse(_contactLeadSourceId.text),
      createdDate: widget.contact.createdDate,
    );

    bool result = await ContactViewModel().updateAContact(contact);

    return result;
  }
}
