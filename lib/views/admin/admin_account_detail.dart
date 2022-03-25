import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/account_permission.dart';
import 'package:login_sample/models/attendance_permission.dart';
import 'package:login_sample/models/block.dart';
import 'package:login_sample/models/contact_permission.dart';
import 'package:login_sample/models/deal_permission.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/models/issue.dart';
import 'package:login_sample/models/issue_permission.dart';
import 'package:login_sample/models/payroll_permission.dart';
import 'package:login_sample/models/permission.dart';
import 'package:login_sample/models/role.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/permission_view_model.dart';
import 'package:login_sample/views/admin/admin_block_filter.dart';
import 'package:login_sample/views/admin/admin_department_filter.dart';
import 'package:login_sample/views/admin/admin_team_filter.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomExpansionTile.dart';
import 'package:provider/provider.dart';

class AdminAccountDetail extends StatefulWidget {
  const AdminAccountDetail({Key? key, required this.account}) : super(key: key);

  final Account account;

  @override
  State<AdminAccountDetail> createState() => _AdminAccountDetailState();
}

class _AdminAccountDetailState extends State<AdminAccountDetail> {

  bool _readOnly = true;
  late final Account _currentAccount = widget.account;

  Permission? _permission;
  AccountPermission? _accountPermission;
  AttendancePermission? _attendancePermission;
  PayrollPermission? _payrollPermission;
  ContactPermission? _contactPermission;
  DealPermission? _dealPermission;
  IssuePermission? _issuePermission;

  Block? _filterBlock;
  Department? _filterDepartment;
  Team? _filterTeam;
  Role? _filterRole;

  final TextEditingController _accountDepartmentId = TextEditingController();
  final TextEditingController _accountBlockId = TextEditingController();
  final TextEditingController _accountTeamId = TextEditingController();
  final TextEditingController _accountRoleId = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getOverallInfo();
  }

  @override
  void dispose() {
    super.dispose();
    _accountDepartmentId.dispose();
    _accountBlockId.dispose();
    _accountTeamId.dispose();
    _accountRoleId.dispose();
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
                  child: _currentAccount != null ? ListView(
                    children: <Widget>[
                      CustomEditableTextFormField(
                          text: _currentAccount.email!.isEmpty ? 'Chưa cập nhật' : _currentAccount.email!,
                          title: 'Email',
                          readonly: true,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.fullname!.isEmpty ? 'Chưa cập nhật' : _currentAccount.fullname!,
                          title: 'Họ và tên',
                          readonly: true,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.phoneNumber!.isEmpty ? 'Chưa cập nhật' : _currentAccount.phoneNumber!,
                          title: 'Số điện thoại',
                          readonly: true,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.address!.isEmpty ? 'Chưa cập nhật' : _currentAccount.address!,
                          title: 'Địa chỉ',
                          readonly: true,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.citizenIdentityCardNumber!.isEmpty ? 'Chưa cập nhật' : _currentAccount.citizenIdentityCardNumber!,
                          title: 'CMND hoặc CCCD',
                          readonly: true,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.nationality!.isEmpty ? 'Chưa cập nhật' : _currentAccount.nationality!,
                          title: 'Quốc tịch',
                          readonly: true,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.bankName!.isEmpty ? 'Chưa cập nhật' : _currentAccount.bankName!,
                          title: 'Tên ngân hàng',
                          readonly: true,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.bankAccountName!.isEmpty ? 'Chưa cập nhật' : _currentAccount.bankAccountName!,
                          title: 'Tên chủ tài khoản',
                          readonly: true,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.bankAccountNumber!.isEmpty ? 'Chưa cập nhật' : _currentAccount.bankAccountNumber!,
                          title: 'Số tài khoản',
                          readonly: true,
                      ),
                      const SizedBox(height: 20.0,),

                      CustomDropdownFormField2(
                        label: 'Giới tính',
                        hintText: _currentAccount.genderId != null ? Text(gendersUtilities[_currentAccount.genderId!]) : const Text('Chưa cập nhật'),
                        items: gendersUtilities,
                        onChanged: null
                      ),
                      const SizedBox(height: 20.0,),

                      //Ngày sinh
                      SizedBox(
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.only(left: 20.0),
                            labelText: 'Ngày sinh',
                            hintText: _currentAccount.dateOfBirth == null ? 'Chưa cập nhật' : 'Ngày ${DateFormat('dd-MM-yyyy').format(_currentAccount.dateOfBirth!)}',
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

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomEditableTextFormField(
                            text: _accountBlockId.text.isEmpty ? blockNameUtilities[_currentAccount.blockId!] : blockNameUtilities[int.parse(_accountBlockId.text)],
                            title: 'Khối',
                            readonly: true,
                            onTap: _readOnly != true ? () async {
                              final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminBlockFilter(),));
                              if (data != null) {
                                setState(() {
                                  _filterBlock = data;
                                  _accountBlockId.text = _filterBlock!.blockId.toString();
                                });
                              }
                            } : null,
                        ),
                      ),

                      if(_currentAccount.departmentId != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomEditableTextFormField(
                            text: _accountDepartmentId.text.isEmpty ? getDepartmentName(_currentAccount.departmentId!, _currentAccount.blockId) : getDepartmentName(int.parse(_accountDepartmentId.text), null),
                            title: 'Phòng ban',
                            readonly: true,
                            onTap: _readOnly != true ? () async {
                              final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDepartmentFilter(departmentList: getDepartmentListInBlock(block: _filterBlock!))));
                              if (data != null) {
                                setState(() {
                                  _filterDepartment = data;
                                  _accountDepartmentId.text = _filterDepartment!.departmentId.toString();
                                });
                              }
                            } : null,
                        ),
                      ),

                      if(_currentAccount.teamId != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomEditableTextFormField(
                            text: _accountTeamId.text.isEmpty ? getTeamName(_currentAccount.teamId!, _currentAccount.departmentId) : getTeamName(_filterTeam!.teamId, _filterTeam!.departmentId),
                            title: 'Nhóm',
                            readonly: true,
                            onTap: _readOnly != true ? () async {
                              final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminTeamFilter(teamList: getTeamListInDepartment(department: _filterDepartment!))));
                              if( data != null ){
                                setState(() {
                                  _filterTeam = data;
                                  _accountTeamId.text = _filterTeam!.teamId.toString();
                                });
                              }
                            } : null,
                        ),
                      ),

                      if(_currentAccount.roleId != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: CustomEditableTextFormField(
                            text: _accountRoleId.text.isEmpty ? rolesNameUtilities[_currentAccount.roleId!] : rolesNameUtilities[int.parse(_accountRoleId.text)],
                            title: 'Chức vụ',
                            readonly: true,
                            onTap: _readOnly != true ? () async {
                              final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminTeamFilter(teamList: getTeamListInDepartment(department: _filterDepartment!))));
                              if( data != null ){
                                setState(() {
                                  _filterRole = data;
                                  _accountRoleId.text = _filterRole!.roleId.toString();
                                });
                              }
                            } : null,
                          ),
                        ),

                      //Quyền quản lý thông tin khách hàng
                      if(_contactPermission != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomExpansionTile(
                            label: 'Quyền quản lý thông tin khách hàng',
                            colors: const [Colors.yellow, Colors.white],
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                                child: CustomDropdownFormField2(
                                    label: 'Tạo mới',
                                    hintText: Text(permissionStatusesNameUtilities[_contactPermission!.create]),
                                    items: saleEmpCreatePermNames,
                                    onChanged: null
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                child: CustomDropdownFormField2(
                                    label: 'Xem',
                                    hintText: Text(permissionStatusesNameUtilities[_contactPermission!.view]),
                                    items: saleEmpViewUpdateDeletePermNames,
                                    onChanged: null
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                child: CustomDropdownFormField2(
                                    label: 'Chỉnh sửa',
                                    hintText: Text(permissionStatusesNameUtilities[_contactPermission!.update]),
                                    items: saleEmpViewUpdateDeletePermNames,
                                    onChanged: null
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15.0),
                                child: CustomDropdownFormField2(
                                    label: 'Xóa',
                                    hintText: Text(permissionStatusesNameUtilities[_contactPermission!.delete]),
                                    items: saleEmpViewUpdateDeletePermNames,
                                    onChanged: null
                                ),
                              ),
                            ]
                        ),
                      ),

                      //Quyền quản lý họp đồng
                      if(_dealPermission != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: CustomExpansionTile(
                              label: 'Quyền quản lý hợp đồng',
                              colors: const [Colors.greenAccent, Colors.white],
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Tạo mới',
                                      hintText: Text(permissionStatusesNameUtilities[_dealPermission!.create]),
                                      items: saleEmpCreatePermNames,
                                      onChanged: null
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Xem',
                                      hintText: Text(permissionStatusesNameUtilities[_dealPermission!.view]),
                                      items: saleEmpViewUpdateDeletePermNames,
                                      onChanged: null
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Chỉnh sửa',
                                      hintText: Text(permissionStatusesNameUtilities[_dealPermission!.update]),
                                      items: saleEmpViewUpdateDeletePermNames,
                                      onChanged: null
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Xóa',
                                      hintText: Text(permissionStatusesNameUtilities[_dealPermission!.delete]),
                                      items: saleEmpViewUpdateDeletePermNames,
                                      onChanged: null
                                  ),
                                ),
                              ]
                          ),
                        ),

                      //Quyền quả lý vấn đề
                      if(_issuePermission != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomExpansionTile(
                              label: 'Quyền quản lý vấn đề',
                              colors: const [Colors.orange, Colors.white],
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Tạo mới',
                                      hintText: Text(permissionStatusesNameUtilities[_issuePermission!.create]),
                                      items: saleEmpCreatePermNames,
                                      onChanged: null
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Xem',
                                      hintText: Text(permissionStatusesNameUtilities[_issuePermission!.view]),
                                      items: saleEmpViewUpdateDeletePermNames,
                                      onChanged: null
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Chỉnh sửa',
                                      hintText: Text(permissionStatusesNameUtilities[_issuePermission!.update]),
                                      items: saleEmpViewUpdateDeletePermNames,
                                      onChanged: null
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Xóa',
                                      hintText: Text(permissionStatusesNameUtilities[_issuePermission!.delete]),
                                      items: saleEmpViewUpdateDeletePermNames,
                                      onChanged: null
                                  ),
                                ),
                              ]
                          ),
                      ),

                      //Quyền quả lý tài khoản nhân viên
                      if(_accountPermission != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: CustomExpansionTile(
                              label: 'Quyền quản lý tài khoản nhân viên',
                              colors: const [Colors.blue, Colors.white],
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15.0),
                                  child: CustomDropdownFormField2(
                                      label: 'Xem',
                                      hintText: Text(permissionStatusesNameUtilities[_accountPermission!.view]),
                                      items: saleEmpCreatePermNames,
                                      onChanged: null
                                  ),
                                ),
                              ]
                          ),
                        ),

                      //Quyền quả lý điểm danh
                      if(_attendancePermission != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: CustomExpansionTile(
                              label: 'Quyền quản lý điểm danh',
                              colors: const [Colors.blue, Colors.white],
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Xem',
                                      hintText: Text(permissionStatusesNameUtilities[_attendancePermission!.view]),
                                      items: saleEmpCreatePermNames,
                                      onChanged: null
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15.0),
                                  child: CustomDropdownFormField2(
                                      label: 'Chỉnh sủa',
                                      hintText: Text(permissionStatusesNameUtilities[_attendancePermission!.update]),
                                      items: saleEmpCreatePermNames,
                                      onChanged: null
                                  ),
                                ),
                              ]
                          ),
                        ),


                    ],
                  ) : const Center(child: CircularProgressIndicator())
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
                widget.account.fullname!,
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
    _getPermByPermId(permId: _currentAccount.permissionId!);
  }

  void _getPermByPermId({required int permId}) async {
    _permission = await PermissionViewModel().getPermByPermId(permId: permId);

    if(_permission!.accountPermissionId != null) _getAccountPermissionById(accountPermissionId: _permission!.accountPermissionId!);
    if(_permission!.attendancePermissionId != null) _getAttendancePermissionById(attendancePermissionId: _permission!.attendancePermissionId!);
    if(_permission!.payrollPermissionId != null) _getPayrollPermissionById(payrollPermissionId: _permission!.payrollPermissionId!);
    if(_permission!.contactPermissionId != null) _getContactPermissionById(contactPermissionId: _permission!.contactPermissionId!);
    if(_permission!.dealPermissionId != null) _getDealPermissionById(dealPermissionId: _permission!.dealPermissionId!);
    if(_permission!.issuePermissionId != null) _getIssuePermissionById(issuePermissionId: _permission!.issuePermissionId!);
  }

  void _getAccountPermissionById({required int accountPermissionId}) async {
    AccountPermission accountPermission = await PermissionViewModel().getAccountPermissionById(accountPermissionId: accountPermissionId);

    setState(() {
      _accountPermission = accountPermission;
    });
  }

  void _getAttendancePermissionById({required int attendancePermissionId}) async {
    AttendancePermission attendancePermission = await PermissionViewModel().getAttendancePermissionById(attendancePermissionId: attendancePermissionId);

    setState(() {
      _attendancePermission = attendancePermission;
    });
  }

  void _getPayrollPermissionById({required int payrollPermissionId}) async {
    PayrollPermission payrollPermission = await PermissionViewModel().getPayrollPermissionById(payrollPermissionId: payrollPermissionId);

    setState(() {
      _payrollPermission = payrollPermission;
    });
  }

  void _getContactPermissionById({required int contactPermissionId}) async {
    ContactPermission contactPermission = await PermissionViewModel().getContactPermissionById(contactPermissionId: contactPermissionId);

    setState(() {
      _contactPermission = contactPermission;
    });
  }

  void _getDealPermissionById({required int dealPermissionId}) async {
    DealPermission dealPermission = await PermissionViewModel().getDealPermissionById(dealPermissionId: dealPermissionId);

    setState(() {
      _dealPermission = dealPermission;
    });
  }

  void _getIssuePermissionById({required int issuePermissionId}) async {
    IssuePermission issuePermission = await PermissionViewModel().getIssuePermissionById(issuePermissionId: issuePermissionId);

    setState(() {
      _issuePermission = issuePermission;
    });
  }

}
