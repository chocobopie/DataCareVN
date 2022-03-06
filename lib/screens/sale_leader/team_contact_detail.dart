import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/temp/contact_temp.dart';
import 'package:login_sample/utilities/utils.dart';

class TeamContactDetail extends StatefulWidget {
  const TeamContactDetail({Key? key, required this.contact}) : super(key: key);

  final Contact contact;

  @override
  _TeamContactDetailState createState() => _TeamContactDetailState();
}

class _TeamContactDetailState extends State<TeamContactDetail> {

  String name = '';
  String email = '';
  String phoneNumber = '';
  String contactOwner = '';
  String createTime = '';
  String company = '';

  String? selectedValue;
  List<String> items = [
    'Đóng',
    'Mở',
  ];

  @override
  Widget build(BuildContext context) {
    double leftRight = MediaQuery.of(context).size.width * 0.004;
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

                    //Employee name
                    SizedBox(
                      child: TextField(
                        onChanged: (val) {
                              name = val;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Tên khách hàng',
                          hintText: widget.contact.name,
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
                    //Employee email
                    SizedBox(
                      child: TextField(
                        onChanged: (val) {
                              email = val;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Email',
                          hintText: widget.contact.email,
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
                    //Phone number
                    SizedBox(
                      child: TextField(
                        onChanged: (val) {
                              phoneNumber = val;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Số điện thoại',
                          hintText: widget.contact.phoneNumber,
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

                    SizedBox(
                      child: TextField(
                        onChanged: (val) {
                          company = val;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Tên công ty',
                          hintText: widget.contact.company,
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

                    SizedBox(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Ngày thêm',
                          hintText: 'Ngày ${DateFormat('dd-MM-yyyy').format(widget.contact.createDate).substring(0, 10)}',
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
                    SizedBox(
                      child: TextField(
                        onChanged: (val) {
                              contactOwner = val;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Khách hàng của',
                          hintText: widget.contact.contactOwner,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                        children: [
                          //Nút xoá khách hàng
                          // Container(
                          //   width: MediaQuery.of(context).size.width * 0.4,
                          //   decoration: BoxDecoration(
                          //     color: Colors.red,
                          //     borderRadius: const BorderRadius.all(
                          //       Radius.circular(10.0),
                          //     ),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Colors.grey.withOpacity(0.5),
                          //         blurRadius: 1,
                          //         offset: const Offset(0, 3), // changes position of shadow
                          //       ),
                          //     ],
                          //   ),
                          //   child: TextButton(
                          //     onPressed: () {
                          //       Contact contact = Contact(id: 'delete', name: name, email: email, phoneNumber: phoneNumber, createDate: widget.contact.createDate, contactOwner: contactOwner, company: widget.contact.company);
                          //       Navigator.pop(context, contact);
                          //     },
                          //     child: const Text(
                          //       'Xoá khách hàng',
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //   ),
                          // ),
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
                            child: TextButton(
                              onPressed: (){
                                   Contact contact = Contact(
                                       id: widget.contact.id,
                                       name: name.isEmpty ? widget.contact.name : name,
                                       email: email.isEmpty ? widget.contact.email : email,
                                       phoneNumber: phoneNumber.isEmpty ? widget.contact.phoneNumber : phoneNumber,
                                       createDate: widget.contact.createDate,
                                       contactOwner: contactOwner.isEmpty ? widget.contact.contactOwner : contactOwner,
                                       company: company.isEmpty ? widget.contact.company : company,
                                   );
                                   Navigator.pop(context, contact);
                              },
                              child: const Text(
                                'Lưu',
                                style: TextStyle(color: Colors.white),
                              ),
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
              iconTheme: const IconThemeData(color: Colors.blueGrey,),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text(
                widget.contact.name.toString(),
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
}
