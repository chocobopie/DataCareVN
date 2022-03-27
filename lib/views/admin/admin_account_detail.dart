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
import 'package:login_sample/views/admin/admin_role_filter.dart';
import 'package:login_sample/views/admin/admin_team_filter.dart';
import 'package:login_sample/views/providers/account_provider.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomExpansionTile.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';
import 'package:provider/provider.dart';

class AdminAccountDetail extends StatefulWidget {
  const AdminAccountDetail({Key? key, required this.account}) : super(key: key);

  final Account account;

  @override
  State<AdminAccountDetail> createState() => _AdminAccountDetailState();
}

class _AdminAccountDetailState extends State<AdminAccountDetail> {

  String _departmentPermNameString = '', _departmentNameString = '' , _teamNameString = '', _roleNameString = '';
  String _contactCreateNew = '';

  bool _readOnly = true, _isExpand = false;
  late final Account _currentAccount = widget.account;

  Permission? _permission;
  AccountPermission? _accountPermission;
  AttendancePermission? _attendancePermission;
  PayrollPermission? _payrollPermission;
  ContactPermission? _contactPermission;
  DealPermission? _dealPermission;
  IssuePermission? _issuePermission;

  Block? _filterBlock;
  Department? _filterDepartment, _filterDepartmentPerm;
  Team? _filterTeam;
  Role? _filterRole;

  final TextEditingController _accountDepartmentId = TextEditingController();
  final TextEditingController _accountBlockId = TextEditingController();
  final TextEditingController _accountTeamId = TextEditingController();
  final TextEditingController _accountRoleId = TextEditingController();
  final TextEditingController _accountDepartmentIdPerm = TextEditingController();

  int? _contactCreateId, _contactViewId, _contactUpdateId, _contactDeleteId, _dealCreateId, _dealViewId, _dealUpdateId, _dealDeleteId, _issueCreateId, _issueViewId, _issueUpdateId, _issueDeleteId;
  int? _accountViewId, _attendanceViewId, _attendanceUpdateId;

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
                  child: _permission != null ? ListView(
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
                      
                      Row(
                        children: [
                          Expanded(
                            child: CustomEditableTextFormField(
                                text: _currentAccount.phoneNumber!.isEmpty ? 'Chưa cập nhật' : _currentAccount.phoneNumber!,
                                title: 'Số điện thoại',
                                readonly: true,
                            ),
                          ),
                          const SizedBox(width: 5.0,),
                          Expanded(
                            child: CustomEditableTextFormField(
                              text: _currentAccount.citizenIdentityCardNumber!.isEmpty ? 'Chưa cập nhật' : _currentAccount.citizenIdentityCardNumber!,
                              title: 'CMND hoặc CCCD',
                              readonly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),

                      CustomEditableTextFormField(
                          text: _currentAccount.address!.isEmpty ? 'Chưa cập nhật' : _currentAccount.address!,
                          title: 'Địa chỉ',
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

                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdownFormField2(
                              label: 'Giới tính',
                              hintText: _currentAccount.genderId != null ? Text(gendersUtilities[_currentAccount.genderId!]) : const Text('Chưa cập nhật'),
                              items: gendersUtilities,
                              onChanged: null
                            ),
                          ),
                          const SizedBox(width: 5.0,),
                          Expanded(
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomEditableTextFormField(
                            // borderColor: _currentAccount.roleId != 2 ? _readOnly != true ? mainBgColor : null : null,
                            text: _accountBlockId.text.isEmpty ? blockNameUtilities[_currentAccount.blockId!] : blockNameUtilities[int.parse(_accountBlockId.text)],
                            title: 'Khối',
                            readonly: true,
                            // onTap: _currentAccount.roleId != 2 ? _readOnly != true ? () async {
                            //   final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminBlockFilter(),));
                            //   if (data != null) {
                            //     setState(() {
                            //       _filterBlock = data;
                            //       _departmentNameString = '';
                            //       _teamNameString = '';
                            //       _filterDepartment = null;
                            //       _filterTeam = null;
                            //       _accountBlockId.text = _filterBlock!.blockId.toString();
                            //     });
                            //   }
                            // } : null : null,
                        ),
                      ),

                      if(_currentAccount.departmentId != null || _filterBlock != null)
                        if(getDepartmentListInBlock(block: _filterBlock == null ? getBlock(blockId: _currentAccount.blockId!) : _filterBlock!).isNotEmpty )
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        // _filterDepartment == null ? _currentAccount.departmentId == null ? _filterDepartment == null ? '' : _filterDepartment!.name : getDepartmentName( _currentAccount.departmentId!, null) : _filterDepartment!.name,
                        child: CustomEditableTextFormField(
                            borderColor: _readOnly != true ? mainBgColor : null,
                            text: _departmentNameString,
                            title: 'Phòng ban',
                            readonly: true,
                            onTap: _readOnly != true ? () async {
                              final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDepartmentFilter(
                                  departmentList: getDepartmentListInBlock(block: _filterBlock == null ? getBlock(blockId: _currentAccount.blockId!) : _filterBlock! )
                              )));
                              if (data != null) {
                                setState(() {
                                  _filterDepartment = data;
                                  _departmentNameString = _filterDepartment!.name;
                                  _teamNameString = '';
                                  _filterTeam = null;
                                  _accountDepartmentId.text = _filterDepartment!.departmentId.toString();
                                });
                              }
                            } : null,
                        ),
                      ),

                      if(_currentAccount.teamId != null || _filterDepartment != null || _filterRole != null)
                        if(_filterRole?.roleId == 4 || _filterRole?.roleId == 5 || _currentAccount.roleId == 4 || _currentAccount.roleId == 5)
                        if(  getDepartmentListInBlock(block: _filterBlock == null ? getBlock(blockId: _currentAccount.blockId!) : _filterBlock!).isNotEmpty  )
                        if(  getTeamListInDepartment(department: _filterDepartment == null ? getDepartment(departmentId: _currentAccount.departmentId!) : _filterDepartment! ).isNotEmpty  )
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        // _filterTeam == null ? _currentAccount.teamId == null ? _accountTeamId.text.isEmpty ? '' : getTeamName(_filterTeam!.teamId, _filterTeam!.departmentId) : getTeamName(_currentAccount.teamId!, _currentAccount.departmentId) : _filterTeam!.name,
                        child: CustomEditableTextFormField(
                            borderColor: _currentAccount.roleId != 2 ? _readOnly != true ? mainBgColor : null : null,
                            text: _teamNameString,
                            title: 'Nhóm',
                            readonly: true,
                            onTap: _currentAccount.roleId != 2 ? _readOnly != true ? () async {
                              final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminTeamFilter(
                                  teamList: getTeamListInDepartment(department: _filterDepartment == null ? getDepartment(departmentId: _currentAccount.departmentId!) : _filterDepartment!) )
                              ));
                              if( data != null ){
                                setState(() {
                                  _filterTeam = data;
                                  _teamNameString = _filterTeam!.name;
                                  _accountTeamId.text = _filterTeam!.teamId.toString();
                                });
                              }
                            } : null : null,
                        ),
                      ),

                      if(_currentAccount.roleId != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: CustomEditableTextFormField(
                            borderColor: (_currentAccount.roleId != 2 && _currentAccount.roleId != 6) ? _readOnly != true ? mainBgColor : null : null,
                            text: _accountRoleId.text.isEmpty ? rolesNameUtilities[_currentAccount.roleId!] : rolesNameUtilities[int.parse(_accountRoleId.text)],
                            title: 'Chức vụ',
                            readonly: true,
                            onTap: (_currentAccount.roleId != 2 && _currentAccount.roleId != 6) ? _readOnly != true ? () async {
                              final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminRoleFilter(isAccountDetailFilter: true,) ));
                              if( data != null ){
                                setState(() {
                                  _filterRole = data;
                                  _accountRoleId.text = _filterRole!.roleId.toString();
                                  print(_filterRole!.name);
                                });
                              }
                            } : null : null,
                          ),
                        ),

                      //Quyền quản lý thông tin khách hàng
                      if(_currentAccount.roleId == 3 || _currentAccount.roleId == 4 || _currentAccount.roleId == 5 )
                       Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomExpansionTile(
                            isExpand: _isExpand,
                            label: 'Quyền quản lý thông tin khách hàng',
                            colors: const [Colors.yellow, Colors.white],
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                                child: CustomDropdownFormField2(
                                    label: 'Tạo mới',
                                    hintText: _contactPermission != null ? Text(permissionStatusesNameUtilities[_contactCreateId == null ? _contactPermission!.create : _contactCreateId!]) : const Text(''),
                                    items: saleEmpCreatePermNames,
                                    onChanged: _readOnly != true ? (value){
                                      for(int i = 0; i < permissionStatuses.length; i++){
                                        if(value.toString() == permissionStatuses[i].name){
                                          setState(() {
                                            _contactCreateId = permissionStatuses[i].permissionStatusId;
                                            print(_contactCreateId);
                                          });
                                        }
                                      }
                                    } : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                child: CustomDropdownFormField2(
                                    label: 'Xem',
                                    hintText: _contactPermission != null ? Text(permissionStatusesNameUtilities[_contactViewId == null ? _contactPermission!.view : _contactViewId!]) : const Text(''),
                                    items: saleEmpViewPermNames,
                                    onChanged: _readOnly != true ? (value){
                                      for(int i = 0; i < permissionStatuses.length; i++){
                                        if(value.toString() == permissionStatuses[i].name){
                                          setState(() {
                                            _contactViewId = permissionStatuses[i].permissionStatusId;
                                          });
                                        }
                                      }
                                    } : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                child: CustomDropdownFormField2(
                                    label: 'Chỉnh sửa',
                                    hintText: _contactPermission != null ? Text(permissionStatusesNameUtilities[_contactUpdateId == null ? _contactPermission!.update : _contactUpdateId!]) : const Text(''),
                                    items: saleEmpUpdateDeletePermNames,
                                    onChanged: _readOnly != true ? (value){
                                      for(int i = 0; i < permissionStatuses.length; i++){
                                        if(value.toString() == permissionStatuses[i].name){
                                          setState(() {
                                            _contactUpdateId = permissionStatuses[i].permissionStatusId;
                                          });
                                        }
                                      }
                                    } : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15.0),
                                child: CustomDropdownFormField2(
                                    label: 'Xóa',
                                    hintText: _contactPermission != null ? Text(permissionStatusesNameUtilities[_contactDeleteId == null ? _contactPermission!.delete : _contactDeleteId!]) : const Text(''),
                                    items: saleEmpUpdateDeletePermNames,
                                    onChanged: _readOnly != true ? (value){
                                      for(int i = 0; i < permissionStatuses.length; i++){
                                        if(value.toString() == permissionStatuses[i].name){
                                          setState(() {
                                            _contactDeleteId = permissionStatuses[i].permissionStatusId;
                                          });
                                        }
                                      }
                                    } : null,
                                ),
                              ),
                            ]
                        ),
                      ),

                      //Quyền quản lý họp đồng
                      if(_currentAccount.roleId == 3 || _currentAccount.roleId == 4 || _currentAccount.roleId == 5 )
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
                                      hintText: _dealPermission != null ? Text(permissionStatusesNameUtilities[_dealCreateId == null ? _dealPermission!.create : _dealCreateId!]) : const Text(''),
                                      items: saleEmpCreatePermNames,
                                      onChanged: _readOnly != true ? (value){
                                        for(int i = 0; i < permissionStatuses.length; i++){
                                          if(value.toString() == permissionStatuses[i].name){
                                            setState(() {
                                              _dealCreateId = permissionStatuses[i].permissionStatusId;
                                            });
                                          }
                                        }
                                      } : null,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Xem',
                                      hintText: _dealPermission != null ? Text(permissionStatusesNameUtilities[_dealViewId == null ? _dealPermission!.view : _dealViewId!]) : const Text(''),
                                      items: saleEmpViewPermNames,
                                      onChanged: _readOnly != true ? (value){
                                        for(int i = 0; i < permissionStatuses.length; i++){
                                          if(value.toString() == permissionStatuses[i].name){
                                            setState(() {
                                              _dealViewId = permissionStatuses[i].permissionStatusId;
                                            });
                                          }
                                        }
                                      } : null,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Chỉnh sửa',
                                      hintText: _dealPermission != null ? Text(permissionStatusesNameUtilities[_dealUpdateId == null ?_dealPermission!.update : _dealUpdateId!]) : const Text(''),
                                      items: saleEmpUpdateDeletePermNames,
                                      onChanged: _readOnly != true ? (value){
                                        for(int i = 0; i < permissionStatuses.length; i++){
                                          if(value.toString() == permissionStatuses[i].name){
                                            setState(() {
                                              _dealUpdateId = permissionStatuses[i].permissionStatusId;
                                            });
                                          }
                                        }
                                      } : null,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Xóa',
                                      hintText: _dealPermission != null ? Text(permissionStatusesNameUtilities[_dealDeleteId == null ?_dealPermission!.delete : _dealDeleteId!]) : const Text(''),
                                      items: saleEmpUpdateDeletePermNames,
                                      onChanged: _readOnly != true ? (value){
                                        for(int i = 0; i < permissionStatuses.length; i++){
                                          if(value.toString() == permissionStatuses[i].name){
                                            setState(() {
                                              _dealDeleteId = permissionStatuses[i].permissionStatusId;
                                            });
                                          }
                                        }
                                      } : null,
                                  ),
                                ),
                              ]
                          ),
                        ),

                      //Quyền quả lý vấn đề
                      if(_currentAccount.roleId == 3 || _currentAccount.roleId == 4 || _currentAccount.roleId == 5 || _currentAccount.roleId == 6)
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
                                      hintText: _issuePermission != null ? Text(permissionStatusesNameUtilities[_issueCreateId == null ? _issuePermission!.create : _issueCreateId!]) : const Text(''),
                                      items: saleEmpCreatePermNames,
                                      onChanged: _readOnly != true ? (value){
                                        for(int i = 0; i < permissionStatuses.length; i++){
                                          if(value.toString() == permissionStatuses[i].name){
                                            setState(() {
                                              _issueCreateId = permissionStatuses[i].permissionStatusId;
                                            });
                                          }
                                        }
                                      } : null,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Xem',
                                      hintText: _issuePermission != null ? Text(permissionStatusesNameUtilities[_issueViewId == null ? _issuePermission!.view : _issueViewId!]) : const Text(''),
                                      items: saleEmpViewPermNames,
                                      onChanged: _readOnly != true ? (value){
                                        for(int i = 0; i < permissionStatuses.length; i++){
                                          if(value.toString() == permissionStatuses[i].name){
                                            setState(() {
                                              _issueViewId = permissionStatuses[i].permissionStatusId;
                                            });
                                          }
                                        }
                                      } : null,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Chỉnh sửa',
                                      hintText: _issuePermission != null ? Text(permissionStatusesNameUtilities[_issueUpdateId == null ? _issuePermission!.update : _issueUpdateId!]) : const Text(''),
                                      items: saleEmpUpdateDeletePermNames,
                                      onChanged: _readOnly != true ? (value){
                                        for(int i = 0; i < permissionStatuses.length; i++){
                                          if(value.toString() == permissionStatuses[i].name){
                                            setState(() {
                                              _issueUpdateId = permissionStatuses[i].permissionStatusId;
                                            });
                                          }
                                        }
                                      } : null,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Xóa',
                                      hintText: _issuePermission != null ? Text(permissionStatusesNameUtilities[_issueDeleteId == null ? _issuePermission!.delete : _issueDeleteId!]) : const Text(''),
                                      items: saleEmpUpdateDeletePermNames,
                                      onChanged: _readOnly != true ? (value){
                                        for(int i = 0; i < permissionStatuses.length; i++){
                                          if(value.toString() == permissionStatuses[i].name){
                                            setState(() {
                                              _issueDeleteId = permissionStatuses[i].permissionStatusId;
                                            });
                                          }
                                        }
                                      } : null,
                                  ),
                                ),
                              ]
                          ),
                      ),

                      //Quyền quả lý tài khoản nhân viên
                      if(_currentAccount.roleId == 2)
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
                                      hintText: _accountPermission != null ? Text(permissionStatusesNameUtilities[_accountViewId == null ? _accountPermission!.view : _accountViewId!]) : const Text(''),
                                      items: hrInternViewUpdate,
                                      onChanged: _readOnly != true ? (value){
                                        for(int i = 0; i < permissionStatuses.length; i++){
                                          if(value.toString() == permissionStatuses[i].name){
                                            setState(() {
                                              _accountViewId = permissionStatuses[i].permissionStatusId;
                                            });
                                          }
                                        }
                                      } : null,
                                  ),
                                ),
                              ]
                          ),
                        ),

                      //Quyền quả lý điểm danh
                      if(_currentAccount.roleId == 2)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: CustomExpansionTile(
                              label: 'Quyền quản lý điểm danh',
                              colors: const [Colors.green, Colors.white],
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                                  child: CustomDropdownFormField2(
                                      label: 'Xem',
                                      hintText: _attendancePermission != null ? Text(permissionStatusesNameUtilities[_attendanceViewId == null ? _attendancePermission!.view : _attendanceViewId!]) : const Text(''),
                                      items: hrInternViewUpdate,
                                      onChanged: _readOnly != true ? (value){
                                        for(int i = 0; i < permissionStatuses.length; i++){
                                          if(value.toString() == permissionStatuses[i].name){
                                            setState(() {
                                              _attendanceViewId = permissionStatuses[i].permissionStatusId;
                                            });
                                          }
                                        }
                                      } : null,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15.0),
                                  child: CustomDropdownFormField2(
                                      label: 'Chỉnh sủa',
                                      hintText: _attendancePermission != null ? Text(permissionStatusesNameUtilities[_attendanceUpdateId == null ? _attendancePermission!.update : _attendanceUpdateId!]) : const Text(''),
                                      items: hrInternViewUpdate,
                                      onChanged: _readOnly != true ? (value){
                                        for(int i = 0; i < permissionStatuses.length; i++){
                                          if(value.toString() == permissionStatuses[i].name){
                                            setState(() {
                                              _attendanceUpdateId = permissionStatuses[i].permissionStatusId;
                                            });
                                          }
                                        }
                                      } : null,
                                  ),
                                ),
                              ]
                          ),
                        ),

                      if(_currentAccount.roleId == 2)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomEditableTextFormField(
                            borderColor: _readOnly != true ? mainBgColor : null,
                            text: _departmentNameString,
                            title: 'Quản lý phòng ban',
                            readonly: true,
                            onTap: _readOnly != true ? () async {
                              final data = await Navigator.push(context, MaterialPageRoute(
                                builder: (context) => AdminDepartmentFilter(departmentList: departments),
                              ));
                              if(data != null){
                                _filterDepartmentPerm = data;
                                setState(() {
                                  _departmentNameString = _filterDepartmentPerm!.name;
                                });
                              }
                            } : null,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          if(_readOnly == false)
                            Expanded(child: CustomTextButton(
                                color: Colors.deepPurple,
                                text: 'Hủy',
                                 onPressed: (){
                                  _getOverallInfo();
                                    setState(() {
                                      _isExpand = false;
                                      _filterRole = null;
                                      _filterDepartmentPerm = null;
                                      _filterDepartment = null;
                                      _filterRole = null;
                                      _filterTeam = null;
                                      _contactCreateId = null; _contactViewId = null; _contactUpdateId = null; _contactDeleteId = null;
                                      _dealCreateId = null; _dealViewId = null; _dealUpdateId = null; _dealDeleteId = null;
                                      _issueCreateId = null; _issueViewId = null; _issueUpdateId = null; _issueDeleteId = null;
                                      _accountViewId = null; _attendanceViewId = null; _attendanceUpdateId = null;
                                      _readOnly = true;
                                    });

                                  },
                            )),

                          const SizedBox(width: 5.0,),
                          Expanded(
                            child: CustomTextButton(
                                color: Colors.blueAccent,
                                text: _readOnly == true ? 'Chỉnh sửa' : 'Lưu',
                                onPressed: (){
                                  if(_readOnly == false){

                                    if(_contactPermission != null && _dealPermission != null && _issuePermission != null){
                                      _updateSaleEmpPermission();
                                    }

                                    if(_accountPermission != null && _attendancePermission != null){
                                      _updateHrInternPermission();
                                    }

                                    Future.delayed(const Duration(seconds: 2), (){
                                      Navigator.pop(context);
                                    });
                                  }
                                  if(_readOnly == true) setState(() {_readOnly = false;});
                                },
                            ),
                          ),
                        ],
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
    if(_currentAccount.departmentId != null) _departmentNameString = getDepartmentName(_currentAccount.departmentId!, null);
    if(_currentAccount.teamId != null) _teamNameString = getTeamName(_currentAccount.teamId!, _currentAccount.departmentId!);
    if(_permission?.departmentId != null) {
      _departmentPermNameString = getDepartmentName( _permission!.departmentId!, null);
      print('Perm department id =: ${_permission!.departmentId!}');
    }
  }

  //Create perm
  void _createSaleEmpPerm(){
    ContactPermission contactPermission = ContactPermission(
      create: _contactCreateId!,
      view: _contactViewId!,
      update: _contactUpdateId!,
      delete: _contactDeleteId!,
    );
    DealPermission dealPermission = DealPermission(
        create: _dealCreateId!,
        view: _dealViewId!,
        update: _dealUpdateId!,
        delete: _dealDeleteId!
    );
    IssuePermission issuePermission = IssuePermission(
        create: _issueCreateId!,
        view: _issueViewId!,
        update: _issueUpdateId!,
        delete: _issueDeleteId!
    );
    PermissionViewModel().createContactPermission(contactPermission: contactPermission);
    PermissionViewModel().createDealPermission(dealPermission: dealPermission);
    PermissionViewModel().createIssuePermission(issuePermission: issuePermission);
  }
  void _createHrPerm(){
    AccountPermission accountPermission = AccountPermission(
      view: _accountViewId!,
    );

    AttendancePermission attendancePermission = AttendancePermission(
        view: _attendanceViewId!,
        update: _attendanceUpdateId!
    );

    PermissionViewModel().updateAccountPermission(accountPermission: accountPermission);
    PermissionViewModel().updateAttendancePermission(attendancePermission: attendancePermission);
  }

  //Update perm
  void _updateSaleEmpPermission(){
    ContactPermission contactPermission = ContactPermission(
      contactPermissionId:_contactPermission!.contactPermissionId,
      create: _contactCreateId == null ? _contactPermission!.create : _contactCreateId!,
      view: _contactViewId == null ? _contactPermission!.view : _contactViewId!,
      update: _contactUpdateId == null ? _contactPermission!.update : _contactUpdateId!,
      delete: _contactDeleteId == null ? _contactPermission!.delete : _contactDeleteId!,
    );

    DealPermission dealPermission = DealPermission(
        dealPermissionId: _dealPermission!.dealPermissionId,
        create: _dealCreateId == null ? _dealPermission!.create : _dealCreateId!,
        view: _dealViewId == null ? _dealPermission!.view : _dealViewId!,
        update: _dealUpdateId == null ? _dealPermission!.update : _dealUpdateId!,
        delete: _dealDeleteId == null ? _dealPermission!.delete : _dealDeleteId!
    );

    IssuePermission issuePermission = IssuePermission(
        issuePermissionId: _issuePermission!.issuePermissionId,
        create: _issueCreateId == null ? _issuePermission!.create : _issueCreateId!,
        view: _issueViewId == null ? _issuePermission!.view : _issueViewId!,
        update: _issueUpdateId == null ? _issuePermission!.update : _issueUpdateId!,
        delete: _issueDeleteId == null ? _issuePermission!.delete : _issueDeleteId!
    );

    PermissionViewModel().updateContactPermission(contactPermission: contactPermission);
    PermissionViewModel().updateDealPermission(dealPermission: dealPermission);
    PermissionViewModel().updateIssuePermission(issuePermission: issuePermission);
  }
  void _updateHrInternPermission(){
    AccountPermission accountPermission = AccountPermission(
        accountPermissionId: _accountPermission!.accountPermissionId,
        view: _accountViewId == null ? _accountPermission!.view : _accountViewId!,
    );

    AttendancePermission attendancePermission = AttendancePermission(
        attendancePermissionId: _attendancePermission!.attendancePermissionId,
        view: _attendanceViewId == null ? _attendancePermission!.view : _attendanceViewId!,
        update: _attendanceUpdateId == null ? _attendancePermission!.update : _attendanceUpdateId!
    );

    PermissionViewModel().updateAccountPermission(accountPermission: accountPermission);
    PermissionViewModel().updateAttendancePermission(attendancePermission: attendancePermission);
  }

  //Get perm
  void _getPermByPermId({required int permId}) async {
    _permission = await PermissionViewModel().getPermByPermId(permId: permId);

    if(_permission!.accountPermissionId != null) _getAccountPermissionById(accountPermissionId: _permission!.accountPermissionId!);
    if(_permission!.attendancePermissionId != null) _getAttendancePermissionById(attendancePermissionId: _permission!.attendancePermissionId!);
    // if(_permission!.payrollPermissionId != null) _getPayrollPermissionById(payrollPermissionId: _permission!.payrollPermissionId!);
    if(_permission!.contactPermissionId != null) _getContactPermissionById(contactPermissionId: _permission!.contactPermissionId!);
    if(_permission!.dealPermissionId != null) _getDealPermissionById(dealPermissionId: _permission!.dealPermissionId!);
    if(_permission!.issuePermissionId != null) _getIssuePermissionById(issuePermissionId: _permission!.issuePermissionId!);
  }
  void _getAccountPermissionById({required int accountPermissionId}) async {
    AccountPermission? accountPermission = await PermissionViewModel().getAccountPermissionById(accountPermissionId: accountPermissionId);

    setState(() {
      _accountPermission = accountPermission;
    });
  }
  void _getAttendancePermissionById({required int attendancePermissionId}) async {
    AttendancePermission? attendancePermission = await PermissionViewModel().getAttendancePermissionById(attendancePermissionId: attendancePermissionId);

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
    ContactPermission? contactPermission = await PermissionViewModel().getContactPermissionById(contactPermissionId: contactPermissionId);

    setState(() {
      _contactPermission = contactPermission;
    });
  }
  void _getDealPermissionById({required int dealPermissionId}) async {
    DealPermission? dealPermission = await PermissionViewModel().getDealPermissionById(dealPermissionId: dealPermissionId);

    setState(() {
      _dealPermission = dealPermission;
    });
  }
  void _getIssuePermissionById({required int issuePermissionId}) async {
    IssuePermission? issuePermission = await PermissionViewModel().getIssuePermissionById(issuePermissionId: issuePermissionId);

    setState(() {
      _issuePermission = issuePermission;
    });
  }

}
