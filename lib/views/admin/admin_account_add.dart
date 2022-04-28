import 'package:flutter/material.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/models/register_account.dart';
import 'package:login_sample/models/role.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/account_register_view_model.dart';
import 'package:login_sample/views/admin/admin_department_filter.dart';
import 'package:login_sample/views/admin/admin_team_filter.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomExpansionTile.dart';
import 'package:login_sample/widgets/CustomReadOnlyTextField.dart';
import 'admin_role_filter.dart';

class AdminAccountAdd extends StatefulWidget {
  const AdminAccountAdd({Key? key}) : super(key: key);

  @override
  _AdminAccountAddState createState() => _AdminAccountAddState();
}

class _AdminAccountAddState extends State<AdminAccountAdd> {

  final TextEditingController _accountEmail = TextEditingController();

  Department? _filterDepartment, _filterDepartmentPerm;
  Team? _filterTeam, _filterTeamPerm;
  Role? _filterRole;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _filterRoleString = '', _filterDepartmentString = '', _filterTeamString = '', _departmentPermNameString = '', _teamPermNameString = '';

  int? _contactCreateId, _contactViewId, _contactUpdateId, _contactDeleteId, _dealCreateId, _dealViewId, _dealUpdateId, _dealDeleteId, _issueCreateId, _issueViewId, _issueUpdateId, _issueDeleteId;
  int? _accountViewId, _attendanceViewId, _attendanceUpdateId;
  int? _filterViewId, _filterBlockId;


  @override
  void dispose() {
    super.dispose();
    _accountEmail.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: mainBgColor,
        icon: const Icon(Icons.create),
        label: const Text('Tạo mới'),
          onPressed: () async {
            if(!_formKey.currentState!.validate()){
              return;
            }
            showLoaderDialog(context);
            final data = await _registerAnAccount();
            if(data != false){
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tạo tài khoản mới cho nhân viên thành công')),
              );
              Future.delayed(const Duration(seconds: 1), (){
                Navigator.pop(context);
              });
            }else{
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tạo tài khoản mới cho nhân viên thất bại')),
              );
            }

          },
      ),
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
            elevation: 10.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))
            ),
            margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                  child: Column(
                    children: <Widget>[
                      //============================================================email box===================================================================
                      Row(
                        children: [
                          Expanded(
                            child: CustomEditableTextFormField(
                                isNull: false,
                                isEmailCheck: true,
                                borderColor: mainBgColor,
                                text: _accountEmail.text.isEmpty ? '' : _accountEmail.text,
                                title: 'Email của nhân viên',
                                readonly: false,
                                textEditingController: _accountEmail,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),
                      //============================================================Chọn chức vụ===============================================================
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomEditableTextFormField(
                                  borderColor: mainBgColor,
                                  text: _filterRoleString,
                                  title: 'Chức vụ',
                                  readonly: true,
                                  onTap: () async {
                                  final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminRoleFilter(isHrInternFilter: true,) ));
                                  if( data != null ){

                                    _contactCreateId = _dealCreateId = _issueCreateId = 0;
                                    _contactDeleteId = _contactUpdateId = _dealDeleteId = _dealUpdateId = _issueDeleteId = _issueUpdateId = 0;
                                    _contactViewId = _dealViewId = _issueViewId = 0;

                                    setState(() {
                                      _filterRole = data;

                                      _filterRoleString = _filterRole!.name;
                                      _filterDepartmentString = '';
                                      _filterDepartment = null;
                                      _filterTeamString = '';
                                      _filterTeam = null;
                                      _filterDepartmentPerm = null;
                                      _departmentPermNameString = '';
                                      _filterTeamPerm = null;
                                      _teamPermNameString = '';

                                      if(_filterRole!.roleId == 3 || _filterRole!.roleId == 4 || _filterRole!.roleId == 5){
                                        _filterBlockId = 1;
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
                                      }
                                      if(_filterRole!.roleId == 2){
                                        _filterBlockId = 0;
                                      }
                                      if(_filterRole!.roleId == 6){
                                        _filterBlockId = 2;
                                        _filterViewId = 2;
                                      }
                                    });
                                    _contactViewId = _dealViewId = _issueViewId = _filterViewId;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      if(_filterBlockId != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomReadOnlyTextField(
                                  text: getBlock(blockId: _filterBlockId!).name,
                                  title: 'Thuộc khối',
                              ),
                            ),
                          ],
                        ),
                      ),
                      //============================================================Chọn phòng ban===============================================================
                      if(_filterBlockId != null)
                        if( getDepartmentListInBlock(block: getBlock(blockId: _filterBlockId!)).isNotEmpty )
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomEditableTextFormField(
                                borderColor: mainBgColor,
                                text: _filterDepartmentString,
                                title: 'Thuộc phòng ban',
                                readonly: true,
                                onTap: () async {
                                  final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDepartmentFilter(departmentList: getDepartmentListInBlock(block: getBlock(blockId: _filterBlockId!)) )
                                  ));
                                  if( data != null ){
                                    setState(() {
                                      setState(() {
                                        _filterDepartment = data;
                                        _filterDepartmentString = _filterDepartment!.name;
                                        _filterTeamString = '';
                                        _filterTeam = null;
                                      });
                                    });
                                  }
                                  },
                              ),
                            ),
                          ],
                        ),
                      ),
                      //============================================================Chọn nhóm===============================================================
                      if(_filterRole != null)
                      if(_filterDepartment != null && _filterRole!.roleId != 3)
                        if( getTeamListInDepartment(department: _filterDepartment!).isNotEmpty )
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomEditableTextFormField(
                                borderColor: mainBgColor,
                                text: _filterTeamString,
                                title: 'Thuộc nhóm',
                                readonly: true,
                                onTap: () async {
                                  final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminTeamFilter(teamList: getTeamListInDepartment(department: _filterDepartment!))
                                  ));
                                  if( data != null ){
                                    setState(() {
                                      setState(() {
                                        _filterTeam = data;
                                        _filterTeamString = _filterTeam!.name;
                                      });
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      //============================================================Quyền truy cập của nhân viên Sale, KTV===================================
                      if(_filterRole != null)
                      if(_filterRole!.roleId == 3 || _filterRole!.roleId == 4 || _filterRole!.roleId == 5 || _filterRole!.roleId == 6)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomExpansionTile(
                            isExpand: true,
                            label: 'Quyền xem thông tin khách hàng & hợp đồng & vấn đề',
                            colors: const [Colors.red, Colors.white],
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0, bottom: 15.0),
                                child: CustomDropdownFormField2(
                                    value: _filterViewId != null ? permissionStatusesNames[_filterViewId!] : null,
                                    label: 'Xem',
                                    hintText: Text(_filterViewId == null ? '' : permissionStatusesNames[_filterViewId!]),
                                    items: saleEmpViewPermNames,
                                    onChanged: (_filterRole!.roleId != 3 && _filterRole!.roleId != 6) ? (value){
                                      for(int i = 0; i < permissionStatuses.length; i++){
                                        if(value.toString() == permissionStatuses[i].name){
                                          setState(() {
                                            _filterViewId = permissionStatuses[i].permissionStatusId;

                                            if(_contactUpdateId == null || _contactUpdateId! > _filterViewId!){
                                              _contactUpdateId = _filterViewId!;
                                            }
                                            if(_contactDeleteId == null || _contactDeleteId! > _filterViewId!){
                                              _contactDeleteId = _filterViewId!;
                                            }

                                            if(_dealUpdateId == null || _dealUpdateId! > _filterViewId!){
                                              _dealUpdateId = _filterViewId!;
                                            }
                                            if(_dealDeleteId == null || _dealDeleteId! > _filterViewId!){
                                              _dealDeleteId = _filterViewId!;
                                            }

                                            if(_issueUpdateId == null || _issueUpdateId! > _filterViewId!){
                                              _issueUpdateId = _filterViewId!;
                                            }
                                            if(_issueDeleteId == null || _issueDeleteId! > _filterViewId!){
                                              _issueDeleteId = _filterViewId!;
                                            }
                                            _departmentPermNameString = '';
                                            _teamPermNameString = '';
                                          });
                                        }
                                      }
                                      _filterDepartmentPerm = null;
                                      _filterTeamPerm = null;
                                      _contactViewId = _filterViewId;
                                      _dealViewId = _filterViewId;
                                      _issueViewId = _filterViewId;
                                    } : null
                                ),
                              ),
                            ],
                        ),
                      ),

                      if(_filterRole != null && _filterViewId != null)
                      if(_filterRole!.roleId == 3 || _filterRole!.roleId == 4 || _filterRole!.roleId == 5)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomExpansionTile(
                            isExpand: true,
                            label: 'Quyền quản lý thông tin khách hàng',
                            colors: const [Colors.yellow, Colors.white],
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                                child: CustomDropdownFormField2(
                                    value: _contactCreateId != null ? permissionStatusesNames[_contactCreateId!] : null,
                                    label: 'Tạo mới',
                                    hintText: _contactCreateId != null ? Text(permissionStatusesNames[_contactCreateId!]) : const Text(''),
                                    items: saleEmpCreatePermNames,
                                    onChanged: _filterRole!.roleId != 3 ? (value){
                                      for(int i = 0; i < permissionStatuses.length; i++){
                                        if(value.toString() == permissionStatuses[i].name){
                                          setState(() {
                                            _contactCreateId = permissionStatuses[i].permissionStatusId;
                                          });
                                        }
                                      }
                                    } : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                                child: CustomDropdownFormField2(
                                  value: _contactUpdateId != null ? permissionStatusesNames[_contactUpdateId!] : null,
                                  label: 'Chỉnh sửa',
                                  hintText: _contactUpdateId != null ? Text(permissionStatusesNames[_contactUpdateId!]) : const Text(''),
                                  items: _filterViewId != null ? (_filterViewId == 4 && _filterViewId != 2) ? saleEmpUpdateDeletePermNames
                                      : (_filterViewId == 3 && _filterViewId != 4) ? saleEmpUpdateDeletePermTeamOnlyNames
                                      : saleEmpUpdateDeletePermSelfOnlyNames : saleEmpUpdateDeletePermNames,
                                  onChanged: _filterRole!.roleId != 3 ? (value){
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
                                padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                                child: CustomDropdownFormField2(
                                  value: _contactDeleteId != null ? permissionStatusesNames[_contactDeleteId!] : null,
                                  label: 'Xóa',
                                  hintText: _contactDeleteId != null ? Text(permissionStatusesNames[_contactDeleteId!]) : const Text(''),
                                  items: _filterViewId != null ? (_filterViewId == 4 && _filterViewId != 2) ? saleEmpUpdateDeletePermNames
                                      : (_filterViewId == 3 && _filterViewId != 4) ? saleEmpUpdateDeletePermTeamOnlyNames
                                      : saleEmpUpdateDeletePermSelfOnlyNames : saleEmpUpdateDeletePermNames,
                                  onChanged:_filterRole!.roleId != 3 ? (value){
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
                            ],
                        ),
                      ),
                      if(_filterRole != null && _filterViewId != null)
                      if(_filterRole!.roleId == 3 || _filterRole!.roleId == 4 || _filterRole!.roleId == 5)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomExpansionTile(
                          isExpand: true,
                          label: 'Quyền quản lý hợp đồng',
                          colors: const [Colors.green, Colors.white],
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                              child: CustomDropdownFormField2(
                                value:  _dealCreateId != null ? permissionStatusesNames[_dealCreateId!] : null,
                                label: 'Tạo mới',
                                hintText: _dealCreateId != null ? Text(permissionStatusesNames[_dealCreateId!]) : const Text(''),
                                items: saleEmpCreatePermNames,
                                onChanged:_filterRole!.roleId != 3 ? (value){
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
                              padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                              child: CustomDropdownFormField2(
                                value: _dealUpdateId != null ? permissionStatusesNames[_dealUpdateId!] : null,
                                label: 'Chỉnh sửa',
                                hintText: _dealUpdateId != null ? Text(permissionStatusesNames[_dealUpdateId!]) : const Text(''),
                                items: _filterViewId != null ? (_filterViewId == 4 && _filterViewId != 2) ? saleEmpUpdateDeletePermNames
                                    : (_filterViewId == 3 && _filterViewId != 4) ? saleEmpUpdateDeletePermTeamOnlyNames
                                    : saleEmpUpdateDeletePermSelfOnlyNames : saleEmpUpdateDeletePermNames,
                                onChanged:_filterRole!.roleId != 3 ? (value){
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
                              padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                              child: CustomDropdownFormField2(
                                value: _dealDeleteId != null ? permissionStatusesNames[_dealDeleteId!] : null,
                                label: 'Xóa',
                                hintText: _dealDeleteId != null ? Text(permissionStatusesNames[_dealDeleteId!]) : const Text(''),
                                items: _filterViewId != null ? (_filterViewId == 4 && _filterViewId != 2) ? saleEmpUpdateDeletePermNames
                                    : (_filterViewId == 3 && _filterViewId != 4) ? saleEmpUpdateDeletePermTeamOnlyNames
                                    : saleEmpUpdateDeletePermSelfOnlyNames : saleEmpUpdateDeletePermNames,
                                onChanged:_filterRole!.roleId != 3 ? (value){
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
                          ],
                        ),
                      ),
                      if(_filterRole != null && _filterViewId != null)
                      if(_filterRole!.roleId == 3 || _filterRole!.roleId == 4 || _filterRole!.roleId == 5)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomExpansionTile(
                          isExpand: true,
                          label: 'Quyền quản lý vấn đề',
                          colors: const [Colors.orange, Colors.white],
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                              child: CustomDropdownFormField2(
                                value: _issueCreateId != null ? permissionStatusesNames[_issueCreateId!] : null,
                                label: 'Tạo mới',
                                hintText: _issueCreateId != null ? Text(permissionStatusesNames[_issueCreateId!]) : const Text(''),
                                items: saleEmpCreatePermNames,
                                onChanged:_filterRole!.roleId != 3 ? (value){
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
                              padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                              child: CustomDropdownFormField2(
                                value: _issueUpdateId != null ? permissionStatusesNames[_issueUpdateId!] : null,
                                label: 'Chỉnh sửa',
                                hintText: _issueUpdateId != null ? Text(permissionStatusesNames[_issueUpdateId!]) : const Text(''),
                                items: _filterViewId != null ? (_filterViewId == 4 && _filterViewId != 2) ? saleEmpUpdateDeletePermNames
                                    : (_filterViewId == 3 && _filterViewId != 4) ? saleEmpUpdateDeletePermTeamOnlyNames
                                    : saleEmpUpdateDeletePermSelfOnlyNames : saleEmpUpdateDeletePermNames,
                                onChanged:_filterRole!.roleId != 3 ? (value){
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
                              padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                              child: CustomDropdownFormField2(
                                value: _issueDeleteId != null ? permissionStatusesNames[_issueDeleteId!] : null,
                                label: 'Xóa',
                                hintText: _issueDeleteId != null ? Text(permissionStatusesNames[_issueDeleteId!]) : const Text(''),
                                items: _filterViewId != null ? (_filterViewId == 4 && _filterViewId != 2) ? saleEmpUpdateDeletePermNames
                                    : (_filterViewId == 3 && _filterViewId != 4) ? saleEmpUpdateDeletePermTeamOnlyNames
                                    : saleEmpUpdateDeletePermSelfOnlyNames : saleEmpUpdateDeletePermNames,
                                onChanged:_filterRole!.roleId != 3 ? (value){
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

                          ],
                        ),
                      ),
                      //============================================================Quyền truy cập của HrIntern
                      if(_filterRole != null)
                        if(_filterRole!.roleId == 2)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomExpansionTile(
                          isExpand: true,
                          label: 'Quyền quản lý tài khoản nhân viên',
                          colors: const [Colors.blue, Colors.white],
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                              child: CustomDropdownFormField2(
                                value:  _accountViewId != null ? permissionStatusesNames[_accountViewId!] : null,
                                label: 'Xem',
                                hintText: _accountViewId != null ? Text(permissionStatusesNames[_accountViewId!]) : const Text(''),
                                items: hrInternViewPermNames,
                                onChanged: (value){
                                  for(int i = 0; i < permissionStatuses.length; i++){
                                    if(value.toString() == permissionStatuses[i].name){
                                      setState(() {
                                        _accountViewId = permissionStatuses[i].permissionStatusId;

                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      if(_filterRole != null)
                        if(_filterRole!.roleId == 2)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomExpansionTile(
                          isExpand: true,
                          label: 'Quyền quản lý điểm danh',
                          colors: const [Colors.yellow, Colors.white],
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                              child: CustomDropdownFormField2(
                                value: _attendanceViewId != null ? permissionStatusesNames[_attendanceViewId!] : null,
                                label: 'Xem',
                                hintText: _attendanceViewId != null ? Text(permissionStatusesNames[_attendanceViewId!]) : const Text(''),
                                items: hrInternViewPermNames,
                                onChanged: (value){
                                  for(int i = 0; i < permissionStatuses.length; i++){
                                    if(value.toString() == permissionStatuses[i].name){
                                      setState(() {
                                        _attendanceViewId = permissionStatuses[i].permissionStatusId;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                              child: CustomDropdownFormField2(
                                value: _attendanceUpdateId != null ? permissionStatusesNames[_attendanceUpdateId!] : null,
                                label: 'Chỉnh sửa',
                                hintText: _attendanceUpdateId != null ? Text(permissionStatusesNames[_attendanceUpdateId!]) : const Text(''),
                                items: hrInternViewPermNames,
                                onChanged: (value){
                                  for(int i = 0; i < permissionStatuses.length; i++){
                                    if(value.toString() == permissionStatuses[i].name){
                                      setState(() {
                                        _attendanceUpdateId = permissionStatuses[i].permissionStatusId;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      //==========================================================Quyền truy cập KTV=========================================================
                      if(_filterRole != null && _filterBlockId != null && (_filterViewId != null || _accountViewId != null))
                      if(_filterRole!.roleId == 2 )
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomEditableTextFormField(
                                  borderColor: mainBgColor,
                                  text: _departmentPermNameString,
                                  title: 'Quản lý phòng ban',
                                  readonly: true,
                                  onTap: () async {
                                    final data = await Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => AdminDepartmentFilter(departmentList: _filterBlockId == 0 ? getDepartmentListInBlock(block: getBlock(blockId: 1)) : departments),
                                    ));
                                    if(data != null){
                                      _filterDepartmentPerm = data;
                                      _filterTeamPerm = null;
                                      setState(() {
                                        _departmentPermNameString = _filterDepartmentPerm!.name;
                                        _teamPermNameString = '';
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      // if(_filterRole != null && _filterDepartmentPerm != null)
                      //   if(_filterRole!.roleId == 6)
                      //     if( getTeamListInDepartment(department: getDepartment(departmentId:_filterDepartmentPerm!.departmentId)).isNotEmpty && _filterViewId == 3)
                      //     Padding(
                      //       padding: const EdgeInsets.only(bottom: 20.0),
                      //       child: CustomEditableTextFormField(
                      //         borderColor: mainBgColor,
                      //         text: _teamPermNameString,
                      //         title: 'Quản lý nhóm',
                      //         readonly: true,
                      //         onTap: () async {
                      //           final data = await Navigator.push(context, MaterialPageRoute(
                      //             builder: (context) => AdminTeamFilter(teamList: getTeamListInDepartment(department: _filterDepartmentPerm!)),
                      //           ));
                      //           if(data != null){
                      //             _filterTeamPerm = data;
                      //             setState(() {
                      //               _teamPermNameString = _filterTeamPerm!.name;
                      //             });
                      //           }
                      //         },
                      //       ),
                      //     ),
                      //============================================================Nút tạo mới
                      const SizedBox(height: 50.0,),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.blueGrey,
              ),
              // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Tạo tài khoản cho nhân viên",
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

  Future<bool> _registerAnAccount() async {

    bool result = false;

    if(_filterRole != null && _filterBlockId != null){

      RegisterAccount registerAccount = RegisterAccount(
          email: _accountEmail.text,
          roleId: _filterRole!.roleId,
          blockId: _filterBlockId!,
          teamId: _filterTeam?.teamId,
          departmentId: _filterDepartment?.departmentId,
          manageDepartmentId: _filterRole!.roleId != 6 ? _filterRole!.roleId != 2 ? _filterDepartment?.departmentId : _filterDepartmentPerm?.departmentId : null,
          manageTeamId: ( _filterRole!.roleId != 2 && _filterRole!.roleId != 6 ) ? _filterTeam?.teamId : null,
          createContactPermissionId: _contactCreateId ?? 0,
          createDealPermissionId: _dealCreateId ?? 0,
          createIssuePermissionId: _issueCreateId ?? 0,
          deleteContactPermissionId: _contactDeleteId ?? 0,
          deleteDealPermissionId:  _dealDeleteId ?? 0,
          deleteIssuePermissionId: _issueDeleteId ?? 0,
          updateAttendancePermissionId: _attendanceUpdateId ?? 0,
          updateContactPermissionId: _contactUpdateId ?? 0,
          updateDealPermissionId: _dealUpdateId ?? 0,
          updateIssuePermissionId: _issueUpdateId ?? 0,
          viewAccountPermissionId: _accountViewId ?? 0,
          viewAttendancePermissionId: _attendanceViewId ?? 0,
          viewContactPermissionId: _contactViewId ?? 0,
          viewDealPermissionId: _dealViewId ?? 0,
          viewIssuePermissionId: _issueViewId ?? 0
      );

      RegisterAccount? data = await AccountRegisterViewModel().registerAnAccount(registerAccount);
      if(data != null) {
        result = true;
      }else{
        result = false;
      }
      return result;
    }else{
      return result;
    }
  }
}
