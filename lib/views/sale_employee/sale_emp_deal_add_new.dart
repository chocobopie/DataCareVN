import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/deal_view_model.dart';
import 'package:login_sample/models/providers/account_provider.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  late String _closeDate = '';

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
  late Account _currentAccount;
  late Account _filterAccount = Account();
  late Contact _filterContact;


  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _accountFullname = _currentAccount.fullname!;
    _filterAccount = _currentAccount;
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
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: <Widget>[
                      //Tiêu đề hợp đồng
                      CustomEditableTextFormField(
                          borderColor: mainBgColor,
                          text: _dealTitle.text,
                          title: 'Tiêu đề hợp đồng',
                          readonly: false,
                          textEditingController: _dealTitle
                      ),
                      const SizedBox(height: 20.0,),

                      //Tên khách hàng
                      CustomEditableTextFormField(
                          borderColor: mainBgColor,
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
                                _filterContact = data;
                                _contactFullname = _filterContact.fullname;
                                _contactCompanyName = _filterContact.companyName;
                                _dealContactId.text = '${_filterContact.contactId}';
                              });
                            }
                          },
                      ),
                      const SizedBox(height: 20.0,),

                      //Tên công ty
                      if(_contactCompanyName.isNotEmpty)
                      CustomReadOnlyTextField(
                          text: _contactCompanyName,
                          title: 'Tên công ty'
                      ),
                      if(_contactCompanyName.isNotEmpty)
                      const SizedBox(height: 20.0,),

                      //Tiến trình hợp đồng
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdownFormField2(
                                value: _dealStageId.text.isEmpty ? null : dealStagesNames[int.parse(_dealStageId.text)],
                                borderColor: mainBgColor,
                                label: 'Tiến trình hợp đồng',
                                hintText: const Text(''),
                                items: dealStagesNames,
                                onChanged: (value){
                                if(value.toString() == dealStagesNames[0].toString()){
                                  _dealStageId.text = '0';
                                }else if(value.toString() == dealStagesNames[1].toString()){
                                  _dealStageId.text = '1';
                                }else if(value.toString() == dealStagesNames[2].toString()){
                                  _dealStageId.text = '2';
                                }else if(value.toString() == dealStagesNames[3].toString()){
                                  _dealStageId.text = '3';
                                }else if(value.toString() == dealStagesNames[4].toString()){
                                  _dealStageId.text = '4';
                                }else if(value.toString() == dealStagesNames[5].toString()){
                                  _dealStageId.text = '5';
                                }else if(value.toString() == dealStagesNames[6].toString()){
                                  _dealStageId.text = '6';
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 5.0,),
                          Expanded(
                            child: CustomDropdownFormField2(
                              value: _dealTypeId.text.isEmpty ? null : dealTypesNames[int.parse(_dealTypeId.text)],
                              borderColor: mainBgColor,
                              label: 'Loại hợp đồng',
                              hintText: const Text(''),
                              items: dealTypesNames,
                              onChanged: (value){
                                if(value.toString() == dealTypesNames[0].toString()){
                                  _dealTypeId.text = '0';
                                }else{
                                  _dealTypeId.text = '1';
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),

                      //Tổng giá trị
                      CustomEditableTextFormField(
                          inputMoney: true,
                          isNull: true,
                          borderColor: mainBgColor,
                          inputNumberOnly: true,
                          text: _dealAmount.text.isNotEmpty ? formatNumber(_dealAmount.text.replaceAll('.', '')) : _dealAmount.text,
                          title: 'Số tiền (VNĐ)',
                          readonly: false,
                          textEditingController: _dealAmount
                      ),
                      const SizedBox(height: 20.0,),

                      //Loại dịch vụ
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdownFormField2(
                              value: _dealServiceId.text.isEmpty ? null : dealServicesNames[int.parse(_dealServiceId.text)],
                              borderColor: mainBgColor,
                              label: 'Loại dịch vụ',
                              hintText: const Text(''),
                              items: dealServicesNames,
                              onChanged: (value){
                                if(value.toString() == dealServicesNames[0].toString()){
                                  _dealServiceId.text = '0';
                                }else if(value.toString() == dealServicesNames[1].toString()){
                                  _dealServiceId.text = '1';
                                }else if(value.toString() == dealServicesNames[2].toString()){
                                  _dealServiceId.text = '2';
                                }else if(value.toString() == dealServicesNames[3].toString()){
                                  _dealServiceId.text = '3';
                                }else if(value.toString() == dealServicesNames[4].toString()){
                                  _dealServiceId.text = '4';
                                }else if(value.toString() == dealServicesNames[5].toString()){
                                  _dealServiceId.text = '5';
                                }else if(value.toString() == dealServicesNames[6].toString()){
                                  _dealServiceId.text = '6';
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 5.0,),
                          Expanded(
                            child: CustomDropdownFormField2(
                              value: _dealVatId.text.isEmpty ? null : dealVatsNames[int.parse(_dealVatId.text)],
                              borderColor: mainBgColor,
                              label: 'VAT',
                              hintText: const Text(''),
                              items: dealVatsNames,
                              onChanged: (value){
                                if(value.toString() == dealVatsNames[0].toString()){
                                  _dealVatId.text = '0';
                                }else if(value.toString() == dealVatsNames[1].toString()){
                                  _dealVatId.text = '1';
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),

                      //Ngày đóng
                      CustomEditableTextFormField(
                          borderColor: mainBgColor,
                          text: _closeDate,
                          title: 'Ngày chốt hợp đồng',
                          readonly: false,
                          onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final date = await DatePicker.showDatePicker(
                            context,
                            locale : LocaleType.vi,
                            minTime: DateTime.now().add(const Duration(days: 1)),
                            currentTime: DateTime.now(),
                            maxTime: DateTime.now().add(const Duration(days: 36500)),
                          );
                          if(date != null){
                            _dealClosedDate.text = date.toString();
                            _closeDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(date)}';
                          }
                        },
                      ),
                      const SizedBox(height: 20.0,),

                      //Người quản lý hợp đồng
                      CustomEditableTextFormField(
                          borderColor: _currentAccount.roleId != 5 ? mainBgColor : null,
                          text: _accountFullname,
                          title: 'Người quản lý hợp đồng',
                          readonly: true,
                          onTap: _currentAccount.roleId != 5 ? () async {
                            final data = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SaleEmpFilter(salesForDeal: true),
                            ));
                            if(data != null){
                              setState(() {
                                _filterAccount = data;
                                _accountFullname = _filterAccount.fullname!;
                              });
                            }
                          } : null,
                      ),
                      const SizedBox(height: 20.0,),

                      //Phòng ban
                      if(_filterAccount.departmentId != null) CustomReadOnlyTextField(text: getDepartmentName(_filterAccount.departmentId!), title: 'Phòng'),
                      if(_filterAccount.departmentId != null) const SizedBox(height: 20.0,),

                      //Nhóm
                      if(_filterAccount.teamId != null) CustomReadOnlyTextField(text: getTeamName(_filterAccount.teamId!), title: 'Nhóm'),

                      //Nút thêm mới
                      const SizedBox(height: 20.0,),
                      Container(
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
                            bool data = await _createNewDeal();
                            if(data == true){
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Thêm hợp đồng mới thành công')),
                              );
                              Future.delayed(const Duration(seconds: 1), (){
                                Navigator.pop(context);
                              });
                            }else{
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Thêm hợp đồng mới thất bại')),
                              );
                            }
                          },
                          child: const Text(
                            'Thêm hợp đồng mới',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
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

  Future<bool> _createNewDeal() async {
    Deal deal = Deal(
      dealId: 0,
      title: _dealTitle.text,
      dealStageId: int.parse(_dealStageId.text),
      amount: _dealAmount.text.isEmpty ? 0 : num.parse(_dealAmount.text),
      closedDate: _dealClosedDate.text.isEmpty ? DateTime.now() : DateTime.parse(_dealClosedDate.text),
      dealOwnerId: _currentAccount.roleId != 5 ? _filterAccount.accountId! : _currentAccount.accountId!,
      linkTrello: _linkTrello.text.isEmpty ? '' : _linkTrello.text,
      vatId: int.parse(_dealVatId.text),
      serviceId: int.parse(_dealServiceId.text),
      dealTypeId: int.parse(_dealTypeId.text),
      contactId: _filterContact.contactId,
    );

    bool result = await DealViewModel().createNewDeal(deal);

    return result;
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


