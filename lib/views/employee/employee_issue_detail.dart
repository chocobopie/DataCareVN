import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/issue.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/account_view_model.dart';
import 'package:login_sample/view_models/issue_view_model.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/views/sale_employee/sale_emp_filter.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';
import 'package:provider/provider.dart';

class EmployeeIssueDetail extends StatefulWidget {
  const EmployeeIssueDetail({Key? key, required this.issue, this.viewOnly}) : super(key: key);

  final Issue issue;
  final bool? viewOnly;

  @override
  _EmployeeIssueDetailState createState() => _EmployeeIssueDetailState();
}

class _EmployeeIssueDetailState extends State<EmployeeIssueDetail> {

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _readOnly = true;
  Account? _filterAccount, _currentAccount;
  DateTime? _filterDeadline;
  String _deadlineString = '', _taggedAccountFullname = '';
  final TextEditingController _issueTitle = TextEditingController();
  final TextEditingController _issueDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getAccountFullnameByAccountId(widget.issue.taggedAccountId);
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
              height: MediaQuery.of(context).size.height * 0.3
          ),
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
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Column(
                      children: <Widget>[
                        //ID hợp đồng
                        const SizedBox(height: 20.0,),
                        Row(
                          children: [
                            Expanded(
                              child: CustomEditableTextFormField(
                                  text: '${widget.issue.dealId}',
                                  title: 'Mã số hợp đồng',
                                  readonly: _readOnly
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
                                  borderColor: _readOnly != true ? mainBgColor : null,
                                  text: _issueTitle.text.isEmpty ? widget.issue.title : _issueTitle.text,
                                  title: 'Tiêu đề',
                                  readonly: _readOnly,
                                  textEditingController: _issueTitle,
                              ),
                            ),
                          ],
                        ),

                        //Tên người được giao
                        const SizedBox(height: 20.0,),
                        Row(
                          children: [
                            Expanded(
                              child: CustomEditableTextFormField(
                                  borderColor: _readOnly != true ? mainBgColor : null,
                                  text: _filterAccount == null ? _taggedAccountFullname : _filterAccount!.fullname!,
                                  title: 'Người được giao',
                                  readonly: true,
                                  onTap: () async {
                                    final data = await Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const SaleEmpFilter(saleForIssue: true),
                                    ));
                                    if(data != null){
                                      setState(() {
                                        _filterAccount = data;
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
                                  borderColor: _readOnly != true ? mainBgColor : null,
                                  text: _issueDescription.text.isEmpty ? widget.issue.description : _issueDescription.text,
                                  title: 'Nội dung vấn đề',
                                  readonly: _readOnly,
                                  textEditingController: _issueDescription,
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
                                  borderColor: _readOnly != true ? mainBgColor : null,
                                  text: _deadlineString.isEmpty ? 'Ngày ${DateFormat('dd-MM-yyyy').format(widget.issue.deadlineDate)}' : _deadlineString,
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


                        //Nút xoá & lưu
                        const SizedBox(height: 30.0,),
                        if(widget.viewOnly != null)
                          if(widget.viewOnly == false)
                        Row(
                          children: <Widget>[
                            //Nút xoá
                            Expanded(
                              child: CustomTextButton(
                                  color: _readOnly == true ? Colors.red : mainBgColor,
                                  text: _readOnly == true ? 'Xóa vấn đề' : 'Hủy',
                                  onPressed: () async {
                                    if(_readOnly == true){

                                      showLoaderDialog(context);

                                      bool data = await _deleteIssue(widget.issue.issueId!);
                                      if(data == true){
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Xóa vấn đề thành công')),
                                        );
                                        Future.delayed(const Duration(seconds: 1), (){
                                          Navigator.pop(context);
                                        });
                                      }else{
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Xóa vấn đề thất bại')),
                                        );
                                      }
                                    }

                                    if(_readOnly == false){
                                      setState(() {
                                        _readOnly = true;
                                      });
                                    }
                                  },
                              ),
                            ),
                            const SizedBox(width: 10.0,),
                            //Nút lưu
                            Expanded(
                              child: CustomTextButton(
                                  color: mainBgColor,
                                  text: _readOnly == true ? 'Chỉnh sửa' : 'Lưu',
                                  onPressed: () async {

                                    if(_readOnly == false){
                                      if(!_formKey.currentState!.validate()){
                                        return;
                                      }

                                      showLoaderDialog(context);

                                      bool data = await _updateAIssue();
                                      if(data == true){
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Cập nhật vấn đề thành công')),
                                        );
                                        Future.delayed(const Duration(seconds: 1), (){
                                          Navigator.pop(context);
                                        });
                                      }else{
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Cập nhật vấn đề thất bại')),
                                        );
                                      }
                                    }


                                    if(_readOnly == true){
                                      setState(() {
                                        _readOnly = false;
                                      });
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
              )
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              // Add AppBar here only
              iconTheme: const IconThemeData(color: Colors.blueGrey),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Chi tiết vấn đề",
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

  void _getAccountFullnameByAccountId(int accountId) async {

    Account account = await AccountViewModel().getAccountByAccountId(accountId: accountId);

    setState(() {
      _taggedAccountFullname = account.fullname!;
    });
  }

  Future<bool> _updateAIssue() async {

    Issue issue = Issue(
      ownerId: widget.issue.ownerId,
      taggedAccountId: _filterAccount == null ? widget.issue.taggedAccountId : _filterAccount!.accountId!,
      dealId: widget.issue.dealId,
      title: _issueTitle.text.isEmpty ? widget.issue.title : _issueTitle.text,
      issueId: widget.issue.issueId,
      description: _issueDescription.text.isEmpty ? widget.issue.description : _issueDescription.text,
      createdDate: widget.issue.createdDate,
      deadlineDate: _filterDeadline == null ? widget.issue.deadlineDate : _filterDeadline!
    );

    Issue? result = await IssueViewModel().updateAIssue(issue);

    if(result != null){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> _deleteIssue(int issueId) async {
    bool result = await IssueViewModel().deleteIssue(issueId);

    return result;
  }
}
