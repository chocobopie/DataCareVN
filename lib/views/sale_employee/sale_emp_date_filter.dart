import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/fromDateToDate.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';
import 'package:login_sample/widgets/IconTextButtonSmall3.dart';

class SaleEmpDateFilter extends StatefulWidget {
  const SaleEmpDateFilter({Key? key}) : super(key: key);

  @override
  State<SaleEmpDateFilter> createState() => _SaleEmpDateFilterState();
}

class _SaleEmpDateFilterState extends State<SaleEmpDateFilter> {

  String fromDateString = '';
  String toDateString = '';
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

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
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            margin: const EdgeInsets.only(top: 100.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      //Từ ngày
                      SizedBox(
                        child: TextField(
                          readOnly: true,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final date = await DatePicker.showDatePicker(
                              context,
                              locale : LocaleType.vi,
                              minTime: DateTime.now().subtract(const Duration(days: 36500)),
                              currentTime: DateTime.now(),
                              maxTime: DateTime.now(),
                            );
                            if(date != null){
                              setState(() {
                                fromDateString = 'Ngày ${DateFormat('dd-MM-yyyy').format(date)}';
                                fromDate = date;
                              });
                              print('Từ ngày $date');
                            }
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.only(left: 20.0),
                            labelText: 'Từ ngày',
                            hintText: fromDateString.isNotEmpty ? fromDateString : 'Ngày ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
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
                        width: MediaQuery.of(context).size.width,
                      ),
                      const SizedBox(height: 20,),

                      //Đến ngày
                      SizedBox(
                        child: TextField(
                          readOnly: true,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final date = await DatePicker.showDatePicker(
                              context,
                              locale : LocaleType.vi,
                              minTime: DateTime.now().subtract(const Duration(days: 36499)),
                              currentTime: DateTime.now(),
                              maxTime: DateTime.now(),
                            );
                            if(date != null){
                              setState(() {
                                toDateString = 'Ngày ${DateFormat('dd-MM-yyyy').format(date)}';
                                toDate = date;
                              });
                              print('Đến ngày $date');
                            }
                          },
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.only(left: 20.0),
                            labelText: 'Đến ngày',
                            hintText: toDateString.isNotEmpty ? toDateString : 'Ngày ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
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
                        width: MediaQuery.of(context).size.width,
                      ),
                      const SizedBox(height: 20,),

                      Container(
                        width: MediaQuery.of(context).size.width,
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
                            if(fromDateString.isEmpty){
                              fromDateString = 'Ngày ${DateFormat('dd-MM-yyyy').format(DateTime.now())}';
                            }
                            if(toDateString.isEmpty){
                              toDateString = 'Ngày ${DateFormat('dd-MM-yyyy').format(DateTime.now())}';
                            }
                            if(fromDate.isBefore(toDate) && toDate.isAfter(fromDate)){
                              FromDateToDate fromDateToDate =  FromDateToDate(fromDateString: fromDateString, toDateString: toDateString, fromDate: fromDate, toDate: toDate);
                              Navigator.pop(context, fromDateToDate);
                            }else if(fromDate.isAfter(toDate) || toDate.isBefore(fromDate)){
                              print('Error');
                            }else{
                              FromDateToDate fromDateToDate =  FromDateToDate(fromDateString: fromDateString, toDateString: toDateString, fromDate: fromDate, toDate: toDate);
                              Navigator.pop(context, fromDateToDate);
                            }
                          },
                          child: const Text('Xác nhận', style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(color: Colors.blueGrey),// Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Lọc theo ngày",
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
