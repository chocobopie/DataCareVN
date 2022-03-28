import 'package:flutter/material.dart';
import 'package:login_sample/utilities/utils.dart';

class EmployeeIssueAddNew extends StatefulWidget {
  const EmployeeIssueAddNew({Key? key}) : super(key: key);

  @override
  _EmployeeIssueAddNewState createState() => _EmployeeIssueAddNewState();
}

class _EmployeeIssueAddNewState extends State<EmployeeIssueAddNew> {
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
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
              child: ListView(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 10.0, right: 18.0, bottom: 5.0),
                children: <Widget>[
                  //ID hợp đồng
                  const SizedBox(height: 30.0,),
                  SizedBox(
                    child: TextField(
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0, right: 10.0),
                        labelText: 'ID hợp đồng',
                        hintText: 'ID',
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

                  //Tiêu đề
                  const SizedBox(height: 30.0,),
                  SizedBox(
                    child: TextField(
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0, right: 10.0),
                        labelText: 'Tiêu đề',
                        hintText: 'Nội dung tiêu đề',
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

                  //Tên người được thêm vào vấn đề
                  const SizedBox(height: 30.0,),
                  SizedBox(
                    child: TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0, right: 10.0),
                        labelText: 'Tên',
                        hintText: 'Tên người được thêm vào vấn đề',
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

                  //Nội dung vấn đề
                  const SizedBox(height: 30.0,),
                  SizedBox(
                    child: TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0, right: 10.0),
                        labelText: 'Nội dung',
                        hintText: 'Nội dung vấn đề',
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

                  const SizedBox(height: 40.0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      children: [
                        //Nút xoá
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              )
                          ),
                          child: TextButton(onPressed: (){},
                            child: const Text('Tạo lại', style: TextStyle(color: Colors.white),),
                          ),
                          width: MediaQuery.of(context).size.width * 0.4,
                        ),
                        const SizedBox(width: 40.0,),
                        //Bút lưu
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: TextButton(onPressed: (){},
                            child: const Text('Thêm mới', style: TextStyle(color: Colors.white),),
                          ),
                          width: MediaQuery.of(context).size.width * 0.4,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.blueGrey,
              ), // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Tạo vấn đề mới",
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
}
