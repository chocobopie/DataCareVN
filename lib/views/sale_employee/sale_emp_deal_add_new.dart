import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_contact_filter.dart';
import 'package:login_sample/views/sale_employee/sale_emp_filter.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomReadOnlyTextField.dart';
import 'package:provider/provider.dart';

class SaleEmpDealAddNew extends StatefulWidget {
  const SaleEmpDealAddNew({Key? key}) : super(key: key);

  @override
  _SaleEmpDealAddNewState createState() => _SaleEmpDealAddNewState();
}

class _SaleEmpDealAddNewState extends State<SaleEmpDealAddNew> {

  late String _closeDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(DateTime.now())}';

  late final TextEditingController _dealTitle = TextEditingController();
  late final TextEditingController _dealStageId = TextEditingController();
  late final TextEditingController _dealAmount = TextEditingController();
  late final TextEditingController _dealClosedDate = TextEditingController();
  late final TextEditingController _dealOwnerId = TextEditingController();
  late final TextEditingController _linkTrello = TextEditingController();
  late final TextEditingController _dealVatId = TextEditingController();
  late final TextEditingController _dealServiceId = TextEditingController();
  late final TextEditingController _dealTypeId = TextEditingController();
  late final TextEditingController _dealContactId = TextEditingController();

  String _contactFullname = '', _contactCompanyName = '', _accountFullname = '';
  late Account currentAccount;
  late Account filterAccount = Account();
  late Contact filterContact;


  @override
  void initState() {
    super.initState();
    currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
  }

  @override
  void dispose() {
    super.dispose();
     _dealTitle.dispose();
     _dealStageId.dispose();
     _dealAmount.dispose();
     _dealClosedDate.dispose();
     _dealOwnerId.dispose();
     _linkTrello.dispose();
     _dealVatId.dispose();
     _dealServiceId.dispose();
     _dealTypeId.dispose();
     _dealContactId.dispose();
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
                    //Tiêu đề hợp đồng
                    CustomEditableTextField(
                        text: '',
                        title: 'Tiêu đề hợp đồng',
                        readonly: false,
                        textEditingController: _dealTitle
                    ),
                    const SizedBox(height: 20.0,),

                    //Tên khách hàng
                    CustomEditableTextField(
                        borderColor: Colors.red,
                        text: _contactFullname,
                        title: 'Tên khách hàng',
                        readonly: true,
                        textEditingController: _dealContactId,
                        onTap: () async {
                          final data = await Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const SaleEmpContactFilter(),
                          ));
                          if(data != null){
                            setState(() {
                              filterContact = data;
                              _contactFullname = filterContact.fullname;
                              _contactCompanyName = filterContact.companyName;
                              _dealContactId.text = '${filterContact.contactId}';
                            });
                            print('Contact Id: ${_dealContactId.text}');
                          }
                        },
                    ),
                    const SizedBox(height: 20.0,),

                    //Tên công ty
                    CustomReadOnlyTextField(
                        text: _contactCompanyName,
                        title: 'Tên công ty'
                    ),
                    const SizedBox(height: 20.0,),

                    //Tiến trình hợp đồng
                    CustomDropdownFormField2(
                        label: 'Tiến trình hợp đồng',
                        hintText: const Text(''),
                        items: dealStagesNameUtilities,
                        onChanged: (value){
                        if(value.toString() == dealStagesNameUtilities[0].toString()){
                          _dealStageId.text = '0';
                        }else if(value.toString() == dealStagesNameUtilities[1].toString()){
                          _dealStageId.text = '1';
                        }else if(value.toString() == dealStagesNameUtilities[2].toString()){
                          _dealStageId.text = '2';
                        }else if(value.toString() == dealStagesNameUtilities[3].toString()){
                          _dealStageId.text = '3';
                        }else if(value.toString() == dealStagesNameUtilities[4].toString()){
                          _dealStageId.text = '4';
                        }else if(value.toString() == dealStagesNameUtilities[5].toString()){
                          _dealStageId.text = '5';
                        }else if(value.toString() == dealStagesNameUtilities[6].toString()){
                          _dealStageId.text = '6';
                        }
                        print(_dealStageId.text);
                      },
                    ),
                    const SizedBox(height: 20.0,),

                    //Loại hợp đồng
                    CustomDropdownFormField2(
                        label: 'Loại hợp đồng',
                        hintText: const Text(''),
                        items: dealTypesNameUtilities,
                        onChanged: (value){
                        if(value.toString() == dealTypesNameUtilities[0].toString()){
                          _dealTypeId.text = '0';
                        }else{
                          _dealTypeId.text = '1';
                        }
                        print(_dealTypeId.text);
                      },
                    ),
                    const SizedBox(height: 20.0,),

                    //Loại dịch vụ
                    CustomDropdownFormField2(
                      label: 'Loại dịch vụ',
                      hintText: const Text(''),
                      items: dealServicesNameUtilities,
                      onChanged: (value){
                        if(value.toString() == dealServicesNameUtilities[0].toString()){
                          _dealServiceId.text = '0';
                        }else if(value.toString() == dealServicesNameUtilities[1].toString()){
                          _dealServiceId.text = '1';
                        }else if(value.toString() == dealServicesNameUtilities[2].toString()){
                          _dealServiceId.text = '2';
                        }else if(value.toString() == dealServicesNameUtilities[3].toString()){
                          _dealServiceId.text = '3';
                        }else if(value.toString() == dealServicesNameUtilities[4].toString()){
                          _dealServiceId.text = '4';
                        }else if(value.toString() == dealServicesNameUtilities[5].toString()){
                          _dealServiceId.text = '5';
                        }else if(value.toString() == dealServicesNameUtilities[6].toString()){
                          _dealServiceId.text = '6';
                        }
                        print(_dealServiceId.text);
                      },
                    ),
                    const SizedBox(height: 20.0,),

                    //Tổng giá trị
                    CustomEditableTextField(
                        inputNumberOnly: true,
                        text: '',
                        title: 'Tổng giá trị (VNĐ)',
                        readonly: false,
                        textEditingController: _dealAmount
                    ),
                    const SizedBox(height: 20.0,),

                    //Vat
                    CustomDropdownFormField2(
                        label: 'VAT',
                        hintText: const Text(''),
                        items: dealVatsNameUtilities,
                        onChanged: (value){
                        if(value.toString() == dealVatsNameUtilities[0].toString()){
                          _dealVatId.text = '0';
                        }else if(value.toString() == dealVatsNameUtilities[1].toString()){
                          _dealVatId.text = '1';
                        }
                        print(_dealVatId.text);
                      },
                    ),
                    const SizedBox(height: 20.0,),

                    //Ngày đóng
                    SizedBox(
                      child: TextField(
                        controller: TextEditingController(),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final date = await DatePicker.showDatePicker(
                            context,
                            locale : LocaleType.vi,
                            minTime: DateTime.now(),
                            currentTime: DateTime.now(),
                            maxTime: DateTime.now().add(const Duration(days: 36500)),
                          );
                          if(date != null){
                            _dealClosedDate.text = date.toString();
                            _closeDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(date)}';
                          }
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Ngày đóng',
                          hintText: _closeDate,
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 107, 106, 144),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      width: 150.0,
                    ),
                    const SizedBox(height: 20.0,),

                    //Chủ hợp đồng
                    CustomEditableTextField(
                        borderColor: Colors.red,
                        text: _accountFullname,
                        title: 'Chủ hợp đồng',
                        readonly: true,
                        textEditingController: _dealOwnerId,
                        onTap: () async {
                          final data = await Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const SaleEmpFilter(),
                          ));
                          if(data != null){
                            setState(() {
                              filterAccount = data;
                              _dealOwnerId.text = '${filterAccount.accountId!}';
                              _accountFullname = filterAccount.fullname!;
                            });
                          }
                        },
                    ),
                    const SizedBox(height: 20.0,),

                    //Phòng ban
                    if(filterAccount.departmentId != null) CustomReadOnlyTextField(text: getDepartmentName(filterAccount.departmentId!), title: 'Phòng'),
                    if(filterAccount.departmentId != null) const SizedBox(height: 20.0,),

                    //Nhóm
                    if(filterAccount.teamId != null) CustomReadOnlyTextField(text: getTeamName(filterAccount.teamId!), title: 'Nhóm'),
                    if(filterAccount.teamId != null) const SizedBox(height: 20.0,),

                    //Nút thêm mới
                    const SizedBox(height: 20.0,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
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
                        onPressed: () {
                          if(_dealTitle.text.isNotEmpty && _dealStageId.text.isNotEmpty && _dealAmount.text.isNotEmpty &&  _dealOwnerId.text.isNotEmpty
                          && _dealVatId.text.isNotEmpty && _dealServiceId.text.isNotEmpty && _dealTypeId.text.isNotEmpty && _dealContactId.text.isNotEmpty ){
                            Deal deal = Deal(
                                dealId: 0,
                                title: _dealTitle.text,
                                dealStageId: int.parse(_dealStageId.text),
                                amount: _dealAmount.text.isEmpty ? 0 : int.parse(_dealAmount.text),
                                closedDate: _dealClosedDate.text.isEmpty ? DateTime.now() : DateTime.parse(_dealClosedDate.text),
                                dealOwnerId: int.parse(_dealOwnerId.text),
                                linkTrello: _linkTrello.text.isEmpty ? '' : _linkTrello.text,
                                vatId: int.parse(_dealVatId.text),
                                serviceId: int.parse(_dealServiceId.text),
                                dealTypeId: int.parse(_dealTypeId.text),
                                contactId: int.parse(_dealContactId.text),
                            );
                            ApiService().createNewDeal(deal);
                            Future.delayed(const Duration(seconds: 2), (){
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
                )
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
                'Thêm hợp đồng mới',
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

  String getDepartmentName(int departmentId){
    String name = '';
    for(int i = 0; i < departments.length; i++){
      if(departmentId == departments[i].departmentId){
        name = departments[i].name;
      }
    }
    return name;
  }

  String getTeamName(int teamId){
    String name = '';
    for(int i = 0; i < teams.length; i++){
      if(teamId == teams[i].teamId){
        name = teams[i].name;
      }
    }
    return name;
  }
}


