import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:login_sample/main.dart';
import 'package:login_sample/models/block.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/models/role.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomExpansionTile.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/CustomOutlinedButton.dart';

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
  Team? _filterTeam;
  Role? _filterRole;

  String _filterRoleString = '';

  int? _contactCreateId, _contactViewId, _contactUpdateId, _contactDeleteId, _dealCreateId, _dealViewId, _dealUpdateId, _dealDeleteId, _issueCreateId, _issueViewId, _issueUpdateId, _issueDeleteId;
  int? _accountViewId, _accountCreateId, _accountUpdateId, _accountDeleteId, _attendanceViewId, _attendanceUpdateId;

  @override
  void dispose() {
    super.dispose();
    _accountEmail.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double leftRight = MediaQuery.of(context).size.width * 0.05;
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
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView(
                children: <Widget>[
                  //============================================================email box
                  CustomEditableTextFormField(
                      borderColor: mainBgColor,
                      text: '',
                      title: 'Email của nhân viên',
                      readonly: false,
                      textEditingController: _accountEmail,
                  ),
                  const SizedBox(height: 20.0,),
                  //============================================================Chọn chức vụ
                  CustomEditableTextFormField(
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
                          print(_filterRole!.name);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20.0,),
                  //============================================================Quyền truy cập của nhân viên Sale, KTV===================================
                  if(_filterRole != null)
                  if(_filterRole!.roleId == 3 || _filterRole!.roleId == 4 || _filterRole!.roleId == 5 || _filterRole!.roleId == 6)
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
                              label: 'Xem',
                              hintText: _contactViewId != null ? Text(permissionStatusesNameUtilities[_contactViewId!]) : const Text(''),
                              items: saleEmpViewPermNames,
                              onChanged: null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                            child: CustomDropdownFormField2(
                              label: 'Chỉnh sửa',
                              hintText: _contactUpdateId != null ? Text(permissionStatusesNameUtilities[_contactUpdateId!]) : const Text(''),
                              items: saleEmpUpdateDeletePermNames,
                              onChanged: null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                            child: CustomDropdownFormField2(
                              label: 'Xóa',
                              hintText: _contactDeleteId != null ? Text(permissionStatusesNameUtilities[_contactDeleteId!]) : const Text(''),
                              items: saleEmpUpdateDeletePermNames,
                              onChanged: null,
                            ),
                          ),
                        ],
                    ),
                  ),
                  if(_filterRole != null)
                  if(_filterRole!.roleId == 3 || _filterRole!.roleId == 4 || _filterRole!.roleId == 5 || _filterRole!.roleId == 6)
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
                            label: 'Xem',
                            hintText: _dealViewId != null ? Text(permissionStatusesNameUtilities[_dealViewId!]) : const Text(''),
                            items: saleEmpViewPermNames,
                            onChanged: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                          child: CustomDropdownFormField2(
                            label: 'Chỉnh sửa',
                            hintText: _dealUpdateId != null ? Text(permissionStatusesNameUtilities[_dealUpdateId!]) : const Text(''),
                            items: saleEmpUpdateDeletePermNames,
                            onChanged: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                          child: CustomDropdownFormField2(
                            label: 'Xóa',
                            hintText: _dealDeleteId != null ? Text(permissionStatusesNameUtilities[_dealDeleteId!]) : const Text(''),
                            items: saleEmpUpdateDeletePermNames,
                            onChanged: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(_filterRole != null)
                  if(_filterRole!.roleId == 3 || _filterRole!.roleId == 4 || _filterRole!.roleId == 5 || _filterRole!.roleId == 6)
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
                            label: 'Xem',
                            hintText: _issueViewId != null ? Text(permissionStatusesNameUtilities[_issueViewId!]) : const Text(''),
                            items: saleEmpViewPermNames,
                            onChanged: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                          child: CustomDropdownFormField2(
                            label: 'Chỉnh sửa',
                            hintText: _issueUpdateId != null ? Text(permissionStatusesNameUtilities[_issueUpdateId!]) : const Text(''),
                            items: saleEmpUpdateDeletePermNames,
                            onChanged: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                          child: CustomDropdownFormField2(
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
                            label: 'Tạo mới',
                            hintText: _accountCreateId != null ? Text(permissionStatusesNameUtilities[_accountCreateId!]) : const Text(''),
                            items: hrInternViewPermNames,
                            onChanged: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                          child: CustomDropdownFormField2(
                            label: 'Xem',
                            hintText: _accountViewId != null ? Text(permissionStatusesNameUtilities[_accountViewId!]) : const Text(''),
                            items: hrInternCreatePermNames,
                            onChanged: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                          child: CustomDropdownFormField2(
                            label: 'Chỉnh sửa',
                            hintText: _accountUpdateId != null ? Text(permissionStatusesNameUtilities[_accountUpdateId!]) : const Text(''),
                            items: hrInternUpdateDeletePermNames,
                            onChanged: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                          child: CustomDropdownFormField2(
                            label: 'Xóa',
                            hintText: _accountDeleteId != null ? Text(permissionStatusesNameUtilities[_accountDeleteId!]) : const Text(''),
                            items: hrInternUpdateDeletePermNames,
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
                  //============================================================Nút tạo mới
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.30,
                        right: MediaQuery.of(context).size.height * 0.15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 1,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        gradient: const LinearGradient(
                          stops: [0.02, 0.02],
                          colors: [Colors.blue, Colors.blue],
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Tạo mới',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
