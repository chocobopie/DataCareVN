import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:login_sample/widgets/CustomExpansionTile.dart';
import 'package:login_sample/utilities/utils.dart';

class AdminAccountAdd extends StatefulWidget {
  const AdminAccountAdd({Key? key}) : super(key: key);

  @override
  _AdminAccountAddState createState() => _AdminAccountAddState();
}

class _AdminAccountAddState extends State<AdminAccountAdd> {
  bool _saleEmployeePerm = true;
  bool _hrPerm = false;

  late final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  late final GlobalKey<FormFieldState> _key2 = GlobalKey<FormFieldState>();
  late final GlobalKey<FormFieldState> _key3 = GlobalKey<FormFieldState>();


  late String role = 'Nhân viên kinh doanh';
  late String empPermTemp = '';
  late String hrPermTemp = '';

  String? selectedValue;
  List<String> roles = [
    'Nhân viên kinh doanh',
    'Trưởng nhóm kinh doanh',
    'Trưởng phòng kinh doanh',
    'Kỹ thuật viên',
    'Thực tập sinh quản lý nhân sự'
  ];

  List<String> hrPerms = [
    'Một phòng ban',
    'Tất cả',
  ];

  List<String> hrPerms2 = [
    'Không cho phép',
    'Tất cả',
  ];

  List<String> empPerms = [
    'Không cho phép',
    'Cho phép',
  ];

  List<String> empPerms2 = [
    'Chỉ bản thân',
    'Chỉ trong nhóm',
    'Chỉ trong phòng ban'
  ];


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
                  //email box
                  SizedBox(
                    child: TextField(
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        labelText: 'Email',
                        hintText: 'Địa chỉ email của nhân viên',
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 107, 106, 144),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: const Icon(
                          Icons.mail,
                          color: Color.fromARGB(255, 107, 106, 144),
                          size: 18,
                        ),
                        floatingLabelStyle: const TextStyle(
                          color: Color.fromARGB(255, 107, 106, 144),
                          fontSize: 18,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 2),
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
                  const SizedBox(
                    height: 20.0,
                  ),
                  //Chọn chức vụ
                  DropdownButtonFormField2(
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(left: 20.0, right: 20.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Chức vụ',
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 107, 106, 144),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    isExpanded: true,
                    value: role,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 30,
                    buttonHeight: 50,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    items: roles
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Hãy chọn một chức vụ';
                      }
                    },
                    onChanged: (value) {
                      if (value.toString() == 'Nhân viên kinh doanh' ||
                          value.toString() == 'Trưởng nhóm kinh doanh' ||
                          value.toString() == 'Trưởng phòng kinh doanh' ||
                          value.toString() == 'Kỹ thuật viên') {
                        setState(() {
                          _key.currentState?.reset();
                          role = value.toString();
                          _saleEmployeePerm = true;
                          _hrPerm = false;
                        });
                        print(_saleEmployeePerm);
                      } else if (value.toString() == 'Thực tập sinh quản lý nhân sự') {
                        setState(() {
                          _key2.currentState?.reset();
                          role = value.toString();
                          _saleEmployeePerm = false;
                          _hrPerm = true;
                        });
                      }
                      print(role);
                    },
                    onSaved: (value) {
                      selectedValue = value.toString();
                    },
                  ),
                  //======================================================Quyền truy cập của nhân viên Sale===================================

                  if(_hrPerm == true) const SizedBox(height: 20.0,),
                  //Quyền quản lý tài khoản
                  if(_hrPerm == true) CustomExpansionTile(
                    key: _key,
                      label: 'Quyền quản lý tài khoản',
                      colors: const [Colors.blue, Colors.white],
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Xem', empPerms, empPermTemp),
                        ),
                      ]
                  ),
                  if(_hrPerm == true) const SizedBox(height: 20.0,),
                  //Quyền quản lý lương
                  if(_hrPerm == true) CustomExpansionTile(
                      key: _key2,
                      label: 'Quyền quản lý lương',
                      colors: const [Colors.green, Colors.white],
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Xem', empPerms2, empPermTemp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Chỉnh sửa', empPerms2, empPermTemp),
                        ),
                      ]
                  ),
                  if(_saleEmployeePerm == true) const SizedBox(height: 20.0,),
                  //Quyền quản lý thông tin liên lạc của khách hàng
                  if(_saleEmployeePerm == true) CustomExpansionTile(
                      label: 'Quyền quản lý thông tin khách hàng',
                      colors: const [Colors.yellow, Colors.white],
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Thêm', empPerms, empPermTemp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Xem', empPerms2, empPermTemp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Chỉnh sửa', empPerms2, empPermTemp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Xoá', empPerms2, empPermTemp),
                        ),
                      ]
                  ),
                  if(_saleEmployeePerm == true) const SizedBox(height: 20.0,),
                  //Quyền quản lý hợp đồng
                  if(_saleEmployeePerm == true) CustomExpansionTile(
                      label: 'Quyền quản lý hợp đồng',
                      colors: const [Colors.greenAccent, Colors.white],
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Thêm', empPerms, empPermTemp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Xem', empPerms2, empPermTemp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Chỉnh sửa', empPerms2, empPermTemp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Xoá', empPerms2, empPermTemp),
                        ),
                      ]
                  ),
                  if(_saleEmployeePerm == true) const SizedBox(height: 20.0,),
                  //Quyền quản lý vấn đề
                  if(_saleEmployeePerm == true) CustomExpansionTile(
                      label: 'Quyền quản lý vấn đề',
                      colors: const [Colors.orange, Colors.white],
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Thêm', empPerms, empPermTemp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Xem', empPerms2, empPermTemp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Chỉnh sửa', empPerms2, empPermTemp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Xoá', empPerms2, empPermTemp),
                        ),
                      ]
                  ),

                  //========================================================Quyền truy cập của HR=============================================
                  if(_hrPerm == true) const SizedBox(height: 20.0,),
                  //Quyền quản lý điểm danh
                  if(_hrPerm == true) CustomExpansionTile(
                      key: _key3,
                      label: 'Quyền quản lý điểm danh',
                      colors: const [Colors.green, Colors.white],
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Xem', hrPerms, hrPermTemp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Chỉnh sửa', hrPerms, hrPermTemp),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0,
                              left: leftRight,
                              right: leftRight,
                              bottom: 10.0),
                          child: buildDropdownButtonFormField2('Xoá', hrPerms, hrPermTemp),
                        ),
                      ]
                  ),
                  if(_hrPerm == true) const SizedBox(height: 20.0,),



                  //Nút tạo mới
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
