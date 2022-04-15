import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/models/issue.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_deal_list.dart';
import 'package:login_sample/views/sale_employee/sale_emp_filter.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';
import 'package:provider/provider.dart';

class EmployeeIssueAddNew extends StatefulWidget {
  const EmployeeIssueAddNew({Key? key}) : super(key: key);

  @override
  _EmployeeIssueAddNewState createState() => _EmployeeIssueAddNewState();
}

class _EmployeeIssueAddNewState extends State<EmployeeIssueAddNew> {
  
  final GlobalKey<FormState> _formKey = GlobalKey();
  Deal? _filterDeal;
  Account? _filterAccount, _currentAccount;
  DateTime? _filterDeadline;
  String _filterDealIdString = '', _filterAccountFullnameString = '', _deadlineString = '';

  final TextEditingController _issueTitle = TextEditingController();
  final TextEditingController _issueDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
  }

  @override
  void dispose() {
    super.dispose();
    _issueTitle.dispose();
    _issueDescription.dispose();
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
                borderRadius: BorderRadius.all(Radius.circular(25))
              ),
              margin: const EdgeInsets.only(top: 100.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15.0),
                    child: Column(
                      children: <Widget>[
                        //ID hợp đồng
                        const SizedBox(height: 40.0,),
                        Row(
                          children: [
                            Expanded(
                              child: CustomEditableTextFormField(
                                  borderColor: mainBgColor,
                                  text: _filterDealIdString,
                                  title: 'Mã số hợp đồng',
                                  readonly: true,
                                  onTap: () async {
                                    final data = await Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const SaleEmpDealList(issueView: true,)
                                    ));
                                    if(data != null){
                                      _filterDeal = data;
                                      setState(() {
                                        _filterDealIdString = '${_filterDeal!.dealId}';
                                      });
                                    }
                                  },
                              ),
                            ),
                          ],
                        ),

                        //Tiêu đề
                        const SizedBox(height: 20.0,),

                        Row(
                          children: [
                            Expanded(
                              child: CustomEditableTextFormField(
                                  borderColor: mainBgColor,
                                  text: _issueTitle.text.isEmpty ? '' : _issueTitle.text,
                                  title: 'Tiêu đề',
                                  readonly: false,
                                  textEditingController: _issueTitle,
                                  isLimit: true,
                                  limitNumbChar: 60,
                              ),
                            ),
                          ],
                        ),

                        //Tên người được thêm vào vấn đề
                        const SizedBox(height: 20.0,),

                        Row(
                          children: [
                            Expanded(
                              child: CustomEditableTextFormField(
                                borderColor: mainBgColor,
                                  text: _filterAccountFullnameString,
                                  title: 'Tên người được giao',
                                  readonly: true,
                                  onTap: () async {
                                    final data = await Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const SaleEmpFilter(saleForIssue: true),
                                    ));
                                    if(data != null){
                                      _filterAccount = data;
                                      setState(() {
                                        _filterAccountFullnameString = _filterAccount!.fullname!;
                                      });
                                    }
                                  },
                              ),
                            ),
                          ],
                        ),

                        //Nội dung vấn đề
                        const SizedBox(height: 20.0,),
                        Row(
                          children: [
                            Expanded(
                              child: CustomEditableTextFormField(
                                borderColor: mainBgColor,
                                  text: _issueDescription.text.isEmpty ? '' : _issueDescription.text,
                                  title: 'Nội dung vấn đề',
                                  readonly: false,
                                  textEditingController: _issueDescription,
                                  limitNumbChar: 250,
                                  isLimit: true,
                                  inputNumberOnly: false,
                              ),
                            ),
                          ],
                        ),

                        //Deadline
                        const SizedBox(height: 20.0,),
                        Row(
                          children: [
                            Expanded(
                              child: CustomEditableTextFormField(
                                borderColor: mainBgColor,
                                  text: _deadlineString,
                                  title: 'Deadline',
                                  readonly: true,
                                  onTap: () async {
                                    final data = await DatePicker.showDatePicker(
                                      context,
                                      locale : LocaleType.vi,
                                      minTime: DateTime.now(),
                                      currentTime: DateTime.now(),
                                      maxTime: DateTime.now().add(const Duration(days: 36500)),
                                    );
                                    if(data != null){
                                      _filterDeadline = data;
                                      setState(() {
                                        _deadlineString = 'Ngày ${DateFormat('dd-MM-yyyy').format(_filterDeadline!)}';
                                      });
                                    }
                                  },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30.0,),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextButton(
                                  color: mainBgColor,
                                  text: 'Tạo vấn đề',
                                  onPressed: () async {
                                    if(!_formKey.currentState!.validate()){
                                      return;
                                    }
                                    showLoaderDialog(context);
                                    bool data = await _createNewIssue();
                                    if(data == true){
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Tạo vấn đề thành công')),
                                      );
                                      Future.delayed(const Duration(seconds: 2), (){
                                        Navigator.pop(context);
                                      });
                                    }else{
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Tạo vấn đề thất bại')),
                                      );
                                    }
                                  },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40.0,),
                      ],
                    ),
                  ),
                ),
              )),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.blueGrey,
              ), // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Tạo vấn đề mới",
                style: TextStyle(
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

  Future<bool> _createNewIssue() async {

    Issue issue = Issue(
        ownerId: _currentAccount!.accountId!,
        dealId: _filterDeal!.dealId,
        title: _issueTitle.text,
        taggedAccountId: _filterAccount!.accountId!,
        description: _issueDescription.text,
        deadlineDate: _filterDeadline!
    );

    Issue? result = await ApiService().createNewIssue(issue);
    if(result != null){
      return true;
    }else{
      return false;
    }
  }

}
