import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomReadOnlyTextField.dart';

class EmpDealAddNew extends StatefulWidget {
  const EmpDealAddNew({Key? key}) : super(key: key);

  @override
  _EmpDealAddNewState createState() => _EmpDealAddNewState();
}

class _EmpDealAddNewState extends State<EmpDealAddNew> {

  late final int _currentAccountDepartmentId = 0;
  late final int _currentAccountTeamId = 0;
  late String _closeDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(DateTime.now())}';

  late final TextEditingController _dealTitle = TextEditingController();
  late final TextEditingController _dealStageId = TextEditingController();
  late final TextEditingController _dealAmount = TextEditingController();
  late DateTime _dealCloseDate;
  late final TextEditingController _dealOwnerId = TextEditingController();
  late final TextEditingController _linkTrello = TextEditingController();
  late final TextEditingController _dealVatId = TextEditingController();
  late final TextEditingController _dealServiceId = TextEditingController();
  late final TextEditingController _dealTypeId = TextEditingController();
  late final TextEditingController _dealContactId = TextEditingController();


  late List<Contact> contacts = [];
  late List<String?> contactCompanyNames = [];
  late List<String?> contactIdNames = [];

  late List<Account> accounts = [];
  late List<String?> dealOwnerIdNames = [];

  late List<Department> departments = [];

  late List<Team> teams = [];


  @override
  void initState() {
    _getOverallInfo();
    super.initState();
  }


  List<String> services = [
    'Đào tạo',
    'Website Content',
    'Fanpage Content',
    'Chạy Ads',
    'Thiết kế Website',
    'Thương mại điện tử',
    'Set Up Ads'
  ];

  List<String> vats = [
    'Có',
    'Không'
  ];

  List<String> dealStages = [
    'Gửi báo giá',
    'Đang suy nghĩ',
    'Gặp trao đổi',
    'Đồng ý mua',
    'Gửi hợp đồng',
    'Xuống tiền',
    'Thất bại'
  ];

  List<String> dealTypes = [
    'Ký mới',
    'Tái ký'
  ];

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
                child: contacts.isNotEmpty && accounts.isNotEmpty && departments.isNotEmpty && teams.isNotEmpty ? ListView(
                  children: <Widget>[
                    //Tên hợp đồng
                    CustomEditableTextField(
                        text: '',
                        title: 'Tên hợp đồng',
                        readonly: false,
                        textEditingController: _dealTitle
                    ),
                    const SizedBox(height: 20.0,),

                    //Tên khách hàng
                    CustomDropdownFormField2(
                        label: 'Tên khách hàng',
                        hintText: const Text(''),
                        items: contactIdNames,
                        onChanged: (value){
                          setState(() {
                            print(value.toString());
                            _dealContactId.text = _getContactId(value.toString());
                            print(_dealContactId.text);
                          });
                        },
                    ),
                    const SizedBox(height: 20.0,),

                    //Tên công ty
                    CustomReadOnlyTextField(text: _dealContactId.text.isNotEmpty ? '${_getContactCompanyName(_dealContactId.text)}' : '', title: "Tên công ty khách hàng"),
                    const SizedBox(height: 20.0,),

                    //Tiến trình hợp đồng
                    CustomDropdownFormField2(
                        label: 'Tiến trình hợp đồng',
                        hintText: const Text(''),
                        items: dealStages,
                        onChanged: (value){
                        if(value.toString() == 'Gửi báo giá'){
                          _dealStageId.text = '0';
                        }else if(value.toString() == 'Đang suy nghĩ'){
                          _dealStageId.text = '1';
                        }else if(value.toString() == 'Gặp trao đổi'){
                          _dealStageId.text = '2';
                        }else if(value.toString() == 'Đồng ý mua'){
                          _dealStageId.text = '3';
                        }else if(value.toString() == 'Gửi hợp đồng'){
                          _dealStageId.text = '4';
                        }else if(value.toString() == 'Xuống tiền'){
                          _dealStageId.text = '5';
                        }else if(value.toString() == 'Thất bại'){
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
                        items: dealTypes,
                        onChanged: (value){
                        if(value.toString() == 'Ký mới'){
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
                      items: services,
                      onChanged: (value){
                        if(value.toString() == 'Đào tạo'){
                          _dealServiceId.text = '0';
                        }else if(value.toString() == 'Website Content'){
                          _dealServiceId.text = '1';
                        }else if(value.toString() == 'Fanpage Content'){
                          _dealServiceId.text = '2';
                        }else if(value.toString() == 'Chạy Ads'){
                          _dealServiceId.text = '3';
                        }else if(value.toString() == 'Thiết kế Website'){
                          _dealServiceId.text = '4';
                        }else if(value.toString() == 'Thương mại điện tử'){
                          _dealServiceId.text = '5';
                        }else if(value.toString() == 'Set Up Ads'){
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
                        hintText: Text(''),
                        items: vats,
                        onChanged: (value){
                        if(value.toString() == 'Có'){
                          _dealVatId.text = '0';
                        }else if(value.toString() == 'Không'){
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
                            _dealCloseDate = date;
                            _closeDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(_dealCloseDate)}';
                            print(_dealCloseDate);
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
                    CustomDropdownFormField2(
                        label: 'Chủ hợp đồng',
                        hintText: const Text(''),
                        items: dealOwnerIdNames,
                        onChanged: (value){
                          setState(() {
                            _dealOwnerId.text = _getDealOwnerId(value.toString());
                            print(_dealOwnerId.text);
                          });
                      },
                    ),
                    const SizedBox(height: 20.0,),

                    //Phòng ban
                    // const CustomReadOnlyTextField(text: '', title: 'Phòng'),
                    // const SizedBox(height: 20.0,),

                    //Nhóm
                    // const CustomReadOnlyTextField(text: '', title: 'Nhóm'),
                    // const SizedBox(height: 20.0,),

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
                                amount: int.parse(_dealAmount.text),
                                closedDate: _dealCloseDate.toString().isEmpty ? DateTime.now() : _dealCloseDate,
                                dealOwner: int.parse(_dealOwnerId.text),
                                linkTrello: _linkTrello.text,
                                vatid: int.parse(_dealVatId.text),
                                serviceId: int.parse(_dealServiceId.text),
                                dealTypeId: int.parse(_dealTypeId.text),
                                contactId: int.parse(_dealContactId.text)
                            );
                            ApiService().createNewDeal(deal);
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
                ) : const Center(child: CircularProgressIndicator()),
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

  void _getOverallInfo(){
    ApiService().getAllSalesEmployeeAccount().then((value){
      setState(() {
        if(accounts.isNotEmpty){
          accounts.clear();
        }
        accounts.addAll(value);
        _getdealOwnerIdNames();
      });
    });

    ApiService().getAllContacts().then((value) {
      setState(() {
        if(contacts.isNotEmpty){
          contacts.clear();
        }
        contacts.addAll(value);
        _getContactNames();
      });
    });

    ApiService().getAllDepartment().then((value) {
      setState(() {
        if(departments.isNotEmpty){
          departments.clear();
        }
        departments.addAll(value);
        _getDepartmentName();
      });
    });

    ApiService().getAllTeam().then((value) {
      setState(() {
        if(teams.isNotEmpty){
          teams.clear();
        }
        teams.addAll(value);
        _getTeamName();
      });
    });
  }

  //Deal
  void _getdealOwnerIdNames(){
    if(dealOwnerIdNames.isNotEmpty){
      dealOwnerIdNames.clear();
    }
    for(int i = 0; i < accounts.length; i++){
      String idAndName = ('${accounts[i].accountId}_${accounts[i].fullname}');
      String split = '${idAndName.split('_')}';
      dealOwnerIdNames.add(split.substring(1, split.length-1));
      print(dealOwnerIdNames);
    }
  }

  String _getDealOwnerId(String string){
      String id = string.substring(0, string.indexOf(','));
      return id;
  }

  //Department
  void _getDepartmentName(){
    for (int i = 0; i < departments.length; i++) {
      if (_currentAccountDepartmentId == departments[i].departmentId) {
        departments[i].name;
      }
    }
  }

  //Team
  String? _getTeamName(){
    for (int i = 0; i < teams.length; i++) {
      if (_currentAccountTeamId == teams[i].teamId) {
        return teams[i].name;
      }
    }
  }

  //Contact
  String _getContactId(String string){
      String id = string.substring(0, string.indexOf(','));
      return id;
  }

  void _getContactNames(){
    if(contactIdNames.isNotEmpty){
      contactIdNames.clear();
    }
    for(int i = 0; i < contacts.length; i++){
      String idAndName = ('${contacts[i].contactId}_${contacts[i].fullname}');
      String split = '${idAndName.split('_')}';
      contactIdNames.add(split.substring(1, split.length-1));
      print(contactIdNames);
    }
  }

  String? _getContactCompanyName(String contactId){
    int id = int.parse(contactId);
    for(int i = 0; i < contacts.length; i++){
      if( id == contacts[i].contactId){
        return contacts[i].companyName;
      }
    }
  }

}


