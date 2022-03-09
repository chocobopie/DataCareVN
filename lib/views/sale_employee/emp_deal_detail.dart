import 'package:dropdown_button2/dropdown_button2.dart';
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

class EmpDealDetail extends StatefulWidget {
  const EmpDealDetail({Key? key, required this.deal}) : super(key: key);

  final Deal deal;

  @override
  _EmpDealDetailState createState() => _EmpDealDetailState();
}

class _EmpDealDetailState extends State<EmpDealDetail> {

  late int vat = widget.deal.vatId;
  late DateTime closeDate = widget.deal.closedDate;
  String _closeDate = '';
  String? selectedValue;

  bool _readOnly = true;
  late int? _currentAccountDepartmentId = 0;
  late int? _currentAccountTeamId = 0;

  final TextEditingController _dealTitle = TextEditingController();
  final TextEditingController _dealStage = TextEditingController();
  final TextEditingController _dealType = TextEditingController();
  final TextEditingController _dealAmount = TextEditingController();
  final TextEditingController _dealService = TextEditingController();
  final TextEditingController _dealOwner = TextEditingController();
  final TextEditingController _dealLinkTrello = TextEditingController();
  final TextEditingController _dealClosedDate = TextEditingController();

  late List<Account> accounts = [];
  late List<Department> departments = [];
  late List<Team> teams = [];
  late List<Contact> contacts = [];
  late Future<List<Account>> futureAccounts;
  late Future<List<Department>> futureDepartments;
  late Future<List<Team>> futureTeams;
  late Future<List<Contact>> futureContacts;
  late List<String?> dealOwnerIdNames = [];


  @override
  void initState() {
    _getOverallInfo();
    super.initState();
  }

  @override
  void dispose() {
    _dealTitle.dispose();
    _dealStage.dispose();
    _dealType.dispose();
    _dealAmount.dispose();
    _dealService.dispose();
    _dealOwner.dispose();
    _dealLinkTrello.dispose();
    _dealClosedDate.dispose();
    super.dispose();
  }

  List<String> services = [
    'Đào tạo',
    'Website Content',
    'Facebook Content',
    'Chạy Ads',
    'Thiết kế Website',
    'TMDT',
    'Setup Ads'
  ];

  List<String> vats = ['Có', 'Không'];

  List<String> dealStages = [
    'Gửi báo giá',
    'Đang suy nghĩ',
    'Gặp trao đổi',
    'Đồng ý mua',
    'Gửi hợp đồng',
    'Xuống tiền',
    'Thất bại'
  ];

  List<String> dealTypes = ['Ký mới', 'Tái ký'];

  @override
  Widget build(BuildContext context) {
    double leftRight = MediaQuery.of(context).size.width * 0.004;
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
                  child: contacts.isNotEmpty && accounts.isNotEmpty && departments.isNotEmpty && teams.isNotEmpty ? ListView(
                    children: <Widget>[
                      CustomReadOnlyTextField(
                          text: '${widget.deal.dealId}', title: 'ID hợp đồng'),
                      const SizedBox(
                        height: 20.0,
                      ),

                      //Tên hợp đồng
                      CustomEditableTextField(
                        text: widget.deal.title,
                        title: 'Tên hợp đồng',
                        readonly: _readOnly,
                        textEditingController: _dealTitle,
                      ),
                      const SizedBox(height: 20.0,),

                      //Tên khách hàng
                      CustomReadOnlyTextField(text: '${_getContactName(widget.deal.contactId)}', title: 'Tên khách hàng'),
                      const SizedBox(height: 20.0,),

                      //Tên công ty khách hàng
                      CustomReadOnlyTextField(text: '${_getCompanyName(widget.deal.contactId)}', title: 'Tên công ty khách hàng'),
                      const SizedBox(height: 20.0,),

                      //Tiến trình hợp đồng
                      CustomDropdownFormField2(
                          label: 'Tiến trình hợp đồng',
                          hintText: Text(dealStages[widget.deal.dealStageId].toString(), style: const TextStyle(fontSize: 14),),
                          items: dealStages,
                          onChanged: widget.deal.dealStageId != 5 ? _readOnly != true ? (value){
                            if(value.toString() == dealStages[0].toString()){
                              _dealStage.text = '0';
                            }else if(value.toString() == dealStages[1].toString()){
                              _dealStage.text = '1';
                            }else if(value.toString() == dealStages[2].toString()){
                              _dealStage.text = '2';
                            }else if(value.toString() == dealStages[3].toString()){
                              _dealStage.text = '3';
                            }else if(value.toString() == dealStages[4].toString()){
                              _dealStage.text = '4';
                            }else if(value.toString() == dealStages[5].toString()){
                              _dealStage.text = '5';
                            }else if(value.toString() == dealStages[6].toString()){
                              _dealStage.text = '6';
                            }
                          print(_dealStage.text);
                        } : null : null
                      ),
                      const SizedBox(height: 20.0,),

                      //Loại hợp đồng
                      CustomDropdownFormField2(
                          label: 'Loại hợp đồng',
                          hintText: widget.deal.dealStageId == 0
                              ? Text(
                            dealTypes[0].toString(),
                            style: const TextStyle(fontSize: 14),
                          )
                              : Text(
                            dealTypes[1].toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                          items: dealTypes,
                          onChanged: _readOnly != true ? (value){
                            if(value.toString() == dealTypes[0].toString()){
                              _dealType.text = '0';
                            }else{
                              _dealType.text = '1';
                            }
                          print(_dealType.text);
                        } : null
                      ),
                      const SizedBox(height: 20.0,),

                      //Tổng giá trị
                      CustomEditableTextField(
                          inputNumberOnly: true,
                          text: '${widget.deal.amount}',
                          title: 'Tổng giá trị (VNĐ)',
                          readonly: _readOnly,
                          textEditingController: _dealAmount
                      ),
                      const SizedBox(height: 20.0,),

                      //Vat
                      Padding(
                        padding:
                        EdgeInsets.only(left: leftRight, right: leftRight),
                        child: DropdownButtonFormField2(
                          decoration: InputDecoration(
                            contentPadding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
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
                            labelText: 'VAT',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 107, 106, 144),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          isExpanded: true,
                          hint: widget.deal.vatId == 0
                              ? const Text(
                            'Có',
                            style: TextStyle(fontSize: 14),
                          )
                              : const Text(
                            'Không',
                            style: TextStyle(fontSize: 14),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                          buttonHeight: 50,
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          items: vats
                              .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Hãy cập nhật VAT';
                            }
                          },
                          onChanged: _readOnly != true ? (value) {
                            if (value.toString().contains('Có')) {
                              vat = 0;
                            } else {
                              vat = 1;
                            }
                            print(vat.toString());
                          } : null,
                          onSaved: (value) {
                            selectedValue = value.toString();
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0,),

                      //Ngày đóng
                      SizedBox(
                        child: TextField(
                          readOnly: _readOnly,
                          onTap: _readOnly != true ? () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final date = await DatePicker.showDatePicker(
                              context,
                              locale: LocaleType.vi,
                              minTime: DateTime.now(),
                              currentTime: DateTime.now(),
                              maxTime:
                              DateTime.now().add(const Duration(days: 36500)),
                            );
                            if (date != null) {
                              setState(() {
                                closeDate = date;
                                _closeDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(closeDate)}';
                                print(date);
                              });
                            }
                          } : null,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.only(left: 20.0),
                            labelText: 'Ngày đóng',
                            hintText: _closeDate.isNotEmpty
                                ? _closeDate
                                : 'Ngày ${DateFormat('dd-MM-yyyy').format(widget.deal.closedDate)}',
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

                      //Loại dịch vụ
                      CustomDropdownFormField2(
                          label: 'Loại dịch vụ',
                          hintText: Text(services[widget.deal.serviceId].toString(), style: const TextStyle(fontSize: 14),),
                          items: services,
                        onChanged: _readOnly != true ? (value){
                            if(value.toString() == services[0].toString()){
                              _dealService.text = '0';
                            }else if(value.toString() == services[1].toString()){
                              _dealService.text = '1';
                            }else if(value.toString() == services[2].toString()){
                              _dealService.text = '2';
                            }else if(value.toString() == services[3].toString()){
                              _dealService.text = '3';
                            }else if(value.toString() == services[4].toString()){
                              _dealService.text = '4';
                            }else if(value.toString() == services[5].toString()){
                              _dealService.text = '5';
                            }else if(value.toString() == services[6].toString()){
                              _dealService.text = '6';
                            }
                          print(_dealService.text);
                        } : null
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),

                      //Chủ hợp đồng
                      CustomReadOnlyTextField(text: '${_getDealOwnerName()}', title: 'Chủ hợp đồng'),
                      const SizedBox(height: 20.0,),

                      //Phòng ban
                      CustomReadOnlyTextField(text: '${_getDepartmentName()}', title: 'Phòng'),
                      const SizedBox(height: 20.0,),

                      //Nhóm
                      CustomReadOnlyTextField(text: '${_getTeamName()}', title: 'Nhóm'),
                      const SizedBox(height: 20.0,),

                      //Button
                      const SizedBox(height: 20.0,),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Row(
                          children: [
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
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: () {
                                  ApiService().deleteDeal(widget.deal.dealId);
                                  Future.delayed(const Duration(seconds: 3), (){
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text(
                                  'Xoá Hợp Đồng',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
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
                                      Deal deal = Deal(
                                          dealId: widget.deal.dealId,
                                          title: _dealTitle.text.isEmpty ? widget.deal.title : _dealTitle.text,
                                          dealStageId: _dealStage.text.isEmpty ? widget.deal.dealId : int.parse(_dealStage.text),
                                          amount: _dealAmount.text.isEmpty ? widget.deal.amount : int.parse(_dealAmount.text),
                                          closedDate: closeDate,
                                          dealOwnerId: widget.deal.dealOwnerId,
                                          linkTrello: '',
                                          vatId: vat.toString().isEmpty ? widget.deal.dealId : vat,
                                          serviceId: _dealService.text.isEmpty ? widget.deal.serviceId : int.parse(_dealService.text),
                                          dealTypeId: _dealType.text.isEmpty ? widget.deal.dealTypeId : int.parse(_dealType.text),
                                          contactId: widget.deal.contactId
                                      );
                                      ApiService().updateADeal(deal);
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
                  ) : const Center(child: CircularProgressIndicator()),
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
                title: Text(
                  widget.deal.title.toString(),
                  style: const TextStyle(
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
  void _getOverallInfo(){
    futureContacts = ApiService().getAllContacts();
    futureAccounts = ApiService().getAllAccounts();
    futureDepartments = ApiService().getAllDepartment();
    futureTeams = ApiService().getAllTeam();

    futureContacts.then((value) {
      setState(() {
        if(contacts.isNotEmpty){
          contacts.clear();
        }
        contacts.addAll(value);
      });
    });

    futureAccounts.then((value) {
      setState(() {
        if(accounts.isNotEmpty){
          accounts.clear();
        }
        accounts.addAll(value);
        _getdealOwnerIdNames();
      });
    });

    futureDepartments.then((value) {
      setState(() {
        if(departments.isNotEmpty){
          departments.clear();
        }
        departments.addAll(value);
      });
    });

    futureTeams.then((value) {
      setState(() {
        if(teams.isNotEmpty){
          teams.clear();
        }
        teams.addAll(value);
      });
    });
  }

  String? _getDealOwnerName() {
    for (int i = 0; i < accounts.length; i++) {
      if (widget.deal.dealOwnerId == accounts[i].accountId) {
        setState(() {
          _currentAccountDepartmentId = accounts[i].departmentId;
          _currentAccountTeamId = accounts[i].teamId;
        });
        return accounts[i].fullname;
      }
    }
  }

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

  String? _getDepartmentName(){
    for (int i = 0; i < departments.length; i++) {
      if (_currentAccountDepartmentId == departments[i].departmentId) {
        return departments[i].name;
      }
    }
  }

  String? _getTeamName(){
    for (int i = 0; i < teams.length; i++) {
      if (_currentAccountTeamId == teams[i].teamId) {
        return teams[i].name;
      }
    }
  }

  String? _getContactName(int contactId){
    for (int i = 0; i < contacts.length; i++) {
      if (contactId == contacts[i].contactId) {
        return contacts[i].fullname;
      }
    }
  }

  String? _getCompanyName(int contactId){
    for (int i = 0; i < contacts.length; i++) {
      if (contactId == contacts[i].contactId) {
        return contacts[i].companyName;
      }
    }
  }
}
