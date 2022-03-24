import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/account_view_model.dart';
import 'package:login_sample/view_models/contact_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_date_filter.dart';
import 'package:login_sample/views/sale_employee/sale_emp_deal_timeline.dart';
import 'package:login_sample/views/sale_employee/sale_emp_filter.dart';
import 'package:login_sample/widgets/CustomDatePicker.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:login_sample/widgets/CustomReadOnlyTextField.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';
import 'package:provider/provider.dart';

class SaleEmpDealDetail extends StatefulWidget {
  const SaleEmpDealDetail({Key? key, required this.deal}) : super(key: key);

  final Deal deal;

  @override
  _SaleEmpDealDetailState createState() => _SaleEmpDealDetailState();
}

class _SaleEmpDealDetailState extends State<SaleEmpDealDetail> {
  late DateTime closeDate = widget.deal.closedDate;
  String _closeDate = '';

  bool _readOnly = true;

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
  late Account currentAccount, filterAccount = Account();

  @override
  void initState() {
    super.initState();
    currentAccount =
        Provider.of<AccountProvider>(context, listen: false).account;
    _getContactByContactId(widget.deal.contactId);
    _getAccountByAccountId(
      accountId: widget.deal.dealOwnerId,
    );
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
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: contact != null && account != null
                      ? ListView(
                          children: <Widget>[
                            CustomReadOnlyTextField(
                                text: '${widget.deal.dealId}',
                                title: 'Mã số hợp đồng'),
                            const SizedBox(height: 20.0,),

                            //Tiêu đề hợp đồng
                            CustomEditableTextFormField(
                              inputNumberOnly: false,
                              borderColor: _readOnly != true ? mainBgColor : null,
                              text: widget.deal.title,
                              title: 'Tiêu đề',
                              readonly: _readOnly,
                              textEditingController: _dealTitle,
                            ),
                            const SizedBox(height: 20.0,),

                            //Tên khách hàng
                            CustomReadOnlyTextField(
                                borderColor: _readOnly != true ? mainBgColor : null,
                                text: contact!.fullname,
                                title: 'Tên khách hàng'),
                            const SizedBox(height: 20.0,),

                            //Tên công ty khách hàng
                            CustomReadOnlyTextField(
                                text: contact!.companyName,
                                title: 'Tên công ty khách hàng'),
                            const SizedBox(height: 20.0,),

                            //Tiến trình hợp đồng
                            CustomDropdownFormField2(
                                borderColor: _readOnly != true ? mainBgColor : null,
                                label: 'Tiến trình hợp đồng',
                                hintText: Text(
                                  dealStagesNameUtilities[
                                          widget.deal.dealStageId]
                                      .toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                items: dealStagesNameUtilities,
                                onChanged: widget.deal.dealStageId != 5 &&
                                        _readOnly != true
                                    ? (value) {
                                        if (value.toString() ==
                                            dealStagesNameUtilities[0]
                                                .toString()) {
                                          _dealStage.text = '0';
                                        } else if (value.toString() ==
                                            dealStagesNameUtilities[1]
                                                .toString()) {
                                          _dealStage.text = '1';
                                        } else if (value.toString() ==
                                            dealStagesNameUtilities[2]
                                                .toString()) {
                                          _dealStage.text = '2';
                                        } else if (value.toString() ==
                                            dealStagesNameUtilities[3]
                                                .toString()) {
                                          _dealStage.text = '3';
                                        } else if (value.toString() ==
                                            dealStagesNameUtilities[4]
                                                .toString()) {
                                          _dealStage.text = '4';
                                        } else if (value.toString() ==
                                            dealStagesNameUtilities[5]
                                                .toString()) {
                                          _dealStage.text = '5';
                                        } else if (value.toString() ==
                                            dealStagesNameUtilities[6]
                                                .toString()) {
                                          _dealStage.text = '6';
                                        }
                                        print(_dealStage.text);
                                      }
                                    : null),
                            const SizedBox(height: 20.0,),

                            //Loại hợp đồng
                            CustomDropdownFormField2(
                                borderColor: _readOnly != true ? mainBgColor : null,
                                label: 'Loại hợp đồng',
                                hintText: Text(
                                  dealTypesNameUtilities[widget.deal.dealTypeId]
                                      .toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                items: dealTypesNameUtilities,
                                onChanged: _readOnly != true
                                    ? (value) {
                                        if (value.toString() ==
                                            dealTypesNameUtilities[0]
                                                .toString()) {
                                          _dealType.text = '0';
                                        } else {
                                          _dealType.text = '1';
                                        }
                                        print(_dealType.text);
                                      }
                                    : null),
                            const SizedBox(height: 20.0,),

                            //Tổng giá trị
                            CustomEditableTextFormField(
                                borderColor: _readOnly != true ? mainBgColor : null,
                                inputNumberOnly: true,
                                text: '${widget.deal.amount}',
                                title: 'Tổng giá trị (VNĐ)',
                                readonly: _readOnly,
                                textEditingController: _dealAmount),
                            const SizedBox(height: 20.0,),

                            //Vat
                            CustomDropdownFormField2(
                              borderColor: _readOnly != true ? mainBgColor : null,
                              label: 'VAT',
                              hintText: Text(
                                dealVatsNameUtilities[widget.deal.vatId],
                                style: const TextStyle(fontSize: 14),
                              ),
                              items: dealVatsNameUtilities,
                              onChanged: _readOnly != true
                                  ? (value) {
                                      if (value.toString() ==
                                          dealVatsNameUtilities[0].toString()) {
                                        _dealVatId.text = '0';
                                      } else {
                                        _dealVatId.text = '1';
                                      }
                                    }
                                  : null,
                            ),
                            const SizedBox(height: 20.0,),

                            //Loại dịch vụ
                            CustomDropdownFormField2(
                                borderColor: _readOnly != true ? mainBgColor : null,
                                label: 'Loại dịch vụ',
                                hintText: Text(
                                  dealServicesNameUtilities[
                                          widget.deal.serviceId]
                                      .toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                items: dealServicesNameUtilities,
                                onChanged: _readOnly != true
                                    ? (value) {
                                        if (value.toString() ==
                                            dealServicesNameUtilities[0]
                                                .toString()) {
                                          _dealService.text = '0';
                                        } else if (value.toString() ==
                                            dealServicesNameUtilities[1]
                                                .toString()) {
                                          _dealService.text = '1';
                                        } else if (value.toString() ==
                                            dealServicesNameUtilities[2]
                                                .toString()) {
                                          _dealService.text = '2';
                                        } else if (value.toString() ==
                                            dealServicesNameUtilities[3]
                                                .toString()) {
                                          _dealService.text = '3';
                                        } else if (value.toString() ==
                                            dealServicesNameUtilities[4]
                                                .toString()) {
                                          _dealService.text = '4';
                                        } else if (value.toString() ==
                                            dealServicesNameUtilities[5]
                                                .toString()) {
                                          _dealService.text = '5';
                                        } else if (value.toString() ==
                                            dealServicesNameUtilities[6]
                                                .toString()) {
                                          _dealService.text = '6';
                                        }
                                        print(_dealService.text);
                                      }
                                    : null),
                            const SizedBox(height: 20.0,),

                            //Ngày đóng
                            // SizedBox(
                            //   child: TextField(readOnly: _readOnly,
                            //     onTap: _readOnly != true ? () async {
                            //             FocusScope.of(context).requestFocus(FocusNode());
                            //             final date = await DatePicker.showDatePicker(context,
                            //               locale: LocaleType.vi,
                            //               minTime: DateTime.now(),
                            //               currentTime: DateTime.now(),
                            //               maxTime: DateTime.now()
                            //                   .add(const Duration(days: 36500)),
                            //             );
                            //             if (date != null) {
                            //               setState(() {
                            //                 _dealClosedDate.text = date.toString();
                            //                 _closeDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(date)}';
                            //                 print(date);
                            //               });
                            //             }
                            //           } : null,
                            //     decoration: InputDecoration(
                            //       floatingLabelBehavior:
                            //           FloatingLabelBehavior.always,
                            //       contentPadding:
                            //           const EdgeInsets.only(left: 20.0),
                            //       labelText: 'Ngày đóng',
                            //       hintText: _closeDate.isNotEmpty ? _closeDate : 'Ngày ${DateFormat('dd-MM-yyyy').format(widget.deal.closedDate)}',
                            //       labelStyle: const TextStyle(
                            //         color: Color.fromARGB(255, 107, 106, 144),
                            //         fontSize: 18,
                            //         fontWeight: FontWeight.w500,
                            //       ),
                            //       enabledBorder: OutlineInputBorder(
                            //         borderSide: BorderSide(
                            //             color: Colors.grey.shade300, width: 2),
                            //         borderRadius: BorderRadius.circular(10),
                            //       ),
                            //       focusedBorder: OutlineInputBorder(
                            //         borderSide: const BorderSide(
                            //             color: Colors.blue, width: 2),
                            //         borderRadius: BorderRadius.circular(10),
                            //       ),
                            //     ),
                            //   ),
                            //   width: 150.0,
                            // ),
                            CustomDatePicker(
                                borderColor: _readOnly != true ? mainBgColor : null,
                                label: 'Ngày chốt hợp đồng',
                                hintText: _closeDate.isNotEmpty ? _closeDate : 'Ngày ${DateFormat('dd-MM-yyyy').format(widget.deal.closedDate)}',
                                onTap: _readOnly != true ? () async {
                                  FocusScope.of(context).requestFocus(FocusNode());
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
                                      print(date);
                                    });
                                  }
                                } : null,
                            ),
                            const SizedBox(height: 20.0,),

                            //Link trello
                            CustomEditableTextFormField(
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

                            //Chủ hợp đồng
                            CustomEditableTextFormField(
                              borderColor: _readOnly != true ? mainBgColor : null,
                              text: account!.fullname!,
                              title: 'Chủ hợp đồng',
                              readonly: true,
                              textEditingController: _dealOwnerId,
                              onTap: _readOnly != true
                                  ? () async {
                                      final data = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SaleEmpFilter(),
                                          ));
                                      if (data != null) {
                                        setState(() {
                                          account = data;
                                          _dealOwnerId.text =
                                              '${account!.accountId}';
                                        });
                                      }
                                    }
                                  : null,
                            ),
                            const SizedBox(height: 20.0,),

                            //Phòng ban
                            if (account?.departmentId != null)
                              CustomReadOnlyTextField(text: _getDepartmentName(account!.departmentId!), title: 'Phòng'),
                            if (account?.departmentId! != null)
                              const SizedBox(height: 20.0,),

                            //Nhóm
                            if (account?.teamId != null)
                              CustomReadOnlyTextField(text: _getTeamNamwe(account!.teamId!), title: 'Nhóm'),

                            //Button
                            const SizedBox(height: 20.0,),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: CustomTextButton(
                                          color: Colors.red,
                                          text: 'Xóa hợp đồng',
                                          onPressed: () {
                                          ApiService().deleteDeal(widget.deal.dealId);
                                          Future.delayed(const Duration(seconds: 2), () {Navigator.pop(context);});
                                        },
                                      ),
                                  ),
                                  const SizedBox(width: 10.0,),
                                  Expanded(
                                      child: _readOnly == true
                                          ? CustomTextButton(color: Colors.blue, text: 'Chỉnh sửa',
                                              onPressed: () {
                                                setState(() {
                                                  _readOnly = false;
                                                  print('Chỉnh sửa');
                                                });
                                              },
                                            )
                                          : CustomTextButton(
                                              color: Colors.blue,
                                              text: 'Lưu',
                                              onPressed: () {
                                                setState(() {
                                                  Deal deal = Deal(
                                                      dealId: widget.deal.dealId,
                                                      title: _dealTitle.text.isEmpty ? widget.deal.title : _dealTitle.text,
                                                      dealStageId: _dealStage.text.isEmpty ? widget.deal.dealStageId : int.parse(_dealStage.text),
                                                      amount: _dealAmount.text.isEmpty ? widget.deal.amount : int.parse(_dealAmount.text),
                                                      closedDate: _dealClosedDate.text.isEmpty ? widget.deal.closedDate : DateTime.parse(_dealClosedDate.text),
                                                      dealOwnerId: _dealOwnerId.text.isEmpty ? widget.deal.dealOwnerId : int.parse(_dealOwnerId.text),
                                                      linkTrello: _dealLinkTrello.text.isEmpty ? widget.deal.linkTrello : _dealLinkTrello.text.isEmpty ? '' : _dealLinkTrello.text,
                                                      vatId: _dealVatId.text.isEmpty ? widget.deal.vatId : int.parse(_dealVatId.text),
                                                      serviceId: _dealService.text.isEmpty ? widget.deal.serviceId : int.parse(_dealService.text),
                                                      dealTypeId: _dealType.text.isEmpty ? widget.deal.dealTypeId : int.parse(_dealType.text),
                                                      contactId: widget.deal.contactId
                                                  );
                                                  ApiService().updateADeal(deal);
                                                  _readOnly = true;
                                                  Future.delayed(const Duration(seconds: 2), () {Navigator.pop(context);});
                                                  print('Lưu');
                                                });
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
                      : const Center(child: CircularProgressIndicator()))),
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

  void _getContactByContactId(int contactId) async {
    final data = await ContactViewModel().getContactByContactId(contactId);
    setState(() {
      contact = data;
    });
  }

  void _getAccountByAccountId({required accountId}) async {
    final _account =
        await AccountViewModel().getAccountByAccountId(accountId: accountId);
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
