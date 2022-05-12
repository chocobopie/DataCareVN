import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/account_view_model.dart';
import 'package:login_sample/view_models/contact_view_model.dart';
import 'package:login_sample/view_models/deal_view_model.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_deal_timeline.dart';
import 'package:login_sample/views/sale_employee/sale_emp_filter.dart';
import 'package:login_sample/widgets/CustomDatePicker.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomReadOnlyTextField.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';
import 'package:provider/provider.dart';

class SaleEmpDealDetail extends StatefulWidget {
  const SaleEmpDealDetail({Key? key, required this.deal, this.readOnly}) : super(key: key);

  final Deal deal;
  final bool? readOnly;

  @override
  _SaleEmpDealDetailState createState() => _SaleEmpDealDetailState();
}

class _SaleEmpDealDetailState extends State<SaleEmpDealDetail> {
  late DateTime closeDate = widget.deal.closedDate;
  String _closeDate = '';

  bool _readOnly = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _dealTitle = TextEditingController();
  final TextEditingController _dealStage = TextEditingController();
  final TextEditingController _dealType = TextEditingController();
  final TextEditingController _dealAmount = TextEditingController();
  final TextEditingController _dealService = TextEditingController();
  final TextEditingController _dealOwnerId = TextEditingController();
  final TextEditingController _dealLinkTrello = TextEditingController();
  late final TextEditingController _dealClosedDate = TextEditingController();
  final TextEditingController _dealVatId = TextEditingController();

  Contact? contact;
  Account? account;
  late Account _currentAccount, filterAccount = Account();

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getContactByContactId(widget.deal.contactId);
    _getAccountByAccountId(accountId: widget.deal.dealOwnerId,);
  }

  @override
  void dispose() {
    _dealTitle.dispose();
    _dealStage.dispose();
    _dealType.dispose();
    _dealAmount.dispose();
    _dealService.dispose();
    _dealOwnerId.dispose();
    _dealLinkTrello.dispose();
    _dealClosedDate.dispose();
    _dealVatId.dispose();
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
              height: MediaQuery.of(context).size.height * 0.3),
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
                    padding: const EdgeInsets.all(15.0),
                    child: contact != null && account != null ? ListView(
                            children: <Widget>[
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomReadOnlyTextField(
                                        text: '${widget.deal.dealId}',
                                        title: 'Mã số hợp đồng'),
                                    flex: 2,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0,),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: CustomEditableTextFormField(
                                      inputNumberOnly: false,
                                      borderColor: _readOnly != true ? mainBgColor : null,
                                      text: widget.deal.title,
                                      title: 'Tiêu đề',
                                      readonly: _readOnly,
                                      textEditingController: _dealTitle,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0,),
                              //Tên khách hàng
                              CustomReadOnlyTextField(
                                  text: contact!.fullname,
                                  title: 'Tên khách hàng'),
                              const SizedBox(height: 20.0,),

                              //Tên công ty khách hàng
                              CustomReadOnlyTextField(
                                  text: contact!.companyName,
                                  title: 'Tên công ty khách hàng'),
                              const SizedBox(height: 20.0,),

                              //Tiến trình hợp đồng
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomDropdownFormField2(
                                        value: _dealStage.text.isEmpty ? dealStagesNames[widget.deal.dealStageId] : dealStagesNames[int.parse(_dealStage.text)],
                                        borderColor: widget.deal.dealStageId != 5 ? _readOnly != true ? mainBgColor : null : null,
                                        label: 'Tiến trình hợp đồng',
                                        hintText: Text(
                                          dealStagesNames[
                                                  widget.deal.dealStageId]
                                              .toString(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        items: dealStagesNames,
                                        onChanged: widget.deal.dealStageId != 5 &&
                                                _readOnly != true ? (value) {
                                                if (value.toString() == dealStagesNames[0].toString()) {
                                                  setState(() {
                                                    _dealStage.text = '0';
                                                  });
                                                } else if (value.toString() == dealStagesNames[1].toString()) {
                                                  setState(() {
                                                    _dealStage.text = '1';
                                                  });
                                                } else if (value.toString() == dealStagesNames[2].toString()) {
                                                  setState(() {
                                                    _dealStage.text = '2';
                                                  });
                                                } else if (value.toString() == dealStagesNames[3].toString()) {
                                                  setState(() {
                                                    _dealStage.text = '3';
                                                  });
                                                } else if (value.toString() == dealStagesNames[4].toString()) {
                                                  setState(() {
                                                    _dealStage.text = '4';
                                                  });
                                                } else if (value.toString() == dealStagesNames[5].toString()) {
                                                  setState(() {
                                                    _dealStage.text = '5';
                                                    _dealClosedDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
                                                    _closeDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(DateTime.now())}';
                                                  });
                                                } else if (value.toString() == dealStagesNames[6].toString()) {
                                                  setState(() {
                                                    _dealStage.text = '6';
                                                  });
                                                }
                                              }
                                            : null),
                                  ),
                                  const SizedBox(width: 5.0,),
                                  Expanded(
                                    child: CustomDropdownFormField2(
                                        value: _dealType.text.isEmpty ? dealTypesNames[widget.deal.dealTypeId] : dealTypesNames[int.parse(_dealType.text)],
                                        borderColor: _readOnly != true ? mainBgColor : null,
                                        label: 'Loại hợp đồng',
                                        hintText: Text(dealTypesNames[widget.deal.dealTypeId].toString(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        items: dealTypesNames,
                                        onChanged: _readOnly != true ? (value) {
                                          if (value.toString() == dealTypesNames[0].toString()) {
                                            _dealType.text = '0';
                                          } else {
                                            _dealType.text = '1';
                                          }
                                        }
                                            : null),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0,),

                              //Vat
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: CustomDropdownFormField2(
                                      value: _dealVatId.text.isEmpty ? dealVatsNames[widget.deal.vatId] : dealVatsNames[int.parse(_dealVatId.text)],
                                      borderColor: _readOnly != true ? mainBgColor : null,
                                      label: 'VAT',
                                      hintText: Text(
                                        dealVatsNames[widget.deal.vatId],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      items: dealVatsNames,
                                      onChanged: _readOnly != true
                                          ? (value) {
                                              if (value.toString() == dealVatsNames[0].toString()) {
                                                _dealVatId.text = '0';
                                              } else {
                                                _dealVatId.text = '1';
                                              }
                                            }
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0,),
                                  Expanded(
                                    child: CustomDropdownFormField2(
                                        value: _dealService.text.isEmpty ? dealServicesNames[widget.deal.serviceId] : dealServicesNames[int.parse(_dealService.text)],
                                        borderColor: _readOnly != true ? mainBgColor : null,
                                        label: 'Loại dịch vụ',
                                        hintText: Text(
                                          dealServicesNames[widget.deal.serviceId].toString(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        items: dealServicesNames,
                                        onChanged: _readOnly != true
                                            ? (value) {
                                          if (value.toString() ==
                                              dealServicesNames[0]
                                                  .toString()) {
                                            _dealService.text = '0';
                                          } else if (value.toString() ==
                                              dealServicesNames[1]
                                                  .toString()) {
                                            _dealService.text = '1';
                                          } else if (value.toString() ==
                                              dealServicesNames[2]
                                                  .toString()) {
                                            _dealService.text = '2';
                                          } else if (value.toString() ==
                                              dealServicesNames[3]
                                                  .toString()) {
                                            _dealService.text = '3';
                                          } else if (value.toString() ==
                                              dealServicesNames[4]
                                                  .toString()) {
                                            _dealService.text = '4';
                                          } else if (value.toString() ==
                                              dealServicesNames[5]
                                                  .toString()) {
                                            _dealService.text = '5';
                                          } else if (value.toString() ==
                                              dealServicesNames[6]
                                                  .toString()) {
                                            _dealService.text = '6';
                                          }
                                        }
                                            : null),
                                  ),

                                ],
                              ),
                              const SizedBox(height: 20.0,),

                              //Số tiền
                              CustomEditableTextFormField(
                                  isNull: (_dealStage.text == '5' || widget.deal.dealStageId == 5) ? false : true,
                                  inputMoney: true,
                                  borderColor: _readOnly != true ? mainBgColor : null,
                                  inputNumberOnly: true,
                                  text: _dealAmount.text.isEmpty ? widget.deal.amount > 0 ? formatNumber(widget.deal.amount.toString().replaceAll('.', '')) : 'Chưa chốt giá' : formatNumber(_dealAmount.text.replaceAll('.', '')),
                                  title: 'Số tiền (VNĐ)',
                                  readonly: _readOnly,
                                  textEditingController: _dealAmount
                              ),
                              const SizedBox(height: 20.0,),


                              CustomDatePicker(
                                  readOnly: true,
                                  borderColor: (_dealStage.text != '5' && widget.deal.dealStageId != 5) ? _readOnly != true ? mainBgColor : null : null,
                                  label: 'Ngày chốt hợp đồng ${ (widget.deal.dealStageId != 5 && _dealStage.text != '5') ? '- Dự kiến' : ''}',
                                  hintText: _closeDate.isNotEmpty ? _closeDate : 'Ngày ${DateFormat('dd-MM-yyyy').format(widget.deal.closedDate)}',
                                  onTap: (_dealStage.text != '5' && widget.deal.dealStageId != 5) ? _readOnly != true ? () async {
                                    final date = await DatePicker.showDatePicker(context,
                                      locale: LocaleType.vi,
                                      minTime: DateTime.now(),
                                      currentTime: DateTime.now(),
                                      maxTime: DateTime.now().add(const Duration(days: 36500)),
                                    );
                                    if (date != null) {
                                      setState(() {
                                        _dealClosedDate.text = date.toString();
                                        _closeDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(date)}';
                                      });
                                    }
                                  } : null : null,
                              ),
                              const SizedBox(height: 20.0,),

                              //Link trello
                              CustomEditableTextFormField(
                                  isNull: true,
                                  borderColor: _readOnly != true ? mainBgColor : null,
                                  text: widget.deal.linkTrello!.isNotEmpty
                                      ? widget.deal.linkTrello!
                                      : '',
                                  title: 'Link Trello',
                                  readonly: _readOnly,
                                  textEditingController: _dealLinkTrello),
                              const SizedBox(
                                height: 20.0,
                              ),

                              //Người quản lý họp đồng
                              CustomEditableTextFormField(
                                borderColor: _currentAccount.roleId != 5 ? _readOnly != true ? mainBgColor : null : null,
                                text: account!.fullname!,
                                title: 'Người quản lý hợp đồng',
                                readonly: true,
                                textEditingController: _dealOwnerId,
                                onTap: _currentAccount.roleId != 5 ? _readOnly != true
                                    ? () async {
                                        final data = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const SaleEmpFilter(salesForDeal: true),
                                            ));
                                        if (data != null) {
                                          setState(() {
                                            account = data;
                                            _dealOwnerId.text =
                                                '${account!.accountId}';
                                          });
                                        }
                                      }
                                    : null : null,
                              ),
                              const SizedBox(height: 20.0,),

                              //Phòng ban
                              if (account?.departmentId != null)
                                CustomReadOnlyTextField(text: _getDepartmentName(account!.departmentId!), title: 'Thuộc quản lý của phòng ban'),
                              if (account?.departmentId! != null)
                                const SizedBox(height: 20.0,),

                              //Nhóm
                              if (account?.teamId != null)
                                CustomReadOnlyTextField(text: _getTeamNamwe(account!.teamId!), title: 'Thuộc quản lý của nhóm'),

                              //Button
                              const SizedBox(height: 20.0,),
                              if(widget.readOnly == null)
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    if(_readOnly == true)
                                    if( widget.deal.dealStageId != 5 || (widget.deal.dealStageId == 5 && _currentAccount.roleId == 3 && widget.deal.closedDate.month < DateTime.now().month && widget.deal.closedDate.year <= DateTime.now().year))
                                    Expanded(
                                        child: CustomTextButton(
                                            color: Colors.red,
                                            text: 'Xóa hợp đồng',
                                            onPressed: () async {
                                              showLoaderDialog(context);
                                              bool data = await _deleteDeal(widget.deal.dealId);
                                              if(data == true){
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Xóa hợp đồng thành công')),
                                                );
                                                Future.delayed(const Duration(seconds: 1), (){
                                                  Navigator.pop(context);
                                                });
                                              }else{
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Xóa hợp đồng thất bại')),
                                                );
                                              }
                                          },
                                        ),
                                    ),
                                    const SizedBox(width: 10.0,),
                                    if(_readOnly == false)
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10.0),
                                        child: CustomTextButton(
                                            color: Colors.purple,
                                            text: 'Hủy',
                                            onPressed: (){
                                              setState(() {
                                                _readOnly = true;
                                              });
                                            },
                                        ),
                                      ),
                                    ),
                                    if(widget.deal.dealStageId != 5 || (widget.deal.closedDate.month >= DateTime.now().month && widget.deal.closedDate.year >= DateTime.now().year))
                                    Expanded(
                                        child: _readOnly == true
                                            ? CustomTextButton(color: mainBgColor, text: 'Chỉnh sửa',
                                                onPressed: () {
                                                  setState(() {
                                                    _readOnly = false;
                                                  });
                                                },
                                              )
                                            : CustomTextButton(
                                                color: mainBgColor,
                                                text: 'Lưu',
                                                onPressed: () async {
                                                  if(!_formKey.currentState!.validate()){
                                                    return;
                                                  }
                                                  showLoaderDialog(context);
                                                  bool data = await _updateDeal();
                                                  if(data == true){
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Cập nhật hợp đồng thành công')),
                                                    );
                                                    Future.delayed(const Duration(seconds: 1), (){
                                                      Navigator.pop(context);
                                                    });
                                                  }else{
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Cập nhật hợp đồng thất bại')),
                                                    );
                                                  }
                                                },
                                              )),
                                    const SizedBox(width: 10.0,),
                                    Expanded(
                                      child: CustomTextButton(
                                        color: Colors.green,
                                        text: 'Lịch sử chỉnh sửa',
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SaleEmpDealTimeline(deal: widget.deal),));
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const Center(child: CircularProgressIndicator())),
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

  Future<bool> _deleteDeal(int dealId) async {
    bool result = await DealViewModel().deleteDeal(dealId);
    return result;
  }

  Future<bool> _updateDeal() async {
    Deal deal = Deal(
        dealId: widget.deal.dealId,
        title: _dealTitle.text.isEmpty ? widget.deal.title : _dealTitle.text,
        dealStageId: _dealStage.text.isEmpty ? widget.deal.dealStageId : int.parse(_dealStage.text),
        amount: _dealAmount.text.isEmpty ? widget.deal.amount > 0 ? widget.deal.amount : 0 : num.parse(_dealAmount.text),
        closedDate: _dealClosedDate.text.isEmpty ? widget.deal.closedDate : DateTime.parse(_dealClosedDate.text),
        dealOwnerId: _dealOwnerId.text.isEmpty ? widget.deal.dealOwnerId : int.parse(_dealOwnerId.text),
        linkTrello: _dealLinkTrello.text.isEmpty ? widget.deal.linkTrello : _dealLinkTrello.text.isEmpty ? '' : _dealLinkTrello.text,
        vatId: _dealVatId.text.isEmpty ? widget.deal.vatId : int.parse(_dealVatId.text),
        serviceId: _dealService.text.isEmpty ? widget.deal.serviceId : int.parse(_dealService.text),
        dealTypeId: _dealType.text.isEmpty ? widget.deal.dealTypeId : int.parse(_dealType.text),
        contactId: widget.deal.contactId
    );

    bool result = await DealViewModel().updateADeal(deal, _currentAccount.accountId!);

    return result;
  }

  void _getContactByContactId(int contactId) async {
    final data = await ContactViewModel().getContactByContactId(contactId);
    setState(() {
      contact = data;
    });
  }

  void _getAccountByAccountId({required accountId}) async {
    final _account = await AccountViewModel().getAccountByAccountId(accountId: accountId);
    setState(() {
      account = _account;
    });
  }

  String _getDepartmentName(int departmentId) {
    String name = '';
    for (int i = 0; i < departments.length; i++) {
      if (departmentId == departments[i].departmentId) {
        setState(() {
          name = departments[i].name;
        });
      }
    }
    return name;
  }

  String _getTeamNamwe(int teamId) {
    String name = '';
    for (int i = 0; i < teams.length; i++) {
      if (teamId == teams[i].teamId) {
        setState(() {
          name = teams[i].name;
        });
      }
    }
    return name;
  }
}
