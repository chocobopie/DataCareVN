import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:login_sample/main.dart';
import 'package:login_sample/models/block.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/models/role.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/views/admin/admin_department_filter.dart';
import 'package:login_sample/views/admin/admin_team_filter.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomExpansionTile.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';
import 'package:login_sample/widgets/CustomReadOnlyTextField.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';

import 'admin_role_filter.dart';

class AdminAccountAdd extends StatefulWidget {
  const AdminAccountAdd({Key? key}) : super(key: key);

  @override
  _AdminAccountAddState createState() => _AdminAccountAddState();
}

class _AdminAccountAddState extends State<AdminAccountAdd> {

  final TextEditingController _accountEmail = TextEditingController();

  Block? _filterBlock;
  Department? _filterDepartment, _filterDepartmentPerm;
  Team? _filterTeam, _filterTeamPerm;
  Role? _filterRole;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _filterRoleString = '', _filterDepartmentString = '', _filterTeamString = '', _departmentPermNameString = '', _teamPermNameString = '';

  int? _contactCreateId, _contactViewId, _contactUpdateId, _contactDeleteId, _dealCreateId, _dealViewId, _dealUpdateId, _dealDeleteId, _issueCreateId, _issueViewId, _issueUpdateId, _issueDeleteId;
  int? _accountViewId, _accountCreateId, _accountUpdateId, _accountDeleteId, _attendanceViewId, _attendanceUpdateId;
  int? _filterViewId, _filterBlockId;


  @override
  void dispose() {
    super.dispose();
    _accountEmail.dispose();
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
            margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: ListView(
                  children: <Widget>[
                    //============================================================email box===================================================================
                    CustomEditableTextFormField(
                        isNull: false,
                        isEmailCheck: true,
                        borderColor: mainBgColor,
                        text: '',
                        title: 'Email của nhân viên',
                        readonly: false,
                        textEditingController: _accountEmail,
                    ),
                    const SizedBox(height: 20.0,),
                    //============================================================Chọn chức vụ===============================================================
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: CustomEditableTextFormField(
                          borderColor: mainBgColor,
                          text: _filterRoleString,
                          title: 'Chức vụ',
                          readonly: true,
                          onTap: () async {
                          final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminRoleFilter(isHrManagerFilter: true,) ));
                          if( data != null ){
                            setState(() {
                              _filterRole = data;
                              _filterRoleString = _filterRole!.name;
                              if(_filterRole!.roleId == 3 || _filterRole!.roleId == 4 || _filterRole!.roleId == 5){
                                _filterBlockId = 1;
                              }
                              if(_filterRole!.roleId == 2){
                                _filterBlockId = 0;
                              }
                              if(_filterRole!.roleId == 6){
                                _filterBlockId = 2;
                              }
                              _filterDepartmentString = '';
                              _filterDepartment = null;
                              _filterTeamString = '';
                              _filterTeam = null;
                            });
                          }
                        },
                      ),
                    ),
                    if(_filterBlockId != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: CustomReadOnlyTextField(
                          text: getBlock(blockId: _filterBlockId!).name,
                          title: 'Khối',
                      ),
                    ),
                    //============================================================Chọn phòng ban===============================================================
                    if(_filterBlockId != null)
                      if( getDepartmentListInBlock(block: getBlock(blockId: _filterBlockId!)).isNotEmpty )
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: CustomEditableTextFormField(
                        borderColor: mainBgColor,
                        text: _filterDepartmentString,
                        title: 'Phòng ban',
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
                    //============================================================Chọn nhóm===============================================================
                    if(_filterRole != null)
                    if(_filterDepartment != null && _filterRole!.roleId != 3)
                      if( getTeamListInDepartment(department: _filterDepartment!).isNotEmpty )
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: CustomEditableTextFormField(
                        borderColor: mainBgColor,
                        text: _filterTeamString,
                        title: 'Nhóm',
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
                    //============================================================Quyền truy cập của nhân viên Sale, KTV===================================
                    if(_filterRole != null)
                    if(_filterRole!.roleId == 3 || _filterRole!.roleId == 4 || _filterRole!.roleId == 5 || _filterRole!.roleId == 6)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: CustomExpansionTile(
                          label: 'Quyền xem thông tin khách hàng & hợp đồng & vấn đề',
                          colors: const [Colors.red, Colors.white],
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0, bottom: 15.0),
                              child: CustomDropdownFormField2(
                                  value: _filterViewId != null ? permissionStatusesNameUtilities[_filterViewId!] : null,
                                  label: 'Xem',
                                  hintText: Text(_filterViewId == null ? '' : permissionStatusesNameUtilities[_filterViewId!]),
                                  items: saleEmpViewPermNames,
                                  onChanged: (value){
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
                                        });
                                      }
                                    }
                                    _contactViewId = _filterViewId;
                                    _dealViewId = _filterViewId;
                                    _issueViewId = _filterViewId;
                                  }
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
                          label: 'Quyền quản lý thông tin khách hàng',
                          colors: const [Colors.yellow, Colors.white],
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                              child: CustomDropdownFormField2(
                                  label: 'Tạo mới',
                                  hintText: _contactCreateId != null ? Text(permissionStatusesNameUtilities[_contactCreateId!]) : const Text(''),
                                  items: saleEmpCreatePermNames,
                                  onChanged: null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                              child: CustomDropdownFormField2(
                                value: _contactUpdateId != null ? permissionStatusesNameUtilities[_contactUpdateId!] : null,
                                label: 'Chỉnh sửa',
                                hintText: _contactUpdateId != null ? Text(permissionStatusesNameUtilities[_contactUpdateId!]) : const Text(''),
                                items: saleEmpUpdateDeletePermNames,
                                onChanged: null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                              child: CustomDropdownFormField2(
                                value: _contactDeleteId != null ? permissionStatusesNameUtilities[_contactDeleteId!] : null,
                                label: 'Xóa',
                                hintText: _contactDeleteId != null ? Text(permissionStatusesNameUtilities[_contactDeleteId!]) : const Text(''),
                                items: saleEmpUpdateDeletePermNames,
                                onChanged: null,
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
                        label: 'Quyền quản lý hợp đồng',
                        colors: const [Colors.green, Colors.white],
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                            child: CustomDropdownFormField2(
                              label: 'Tạo mới',
                              hintText: _dealCreateId != null ? Text(permissionStatusesNameUtilities[_dealCreateId!]) : const Text(''),
                              items: saleEmpCreatePermNames,
                              onChanged: null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                            child: CustomDropdownFormField2(
                              value: _dealUpdateId != null ? permissionStatusesNameUtilities[_dealUpdateId!] : null,
                              label: 'Chỉnh sửa',
                              hintText: _dealUpdateId != null ? Text(permissionStatusesNameUtilities[_dealUpdateId!]) : const Text(''),
                              items: saleEmpUpdateDeletePermNames,
                              onChanged: null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                            child: CustomDropdownFormField2(
                              value: _dealDeleteId != null ? permissionStatusesNameUtilities[_dealDeleteId!] : null,
                              label: 'Xóa',
                              hintText: _dealDeleteId != null ? Text(permissionStatusesNameUtilities[_dealDeleteId!]) : const Text(''),
                              items: saleEmpUpdateDeletePermNames,
                              onChanged: null,
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
                        label: 'Quyền quản lý vấn đề',
                        colors: const [Colors.orange, Colors.white],
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                            child: CustomDropdownFormField2(
                              label: 'Tạo mới',
                              hintText: _issueCreateId != null ? Text(permissionStatusesNameUtilities[_issueCreateId!]) : const Text(''),
                              items: saleEmpCreatePermNames,
                              onChanged: null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                            child: CustomDropdownFormField2(
                              value: _issueUpdateId != null ? permissionStatusesNameUtilities[_issueUpdateId!] : null,
                              label: 'Chỉnh sửa',
                              hintText: _issueUpdateId != null ? Text(permissionStatusesNameUtilities[_issueUpdateId!]) : const Text(''),
                              items: saleEmpUpdateDeletePermNames,
                              onChanged: null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                            child: CustomDropdownFormField2(
                              value: _issueDeleteId != null ? permissionStatusesNameUtilities[_issueDeleteId!] : null,
                              label: 'Xóa',
                              hintText: _issueDeleteId != null ? Text(permissionStatusesNameUtilities[_issueDeleteId!]) : const Text(''),
                              items: saleEmpUpdateDeletePermNames,
                              onChanged: null,
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
                        label: 'Quyền quản lý tài khoản nhân viên',
                        colors: const [Colors.blue, Colors.white],
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                            child: CustomDropdownFormField2(
                              label: 'Xem',
                              hintText: _accountViewId != null ? Text(permissionStatusesNameUtilities[_accountViewId!]) : const Text(''),
                              items: hrInternCreatePermNames,
                              onChanged: null,
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
                        label: 'Quyền quản lý điểm danh',
                        colors: const [Colors.yellow, Colors.white],
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                            child: CustomDropdownFormField2(
                              label: 'Xem',
                              hintText: _attendanceViewId != null ? Text(permissionStatusesNameUtilities[_accountViewId!]) : const Text(''),
                              items: hrInternViewPermNames,
                              onChanged: null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                            child: CustomDropdownFormField2(
                              label: 'Chỉnh sửa',
                              hintText: _attendanceUpdateId != null ? Text(permissionStatusesNameUtilities[_accountUpdateId!]) : const Text(''),
                              items: hrInternViewPermNames,
                              onChanged: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //==========================================================Quyền truy cập KTV=========================================================
                    if(_filterViewId != null)
                    if(_filterRole != null && (_filterViewId == 4 || _filterViewId == 3))
                    if(_filterRole!.roleId == 2 ||_filterRole!.roleId == 6)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomEditableTextFormField(
                          borderColor: mainBgColor,
                          text: _departmentPermNameString,
                          title: 'Quản lý phòng ban',
                          readonly: true,
                          onTap: () async {
                            final data = await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => AdminDepartmentFilter(departmentList: departments),
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
                          if(_filterViewId != null && _filterRole != null && _filterDepartmentPerm != null)
                            if(_filterRole!.roleId == 6 && _filterViewId == 3)
                              if(getTeamListInDepartment(department: _filterDepartmentPerm!).isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: CustomEditableTextFormField(
                              borderColor: mainBgColor,
                              text: _teamPermNameString,
                              title: 'Quản lý nhóm',
                              readonly: true,
                              onTap: () async {
                                final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminTeamFilter(
                                    teamList: getTeamListInDepartment(department: _filterDepartmentPerm!) )
                                ));
                                if(data != null){
                                  _filterTeamPerm = data;
                                  setState(() {
                                    _teamPermNameString = _filterTeamPerm!.name;
                                  });
                                }
                              },
                            ),
                          ),
                    //============================================================Nút tạo mới
                    const SizedBox(height: 20.0,),
                    CustomTextButton(
                        color: Colors.blueAccent,
                        text: 'Tạo mới',
                        onPressed: (){
                          if(!_formKey.currentState!.validate()){
                            return;
                          }

                        },
                    ),
                  ],
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
                "Thêm tài khoản",
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

  DropdownButtonFormField2<String> buildDropdownButtonFormField2(String label, List items, String result) {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 15.0, right: 10.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: label,
        labelStyle: const TextStyle(
          color: defaultFontColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      isExpanded: true,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 20,
      buttonHeight: 50,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Hãy chọn quyền truy cập';
        }
      },
      onChanged: (value) {
        setState(() {
          result = value.toString();
          print(result);
        });
      },
      // onSaved: (value) {
      //   selectedValue = value.toString();
      // },
    );
  }

}
