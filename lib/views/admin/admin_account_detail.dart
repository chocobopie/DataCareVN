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
import 'package:login_sample/view_models/account_view_model.dart';
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

  String _departmentPermNameString = '', _departmentNameString = '' , _teamNameString = '', _teamPermNameString = '';

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _readOnly = true, _isExpand = false;
  late final Account _currentEmpAccount = widget.account;
  late Account _currentAccount;

  Permission? _permission;
  AccountPermission? _accountPermission;
  AttendancePermission? _attendancePermission;
  PayrollPermission? _payrollPermission;
  ContactPermission? _contactPermission;
  DealPermission? _dealPermission;
  IssuePermission? _issuePermission;

  Block? _filterBlock;
  Department? _filterDepartment, _filterDepartmentPerm;
  Team? _filterTeam, _filterTeamPerm;
  Role? _filterRole;

  final TextEditingController _accountDepartmentId = TextEditingController();
  final TextEditingController _accountBlockId = TextEditingController();
  final TextEditingController _accountTeamId = TextEditingController();
  final TextEditingController _accountRoleId = TextEditingController();

  final TextEditingController _empName = TextEditingController();
  final TextEditingController _empPhoneNumber = TextEditingController();
  final TextEditingController _empCitizenIdentityCardNumber = TextEditingController();
  final TextEditingController _empAddress = TextEditingController();
  final TextEditingController _empNationality = TextEditingController();
  final TextEditingController _empBankName = TextEditingController();
  final TextEditingController _empBankAccountOwnerName = TextEditingController();
  final TextEditingController _empBankAccountNumber = TextEditingController();
  int? genderId;
  DateTime? _empDob;
  String _dob = '';


  int? _contactCreateId, _contactViewId, _contactUpdateId, _contactDeleteId, _dealCreateId, _dealViewId, _dealUpdateId, _dealDeleteId, _issueCreateId, _issueViewId, _issueUpdateId, _issueDeleteId;
  int? _accountViewId, _attendanceViewId, _attendanceUpdateId;
  int? _filterViewId;


  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _getOverallInfo();
    _filterRole = getRole(roleId: _currentEmpAccount.roleId!);
    if(_currentEmpAccount.dateOfBirth != null) _dob = 'Ngày ${DateFormat('dd-MM-yyyy').format(_currentEmpAccount.dateOfBirth!)}';
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
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 90.0),
              child: (_filterRole != null && _permission != null ) ?  SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                    text: _currentEmpAccount.email == null ? 'Chưa cập nhật' : _currentEmpAccount.email!,
                                    title: 'Email',
                                    readonly: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),


                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                    isLimit: true,
                                    limitNumbChar: 50,
                                    inputNumberOnly: false,
                                    borderColor: _readOnly == true ? null : mainBgColor,
                                    text: _empName.text.isEmpty ? _currentEmpAccount.fullname == null ? '' : _currentEmpAccount.fullname! : _empName.text,
                                    title: 'Họ và tên',
                                    readonly: _readOnly,
                                    textEditingController: _empName,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),

                          Row(
                            children: [
                              Expanded(
                                child: CustomDropdownFormField2(
                                    borderColor: _readOnly == true ? null : mainBgColor,
                                    value: _currentEmpAccount.genderId != null ? gendersNames[_currentEmpAccount.genderId!] : null,
                                    label: 'Giới tính',
                                    hintText: _currentEmpAccount.genderId != null ? Text(gendersNames[_currentEmpAccount.genderId!]) : const Text('Chưa cập nhật'),
                                    items: gendersNames,
                                    onChanged: _readOnly != true ? (value){
                                      for(int i = 0; i < genders.length; i++){
                                        if(value.toString() == genders[i].name){
                                          setState(() {
                                            _currentEmpAccount.genderId = genders[i].genderId;
                                          });
                                        }
                                      }
                                    } : null
                                ),
                              ),
                              const SizedBox(width: 5.0,),
                              Expanded(
                                child: CustomEditableTextFormField(
                                  borderColor: _readOnly == true ? null : mainBgColor,
                                  text: _dob,
                                  title: 'Ngày sinh',
                                  readonly: true,
                                  onTap: _readOnly != true ? () async {
                                    final date = await DatePicker.showDatePicker(context,
                                      locale : LocaleType.vi,
                                      minTime: DateTime.now().subtract(const Duration(days: 36500)),
                                      currentTime: DateTime.now(),
                                      maxTime: DateTime.now(),
                                    );
                                    if(date != null){
                                      _empDob = date;
                                      setState(() {
                                        _dob = 'Ngày ${DateFormat('dd-MM-yyyy').format(_empDob!)}';
                                      });
                                    }
                                  } : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),

                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                    borderColor: _readOnly == true ? null : mainBgColor,
                                    text: _empPhoneNumber.text.isEmpty ? _currentEmpAccount.phoneNumber == null ? '' : _currentEmpAccount.phoneNumber!  : _empPhoneNumber.text,
                                    title: 'Số điện thoại',
                                    readonly: _readOnly,
                                    textEditingController: _empPhoneNumber,
                                    inputNumberOnly: true,
                                    isPhoneNumber: true,
                                ),
                              ),
                              const SizedBox(width: 5.0,),
                              Expanded(
                                child: CustomEditableTextFormField(
                                  borderColor: _readOnly == true ? null : mainBgColor,
                                  text: _empCitizenIdentityCardNumber.text.isEmpty ? _currentEmpAccount.citizenIdentityCardNumber == null ? '' : _currentEmpAccount.citizenIdentityCardNumber! : _empCitizenIdentityCardNumber.text,
                                  title: 'CMND hoặc CCCD',
                                  readonly: _readOnly,
                                  textEditingController: _empCitizenIdentityCardNumber,
                                  citizenIdentity: true,
                                  inputNumberOnly: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),


                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                  borderColor: _readOnly == true ? null : mainBgColor,
                                    text: _empAddress.text.isEmpty ? _currentEmpAccount.address == null ? '' : _currentEmpAccount.address! : _empAddress.text,
                                    title: 'Địa chỉ',
                                    readonly: _readOnly,
                                    textEditingController: _empAddress,
                                    isLimit: true,
                                    limitNumbChar: 250,
                                    inputNumberOnly: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),


                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                  borderColor: _readOnly == true ? null : mainBgColor,
                                    text: _empNationality.text.isEmpty ? _currentEmpAccount.nationality == null ? '' : _currentEmpAccount.nationality! : _empNationality.text,
                                    title: 'Quốc tịch',
                                    readonly: _readOnly,
                                    textEditingController: _empNationality,
                                    isLimit: true,
                                    limitNumbChar: 60,
                                    inputNumberOnly: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),


                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                  borderColor: _readOnly == true ? null : mainBgColor,
                                    text: _empBankName.text.isEmpty ? _currentEmpAccount.bankName == null ? '' : _currentEmpAccount.bankName! : _empBankName.text,
                                    title: 'Tên ngân hàng',
                                    readonly: _readOnly,
                                    textEditingController: _empBankName,
                                    isLimit: true,
                                    limitNumbChar: 70,
                                    inputNumberOnly: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),


                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                  borderColor: _readOnly == true ? null : mainBgColor,
                                    text: _empBankAccountOwnerName.text.isEmpty ? _currentEmpAccount.bankAccountName == null ? '' : _currentEmpAccount.bankAccountName! : _empBankAccountOwnerName.text,
                                    title: 'Tên chủ tài khoản ngân hàng',
                                    readonly: _readOnly,
                                    textEditingController: _empBankAccountOwnerName,
                                    isLimit: true,
                                    inputNumberOnly: false,
                                    limitNumbChar: 50,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),


                          Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                    borderColor: _readOnly == true ? null : mainBgColor,
                                    text: _empBankAccountNumber.text.isEmpty ? _currentEmpAccount.bankAccountNumber == null ? '' : _currentEmpAccount.bankAccountNumber! : _empBankAccountNumber.text,
                                    title: 'Số tài khoản ngân hàng',
                                    readonly: _readOnly,
                                    textEditingController: _empBankAccountNumber,
                                    inputNumberOnly: true,
                                    isBankAccountNumber: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0,),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomEditableTextFormField(
                                      text: _accountBlockId.text.isEmpty ? blockNames[_currentEmpAccount.blockId!] : blockNames[int.parse(_accountBlockId.text)],
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
                              ],
                            ),
                          ),

                          if(_currentEmpAccount.departmentId != null || _filterBlock != null)
                            if(getDepartmentListInBlock(block: _filterBlock == null ? getBlock(blockId: _currentEmpAccount.blockId!) : _filterBlock!).isNotEmpty )
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            // _filterDepartment == null ? _currentAccount.departmentId == null ? _filterDepartment == null ? '' : _filterDepartment!.name : getDepartmentName( _currentAccount.departmentId!, null) : _filterDepartment!.name,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomEditableTextFormField(
                                      borderColor: _readOnly != true ? mainBgColor : null,
                                      text: _departmentNameString,
                                      title: 'Phòng ban',
                                      readonly: true,
                                      onTap: _readOnly != true ? () async {
                                        final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDepartmentFilter(
                                            departmentList: getDepartmentListInBlock(block: _filterBlock == null ? getBlock(blockId: _currentEmpAccount.blockId!) : _filterBlock! )
                                        )));
                                        if (data != null) {
                                          setState(() {
                                            _filterDepartment = data;
                                            _departmentNameString = _filterDepartment!.name;
                                            _teamNameString = '';
                                            _filterTeam = null;
                                            _accountDepartmentId.text = _filterDepartment!.departmentId.toString();
                                            print(_filterDepartment!.departmentId);
                                          });
                                        }
                                      } : null,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if(_currentEmpAccount.teamId != null || _filterDepartment != null || _filterRole != null)
                            if(_filterRole!.roleId == 4 || _filterRole!.roleId == 5)
                            if(  getDepartmentListInBlock(block: _filterBlock == null ? getBlock(blockId: _currentEmpAccount.blockId!) : _filterBlock!).isNotEmpty  )
                            if(  getTeamListInDepartment(department: _filterDepartment == null ? getDepartment(departmentId: _currentEmpAccount.departmentId!) : _filterDepartment! ).isNotEmpty  )
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomEditableTextFormField(
                                      borderColor: _currentEmpAccount.roleId != 2 ? _readOnly != true ? mainBgColor : null : null,
                                      text: _teamNameString,
                                      title: 'Nhóm',
                                      readonly: true,
                                      onTap: _currentEmpAccount.roleId != 2 ? _readOnly != true ? () async {
                                        final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminTeamFilter(
                                            teamList: getTeamListInDepartment(department: _filterDepartment == null ? getDepartment(departmentId: _currentEmpAccount.departmentId!) : _filterDepartment!) )
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
                              ],
                            ),
                          ),

                          if(_currentEmpAccount.roleId != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomEditableTextFormField(
                                      borderColor: (_currentEmpAccount.roleId != 2 && _currentEmpAccount.roleId != 6 && _currentEmpAccount.roleId != 1) ? _readOnly != true ? mainBgColor : null : null,
                                      text: _accountRoleId.text.isEmpty ? rolesNames[_currentEmpAccount.roleId!] : rolesNames[int.parse(_accountRoleId.text)],
                                      title: 'Chức vụ',
                                      readonly: true,
                                      onTap: (_currentEmpAccount.roleId != 2 && _currentEmpAccount.roleId != 6 && _currentEmpAccount.roleId != 1) ? _readOnly != true ? () async {
                                        final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminRoleFilter(isAccountDetailFilter: true,) ));
                                        if( data != null ){
                                          setState(() {
                                            _filterRole = data;
                                            _accountRoleId.text = _filterRole!.roleId.toString();
                                            if(_filterRole!.roleId == 3){
                                              _filterViewId = 4;
                                              _contactCreateId = _dealCreateId = _issueCreateId = 1;
                                              _contactDeleteId = _contactUpdateId = _dealDeleteId = _dealUpdateId = _issueDeleteId = _issueUpdateId = _filterViewId;
                                            }
                                            if(_filterRole!.roleId == 4){
                                              _filterViewId = 3;
                                              _contactCreateId = _dealCreateId = _issueCreateId = 1;
                                              _contactDeleteId = _contactUpdateId = _dealDeleteId = _dealUpdateId = _issueDeleteId = _issueUpdateId = _filterViewId;
                                            }
                                            if(_filterRole!.roleId == 5){
                                              _filterViewId = 2;
                                              _contactCreateId = _dealCreateId = _issueCreateId = 1;
                                              _contactDeleteId = _contactUpdateId = _dealDeleteId = _dealUpdateId = _issueDeleteId = _issueUpdateId = _filterViewId;
                                            }
                                          });
                                          _contactViewId = _dealViewId = _issueViewId = _filterViewId;
                                          print(_filterRole!.name);
                                        }
                                      } : null : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if(_currentEmpAccount.roleId == 3 || _currentEmpAccount.roleId == 4 || _currentEmpAccount.roleId == 5 || _currentEmpAccount.roleId == 6)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: CustomExpansionTile(
                                isExpand: _isExpand,
                                label: 'Quyền xem thông tin khách hàng & hợp đồng & vấn đề',
                                colors: const [Colors.red, Colors.white],
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0, left: 15, right: 15, bottom: 10.0),
                                    child: CustomDropdownFormField2(
                                        value: _filterViewId != null ? permissionStatusesNames[_filterViewId!] : null,
                                        label: 'Xem',
                                        hintText: _filterViewId != null ? Text( permissionStatusesNames[_filterViewId!] ) : const Text(''),
                                        items: saleEmpViewPermNames,
                                        onChanged:  (_filterRole?.roleId != 3 && _filterRole?.roleId != 6) ? _readOnly != true ? (value) async {
                                          for(int i = 0; i < permissionStatuses.length; i++){
                                            if(value.toString() == permissionStatuses[i].name){
                                              setState(() {
                                                _filterViewId = permissionStatuses[i].permissionStatusId;


                                                if(_contactUpdateId != null){if(_contactUpdateId! > _filterViewId!){
                                                    _contactUpdateId = _filterViewId!;
                                                }}
                                                if(_contactDeleteId != null){if(_contactDeleteId! > _filterViewId!){
                                                  _contactDeleteId = _filterViewId!;
                                                }}

                                                if(_dealUpdateId != null){if(_dealUpdateId! > _filterViewId!){
                                                  _dealUpdateId = _filterViewId!;
                                                }}
                                                if(_dealDeleteId != null){if(_dealDeleteId! > _filterViewId!){
                                                  _dealDeleteId = _filterViewId!;
                                                }}

                                                if(_issueUpdateId != null){if(_issueUpdateId! > _filterViewId!){
                                                  _issueUpdateId = _filterViewId!;
                                                }}
                                                if(_issueDeleteId != null){if(_issueDeleteId! > _filterViewId!){
                                                  _issueDeleteId = _filterViewId!;
                                                }}


                                                if(_contactPermission!.update > _filterViewId! ){_contactUpdateId = _filterViewId!;}
                                                if(_contactPermission!.delete > _filterViewId! ){_contactDeleteId = _filterViewId!;}


                                                if(_dealPermission!.update > _filterViewId! ){_dealUpdateId = _filterViewId!;}
                                                if(_dealPermission!.delete > _filterViewId! ){_dealDeleteId = _filterViewId!;}

                                                if(_issuePermission!.update > _filterViewId! ){_issueUpdateId = _filterViewId!;}
                                                if(_issuePermission!.delete > _filterViewId! ){_issueDeleteId = _filterViewId!;}


                                              });
                                              _contactViewId = _filterViewId;
                                              _dealViewId = _filterViewId;
                                              _issueViewId = _filterViewId;
                                            }
                                          }
                                        } : null : null,
                                    ),
                                  ),
                                ],
                            ),
                          ),

                          //Quyền quản lý thông tin khách hàng
                          if(_currentEmpAccount.roleId == 3 || _currentEmpAccount.roleId == 4 || _currentEmpAccount.roleId == 5)
                           Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: CustomExpansionTile(
                                isExpand: _isExpand,
                                label: 'Quyền quản lý thông tin khách hàng',
                                colors: const [Colors.yellow, Colors.white],
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                                    child: _currentEmpAccount.roleId != 6 ?  CustomDropdownFormField2(
                                        value: _contactPermission != null ? permissionStatusesNames[_contactCreateId == null ? _contactPermission!.create : _contactCreateId!] : null,
                                        label: 'Tạo mới',
                                        hintText: _contactPermission != null ? Text(permissionStatusesNames[_contactCreateId == null ? _contactPermission!.create : _contactCreateId!]) : const Text(''),
                                        items: saleEmpCreatePermNames,
                                        onChanged: _filterRole?.roleId != 3 ? _readOnly != true ? (value){
                                          for(int i = 0; i < permissionStatuses.length; i++){
                                            if(value.toString() == permissionStatuses[i].name){
                                              setState(() {
                                                _contactCreateId = permissionStatuses[i].permissionStatusId;
                                                print(_contactCreateId);
                                              });
                                            }
                                          }
                                        } : null : null,
                                    ) : null,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                    child: _currentEmpAccount.roleId != 6 ?  CustomDropdownFormField2(
                                        value: _contactPermission != null ? permissionStatusesNames[_contactUpdateId == null ? _contactPermission!.update : _contactUpdateId!] : null,
                                        label: 'Chỉnh sửa',
                                        hintText: _contactPermission != null ? Text(permissionStatusesNames[_contactUpdateId == null ? _contactPermission!.update : _contactUpdateId!]) : const Text(''),
                                        items: _filterViewId != null ? (_filterViewId == 4 && _filterViewId != 2) ? saleEmpUpdateDeletePermNames
                                         : (_filterViewId == 3 && _filterViewId != 4) ? saleEmpUpdateDeletePermTeamOnlyNames
                                         : saleEmpUpdateDeletePermSelfOnlyNames : saleEmpUpdateDeletePermNames,
                                        onChanged: _filterRole?.roleId != 3 ? _readOnly != true ? (value){
                                          for(int i = 0; i < permissionStatuses.length; i++){
                                            if(value.toString() == permissionStatuses[i].name){
                                              setState(() {
                                                _contactUpdateId = permissionStatuses[i].permissionStatusId;
                                              });
                                            }
                                          }
                                        } : null : null,
                                    ) : null,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15.0),
                                    child:_currentEmpAccount.roleId != 6 ?  CustomDropdownFormField2(
                                        value: _contactPermission != null ? permissionStatusesNames[_contactDeleteId == null ? _contactPermission!.delete : _contactDeleteId!] : null,
                                        label: 'Xóa',
                                        hintText: _contactPermission != null ? Text(permissionStatusesNames[_contactDeleteId == null ? _contactPermission!.delete : _contactDeleteId!]) : const Text(''),
                                        items: _filterViewId != null ? (_filterViewId == 4 && _filterViewId != 2) ? saleEmpUpdateDeletePermNames
                                            : (_filterViewId == 3 && _filterViewId != 4) ? saleEmpUpdateDeletePermTeamOnlyNames
                                            : saleEmpUpdateDeletePermSelfOnlyNames : saleEmpUpdateDeletePermNames,
                                        onChanged: _filterRole?.roleId != 3 ? _readOnly != true ? (value){
                                          for(int i = 0; i < permissionStatuses.length; i++){
                                            if(value.toString() == permissionStatuses[i].name){
                                              setState(() {
                                                _contactDeleteId = permissionStatuses[i].permissionStatusId;
                                              });
                                            }
                                          }
                                        } : null : null,
                                    ) : null,
                                  ),
                                ]
                            ),
                          ),

                          //Quyền quản lý họp đồng
                          if(_currentEmpAccount.roleId == 3 || _currentEmpAccount.roleId == 4 || _currentEmpAccount.roleId == 5)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: CustomExpansionTile(
                                  isExpand: _isExpand,
                                  label: 'Quyền quản lý hợp đồng',
                                  colors: const [Colors.greenAccent, Colors.white],
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                                      child:  _currentEmpAccount.roleId != 6 ? CustomDropdownFormField2(
                                          value: _dealPermission != null ? permissionStatusesNames[_dealCreateId == null ? _dealPermission!.create : _dealCreateId!] : null,
                                          label: 'Tạo mới',
                                          hintText: _dealPermission != null ? Text(permissionStatusesNames[_dealCreateId == null ? _dealPermission!.create : _dealCreateId!]) : const Text(''),
                                          items: saleEmpCreatePermNames,
                                          onChanged: _filterRole?.roleId != 3 ? _readOnly != true ? (value){
                                            for(int i = 0; i < permissionStatuses.length; i++){
                                              if(value.toString() == permissionStatuses[i].name){
                                                setState(() {
                                                  _dealCreateId = permissionStatuses[i].permissionStatusId;
                                                });
                                              }
                                            }
                                          } : null : null,
                                      ) : null,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                      child: _currentEmpAccount.roleId != 6 ?  CustomDropdownFormField2(
                                          value: _dealPermission != null ? permissionStatusesNames[_dealUpdateId == null ?_dealPermission!.update : _dealUpdateId!] : null,
                                          label: 'Chỉnh sửa',
                                          hintText: _dealPermission != null ? Text(permissionStatusesNames[_dealUpdateId == null ?_dealPermission!.update : _dealUpdateId!]) : const Text(''),
                                          items: _filterViewId != null ? (_filterViewId == 4 && _filterViewId != 2) ? saleEmpUpdateDeletePermNames
                                              : (_filterViewId == 3 && _filterViewId != 4) ? saleEmpUpdateDeletePermTeamOnlyNames
                                              : saleEmpUpdateDeletePermSelfOnlyNames : saleEmpUpdateDeletePermNames,
                                          onChanged: _filterRole?.roleId != 3 ? _readOnly != true ? (value){
                                            for(int i = 0; i < permissionStatuses.length; i++){
                                              if(value.toString() == permissionStatuses[i].name){
                                                setState(() {
                                                  _dealUpdateId = permissionStatuses[i].permissionStatusId;
                                                });
                                              }
                                            }
                                          } : null : null,
                                      ) : null,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
                                      child: _currentEmpAccount.roleId != 6 ?  CustomDropdownFormField2(
                                          value: _dealPermission != null ? permissionStatusesNames[_dealDeleteId == null ?_dealPermission!.delete : _dealDeleteId!] : null,
                                          label: 'Xóa',
                                          hintText: _dealPermission != null ? Text(permissionStatusesNames[_dealDeleteId == null ?_dealPermission!.delete : _dealDeleteId!]) : const Text(''),
                                          items: _filterViewId != null ? (_filterViewId == 4 && _filterViewId != 2) ? saleEmpUpdateDeletePermNames
                                              : (_filterViewId == 3 && _filterViewId != 4) ? saleEmpUpdateDeletePermTeamOnlyNames
                                              : saleEmpUpdateDeletePermSelfOnlyNames : saleEmpUpdateDeletePermNames,
                                          onChanged: _filterRole?.roleId != 3 ? _readOnly != true ? (value){
                                            for(int i = 0; i < permissionStatuses.length; i++){
                                              if(value.toString() == permissionStatuses[i].name){
                                                setState(() {
                                                  _dealDeleteId = permissionStatuses[i].permissionStatusId;
                                                });
                                              }
                                            }
                                          } : null : null,
                                      ) : null,
                                    ),
                                  ]
                              ),
                            ),

                          //Quyền quả lý vấn đề
                          if(_currentEmpAccount.roleId == 3 || _currentEmpAccount.roleId == 4 || _currentEmpAccount.roleId == 5)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: CustomExpansionTile(
                                  isExpand: _isExpand,
                                  label: 'Quyền quản lý vấn đề',
                                  colors: const [Colors.orange, Colors.white],
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                                      child: _currentEmpAccount.roleId != 6 ? CustomDropdownFormField2(
                                          value: _issuePermission != null ? permissionStatusesNames[_issueCreateId == null ? _issuePermission!.create : _issueCreateId!] : null,
                                          label: 'Tạo mới',
                                          hintText: _issuePermission != null ? Text(permissionStatusesNames[_issueCreateId == null ? _issuePermission!.create : _issueCreateId!]) : const Text(''),
                                          items: saleEmpCreatePermNames,
                                          onChanged: _filterRole?.roleId != 3 ? _readOnly != true ? (value){
                                            for(int i = 0; i < permissionStatuses.length; i++){
                                              if(value.toString() == permissionStatuses[i].name){
                                                setState(() {
                                                  _issueCreateId = permissionStatuses[i].permissionStatusId;
                                                });
                                              }
                                            }
                                          } : null : null,
                                      ) : null,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                      child: _currentEmpAccount.roleId != 6 ? CustomDropdownFormField2(
                                          value: _issuePermission != null ? permissionStatusesNames[_issueUpdateId == null ? _issuePermission!.update : _issueUpdateId!] : null,
                                          label: 'Chỉnh sửa',
                                          hintText: _issuePermission != null ? Text(permissionStatusesNames[_issueUpdateId == null ? _issuePermission!.update : _issueUpdateId!]) : const Text(''),
                                          items: _filterViewId != null ? (_filterViewId == 4 && _filterViewId != 2) ? saleEmpUpdateDeletePermNames
                                              : (_filterViewId == 3 && _filterViewId != 4) ? saleEmpUpdateDeletePermTeamOnlyNames
                                              : saleEmpUpdateDeletePermSelfOnlyNames : saleEmpUpdateDeletePermNames,
                                          onChanged: _filterRole?.roleId != 3 ? _readOnly != true ? (value){
                                            for(int i = 0; i < permissionStatuses.length; i++){
                                              if(value.toString() == permissionStatuses[i].name){
                                                setState(() {
                                                  _issueUpdateId = permissionStatuses[i].permissionStatusId;
                                                });
                                              }
                                            }
                                          } : null : null,
                                      ) : null,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
                                      child: _currentEmpAccount.roleId != 6 ? CustomDropdownFormField2(
                                          value: _issuePermission != null ? permissionStatusesNames[_issueDeleteId == null ? _issuePermission!.delete : _issueDeleteId!] : null,
                                          label: 'Xóa',
                                          hintText: _issuePermission != null ? Text(permissionStatusesNames[_issueDeleteId == null ? _issuePermission!.delete : _issueDeleteId!]) : const Text(''),
                                          items: _filterViewId != null ? (_filterViewId == 4 && _filterViewId != 2) ? saleEmpUpdateDeletePermNames
                                              : (_filterViewId == 3 && _filterViewId != 4) ? saleEmpUpdateDeletePermTeamOnlyNames
                                              : saleEmpUpdateDeletePermSelfOnlyNames : saleEmpUpdateDeletePermNames,
                                          onChanged: _filterRole?.roleId != 3 ? _readOnly != true ? (value){
                                            for(int i = 0; i < permissionStatuses.length; i++){
                                              if(value.toString() == permissionStatuses[i].name){
                                                setState(() {
                                                  _issueDeleteId = permissionStatuses[i].permissionStatusId;
                                                });
                                              }
                                            }
                                          } : null : null,
                                      ) : null,
                                    ),
                                  ]
                              ),
                          ),

                          //Quyền quả lý tài khoản nhân viên
                          if(_currentEmpAccount.roleId == 2)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: CustomExpansionTile(
                                  isExpand: _isExpand,
                                  label: 'Quyền quản lý tài khoản nhân viên',
                                  colors: const [Colors.blue, Colors.white],
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15.0),
                                      child: CustomDropdownFormField2(
                                          value: _accountPermission != null ? permissionStatusesNames[_accountViewId == null ? _accountPermission!.view : _accountViewId!] : null,
                                          label: 'Xem',
                                          hintText: _accountPermission != null ? Text(permissionStatusesNames[_accountViewId == null ? _accountPermission!.view : _accountViewId!]) : const Text(''),
                                          items: hrInternViewPermNames,
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

                          //Quyền quản lý điểm danh
                          if(_currentEmpAccount.roleId == 2)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: CustomExpansionTile(
                                  isExpand: _isExpand,
                                  label: 'Quyền quản lý điểm danh',
                                  colors: const [Colors.green, Colors.white],
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                                      child: CustomDropdownFormField2(
                                          value: _attendancePermission != null ? permissionStatusesNames[_attendanceViewId == null ? _attendancePermission!.view : _attendanceViewId!] : null,
                                          label: 'Xem',
                                          hintText: _attendancePermission != null ? Text(permissionStatusesNames[_attendanceViewId == null ? _attendancePermission!.view : _attendanceViewId!]) : const Text(''),
                                          items: hrInternViewPermNames,
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
                                    if(_currentEmpAccount.roleId != 1)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15.0),
                                      child: CustomDropdownFormField2(
                                          value: _attendancePermission != null ? permissionStatusesNames[_attendanceUpdateId == null ? _attendancePermission!.update : _attendanceUpdateId!] : null,
                                          label: 'Chỉnh sủa',
                                          hintText: _attendancePermission != null ? Text(permissionStatusesNames[_attendanceUpdateId == null ? _attendancePermission!.update : _attendanceUpdateId!]) : const Text(''),
                                          items: hrInternViewPermNames,
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

                          if(_currentEmpAccount.roleId == 2 || _currentEmpAccount.roleId == 6)
                            if(_filterViewId != 2)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomEditableTextFormField(
                                      borderColor: _readOnly != true ? mainBgColor : null,
                                      text: _departmentPermNameString,
                                      title: 'Quản lý phòng ban',
                                      readonly: true,
                                      onTap: _readOnly != true ? () async {
                                        final data = await Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => AdminDepartmentFilter(departmentList: _currentEmpAccount.roleId == 6 ? getDepartmentListInBlock(block: getBlock(blockId: 1)) : departments ),
                                        ));
                                        if(data != null){
                                          _filterDepartmentPerm = data;
                                          _filterTeamPerm = null;
                                          setState(() {
                                            _departmentPermNameString = _filterDepartmentPerm!.name;
                                            _teamPermNameString = '';
                                          });
                                        }
                                      } : null,
                                  ),
                                ),
                              ],
                            ),
                          ),


                          if(_currentEmpAccount.roleId == 6 && _filterViewId == 3)
                            if(_permission!.departmentId != null || _filterDepartmentPerm != null)
                              if( getTeamListInDepartment(department: _filterDepartmentPerm == null ? getDepartment(departmentId: _permission!.departmentId!) : _filterDepartmentPerm!).isNotEmpty )
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: CustomEditableTextFormField(
                              borderColor: _readOnly != true ? mainBgColor : null,
                              text: _teamPermNameString,
                              title: 'Quản lý nhóm',
                              readonly: true,
                              onTap: _readOnly != true ? () async {
                                final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminTeamFilter(
                                    teamList: getTeamListInDepartment(department: _filterDepartmentPerm == null ? getDepartment(departmentId: _permission!.departmentId!) : _filterDepartmentPerm!) )
                                ));
                                if(data != null){
                                  _filterTeamPerm = data;
                                  setState(() {
                                    _teamPermNameString = _filterTeamPerm!.name;
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
                                        setState(() {
                                          _isExpand = false;
                                          // _permission = null;
                                          // _accountPermission = null;
                                          // _attendancePermission = null;
                                          // _contactPermission = null;
                                          // _dealPermission = null;
                                          // _issuePermission = null;
                                          // _filterBlock = null;
                                          // _filterTeam = null;
                                          // _filterDepartmentPerm = null;
                                          // _filterDepartment = null;
                                          // _filterRole = null;
                                          // _filterTeam = null;
                                          // _contactCreateId = null; _contactViewId = null; _contactUpdateId = null; _contactDeleteId = null;
                                          // _dealCreateId = null; _dealViewId = null; _dealUpdateId = null; _dealDeleteId = null;
                                          // _issueCreateId = null; _issueViewId = null; _issueUpdateId = null; _issueDeleteId = null;
                                          // _accountViewId = null; _attendanceViewId = null; _attendanceUpdateId = null;
                                          _readOnly = true;
                                        });
                                      },
                                )),

                              if(_currentAccount.roleId == 0 && _readOnly == true && _currentEmpAccount.roleId != 1)
                              Expanded(
                                child: CustomTextButton(
                                  color: Colors.red,
                                  text: 'Xóa tài khoản',
                                  onPressed: () async {

                                    showLoaderDialog(context);
                                    bool data = await _deleteAnAccount(accountId: _currentEmpAccount.accountId!);
                                    if(data == true){
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Xóa tài khoản thành công')),
                                      );
                                      Future.delayed(const Duration(seconds: 1), (){
                                        Navigator.pop(context);
                                      });
                                    }else{
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Xóa tài khoản thất bại')),
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 5.0,),

                              if(_currentEmpAccount.statusId != 0)
                              if(_currentAccount.roleId == 0 && _currentEmpAccount.roleId != 1)
                              Expanded(
                                child: CustomTextButton(
                                    color: Colors.blueAccent,
                                    text: _readOnly == true ? 'Chỉnh sửa' : 'Lưu',
                                    onPressed: () async {
                                      if(_isExpand == false){
                                        setState(() {
                                          _isExpand = true;
                                        });
                                      }

                                      if(_readOnly == false){

                                        if(!_formKey.currentState!.validate()){
                                          return;
                                        }

                                        showLoaderDialog(context);

                                        bool? check, check2, check3, check4, check5, check6, check7;

                                        if(_currentEmpAccount.roleId == 2){
                                          check = await _updateHrInternPermission();
                                          check2 = await _updatePermission();
                                          check3 = await _updateAnAccount();
                                        }

                                        if(_filterRole!.roleId == 3 || _filterRole!.roleId == 4 || _filterRole!.roleId == 5){
                                          check4 = await _updateSaleTechnicalEmpPermission();
                                          check5 = await _updateAnAccount();
                                          check6 = await _updatePermission();
                                        }

                                        if(_currentEmpAccount.roleId == 6){
                                          check7 = await _updateAnAccount();
                                        }


                                        if( (check == true && check2 == true && check3 == true) || (check4 == true && check5 == true && check6 == true) || check7 == true){
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Cập nhật tài khoản thành công')),
                                          );
                                          Future.delayed(const Duration(seconds: 1), (){
                                            Navigator.pop(context);
                                          });
                                        }else{
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Cập nhật tài khoản thất bại')),
                                          );
                                        }

                                      }
                                      if(_readOnly == true) setState(() {_readOnly = false;});
                                    },
                                ),
                              ),
                            ],
                          ),

                        ],
                      )
                  ),
                ),
              ) : const Center(child: CircularProgressIndicator())),
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
    _getPermByPermId(permId: _currentEmpAccount.permissionId!);
    if(_currentEmpAccount.departmentId != null) _departmentNameString = getDepartmentName(_currentEmpAccount.departmentId!, null);
    if(_currentEmpAccount.teamId != null) _teamNameString = getTeamName(_currentEmpAccount.teamId!, _currentEmpAccount.departmentId!);
  }

  Future<bool> _deleteAnAccount({required int accountId}) async {

    bool result = await AccountViewModel().deleteAnAccount(accountId: accountId);

    return result;
  }

  //============================================================================Update perm
  Future<bool> _updatePermission() async {
    Permission permissionHrIntern = Permission(
        permissionId: _permission!.permissionId,
        accountPermissionId: _permission!.accountPermissionId,
        attendancePermissionId: _permission!.attendancePermissionId,
        departmentId: _filterDepartmentPerm == null ? _permission?.departmentId : _filterDepartmentPerm?.departmentId
    );

    Permission permissionSaleEmp = Permission(
        permissionId: _permission!.permissionId,
        contactPermissionId: _permission!.contactPermissionId,
        dealPermissionId: _permission!.dealPermissionId,
        issuePermissionId: _permission!.issuePermissionId,
        departmentId: _filterDepartment == null ? _currentEmpAccount.departmentId : _filterDepartment!.departmentId,
        teamId:  _filterRole?.roleId != 3 ? _filterTeam == null ? _currentEmpAccount.teamId : _filterTeam!.teamId : null,
    );
    print('Đến đây');
    Permission? data;
    if(_filterRole!.roleId == 2){
      data = await PermissionViewModel().updatePermission(permission: permissionHrIntern);
    } else if(_filterRole!.roleId == 3 || _filterRole!.roleId == 4 || _filterRole!.roleId == 5){
      data = await PermissionViewModel().updatePermission(permission: permissionSaleEmp);
    }

    if(data != null){
      return true;
    }else{
      return false;
    }

  }
  Future<bool> _updateAnAccount() async {
    Account account = Account(
      accountId: _currentEmpAccount.accountId,
      email: _currentEmpAccount.email,
      fullname: _empName.text.isEmpty ? _currentEmpAccount.fullname : _empName.text,
      phoneNumber: _empPhoneNumber.text.isEmpty ? _currentEmpAccount.phoneNumber : _empPhoneNumber.text,
      address: _empAddress.text.isEmpty ? _currentEmpAccount.address : _empAddress.text,
      citizenIdentityCardNumber: _empCitizenIdentityCardNumber.text.isEmpty ? _currentEmpAccount.citizenIdentityCardNumber : _empCitizenIdentityCardNumber.text,
      nationality: _empNationality.text.isEmpty ? _currentEmpAccount.nationality : _empNationality.text,
      bankName: _empBankName.text.isEmpty ? _currentEmpAccount.bankName : _empBankName.text,
      bankAccountName: _empBankAccountOwnerName.text.isEmpty ? _currentEmpAccount.bankAccountName : _empBankAccountOwnerName.text,
      bankAccountNumber: _empBankAccountNumber.text.isEmpty ? _currentEmpAccount.bankAccountNumber : _empBankAccountNumber.text,
      roleId: _filterRole != null ? _filterRole!.roleId : _currentEmpAccount.roleId,
      blockId: _currentEmpAccount.blockId,
      departmentId: _filterDepartment != null ? _filterDepartment!.departmentId : _currentEmpAccount.departmentId,
      teamId: _filterRole!.roleId != 3 ? _currentEmpAccount.roleId != 6 ? _filterTeam != null ? _filterTeam!.teamId : _currentEmpAccount.teamId : null : null,
      permissionId: _currentEmpAccount.permissionId,
      statusId: 1,
      genderId: genderId ?? _currentEmpAccount.genderId,
      dateOfBirth: _empDob ?? _currentEmpAccount.dateOfBirth,
    );

    final data = await AccountViewModel().updateAnAccount(account);

    if(data != null ){
      return true;
    }else{
      return false;
    }
  }

  Future<bool> _updateSaleTechnicalEmpPermission() async {
    ContactPermission contactPermission = ContactPermission(
      contactPermissionId:_contactPermission!.contactPermissionId,
      create: _currentEmpAccount.roleId != 6 ? _contactCreateId == null ? _contactPermission!.create : _contactCreateId! : 0,
      view: _currentEmpAccount.roleId != 6 ? _contactViewId == null ? _contactPermission!.view : _contactViewId! : 2,
      update: _currentEmpAccount.roleId != 6 ? _contactUpdateId == null ? _contactPermission!.update : _contactUpdateId! : 0,
      delete: _currentEmpAccount.roleId != 6 ? _contactDeleteId == null ? _contactPermission!.delete : _contactDeleteId! : 0,
    );

    DealPermission dealPermission = DealPermission(
        dealPermissionId: _dealPermission!.dealPermissionId,
        create: _currentEmpAccount.roleId != 6 ? _dealCreateId == null ? _dealPermission!.create : _dealCreateId! : 0,
        view: _currentEmpAccount.roleId != 6 ? _dealViewId == null ? _dealPermission!.view : _dealViewId! : 2,
        update: _currentEmpAccount.roleId != 6 ? _dealUpdateId == null ? _dealPermission!.update : _dealUpdateId! : 0,
        delete: _currentEmpAccount.roleId != 6 ? _dealDeleteId == null ? _dealPermission!.delete : _dealDeleteId! : 0
    );

    IssuePermission issuePermission = IssuePermission(
        issuePermissionId: _issuePermission!.issuePermissionId,
        create: _currentEmpAccount.roleId != 6 ? _issueCreateId == null ? _issuePermission!.create : _issueCreateId! : 0,
        view: _currentEmpAccount.roleId != 6 ? _issueViewId == null ? _issuePermission!.view : _issueViewId! : 2,
        update: _currentEmpAccount.roleId != 6 ? _issueUpdateId == null ? _issuePermission!.update : _issueUpdateId! : 0,
        delete: _currentEmpAccount.roleId != 6 ? _issueDeleteId == null ? _issuePermission!.delete : _issueDeleteId! : 0
    );

    final data = await PermissionViewModel().updateContactPermission(contactPermission: contactPermission);
    final data2 = await PermissionViewModel().updateDealPermission(dealPermission: dealPermission);
    final data3 = await PermissionViewModel().updateIssuePermission(issuePermission: issuePermission);

    if(data != null && data2 != null && data3 != null){
      return true;
    }else{
      return false;
    }
  }

  void _updateTechnicalEmpPermission(){
    IssuePermission issuePermission = IssuePermission(
        issuePermissionId: _issuePermission!.issuePermissionId,
        create: _issueCreateId == null ? _issuePermission!.create : _issueCreateId!,
        view: _issueViewId == null ? _issuePermission!.view : _issueViewId!,
        update: _issueUpdateId == null ? _issuePermission!.update : _issueUpdateId!,
        delete: _issueDeleteId == null ? _issuePermission!.delete : _issueDeleteId!
    );

    PermissionViewModel().updateIssuePermission(issuePermission: issuePermission);
  }

  Future<bool> _updateHrInternPermission() async {
    AccountPermission accountPermission = AccountPermission(
        accountPermissionId: _accountPermission!.accountPermissionId,
        view: _accountViewId == null ? _accountPermission!.view : _accountViewId!,
        create: 0,
        update: 0,
        delete: 0
    );

    AttendancePermission attendancePermission = AttendancePermission(
        attendancePermissionId: _attendancePermission!.attendancePermissionId,
        view: _attendanceViewId == null ? _attendancePermission!.view : _attendanceViewId!,
        update: _attendanceUpdateId == null ? _attendancePermission!.update : _attendanceUpdateId!
    );

    final data = await PermissionViewModel().updateAccountPermission(accountPermission: accountPermission);
    final data2 = await PermissionViewModel().updateAttendancePermission(attendancePermission: attendancePermission);

    if(data != null && data2 != null){
      return true;
    }else{
      return false;
    }
  }

  //============================================================================Get perm
  void _getPermByPermId({required int permId}) async {
    _permission = await PermissionViewModel().getPermByPermId(permId: permId);
    if(_permission?.departmentId != null){
      _departmentPermNameString = getDepartmentName(_permission!.departmentId!, null);
      if(_permission?.teamId != null){
        _teamPermNameString = getTeamName(_permission!.teamId!, _permission!.departmentId!);
      }
    }


    if(_permission!.accountPermissionId != null) _getAccountPermissionById(accountPermissionId: _permission!.accountPermissionId!);
    if(_permission!.attendancePermissionId != null) _getAttendancePermissionById(attendancePermissionId: _permission!.attendancePermissionId!);
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
      _filterViewId = _contactPermission!.view;
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
