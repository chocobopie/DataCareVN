import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/temp/user_temp.dart';
import 'package:login_sample/utilities/utils.dart';

class HrManagerAccountDetail extends StatefulWidget {
  const HrManagerAccountDetail({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _HrManagerAccountDetailState createState() => _HrManagerAccountDetailState();
}

class _HrManagerAccountDetailState extends State<HrManagerAccountDetail> {

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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[

                    //Tên nhân viên
                    SizedBox(
                      child: TextField(
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Họ và tên nhân viên',
                          hintText: widget.user.name,
                          labelStyle: const TextStyle(
                            color: defaultFontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        readOnly: true,
                      ),
                      width: 150.0,
                    ),
                    const SizedBox(height: 20.0,),

                    //Email nhân viên
                    SizedBox(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Email',
                          hintText: widget.user.email,
                          labelStyle: const TextStyle(
                            color: defaultFontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      width: 150.0,
                    ),
                    const SizedBox(height: 20.0,),

                    //Số điện thoại
                    SizedBox(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Số điện thoại',
                          hintText: widget.user.phoneNumber,
                          labelStyle: const TextStyle(
                            color: defaultFontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      width: 150.0,
                    ),
                    const SizedBox(height: 20.0,),

                    //Năm sinh
                    SizedBox(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Năm sinh',
                          hintText: 'Ngày ${DateFormat('dd-MM-yyyy').format(widget.user.dob).substring(0, 10)}',
                          labelStyle: const TextStyle(
                            color: defaultFontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      width: 150.0,
                    ),
                    const SizedBox(height: 20.0,),

                    //Ngày tham gia
                    SizedBox(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Ngày tham gia',
                          hintText: 'Ngày ${DateFormat('dd-MM-yyyy').format(widget.user.joinDate).substring(0, 10)}',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 107, 106, 144),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      width: 150.0,
                    ),
                    const SizedBox(height: 20.0,),

                    //Giới tính
                    SizedBox(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Giới tính',
                          hintText: widget.user.gender,
                          labelStyle: const TextStyle(
                            color: defaultFontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      width: 150.0,
                    ),
                    const SizedBox(height: 20.0,),

                    //Chức vụ
                    SizedBox(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Chức vụ',
                          hintText: widget.user.role,
                          labelStyle: const TextStyle(
                            color: defaultFontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      width: 150.0,
                    ),
                    const SizedBox(height: 20.0,),

                    //Nhóm
                    SizedBox(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Thuộc nhóm',
                          hintText: widget.user.team,
                          labelStyle: const TextStyle(
                            color: defaultFontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      width: 150.0,
                    ),
                    const SizedBox(height: 20.0,),

                    //Phòng ban
                    SizedBox(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Thuộc phòng ban',
                          hintText: widget.user.department,
                          labelStyle: const TextStyle(
                            color: defaultFontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      width: 150.0,
                    ),
                    const SizedBox(height: 20.0,),

                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 1,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text(
                widget.user.name.toString(),
                style: const TextStyle(
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
}
