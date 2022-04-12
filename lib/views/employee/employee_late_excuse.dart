import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/views/employee/employee_late_excuse_list.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/hr_manager/hr_manager_attendance_report_list.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EmployeeLateExcuse extends StatefulWidget {
  const EmployeeLateExcuse({Key? key}) : super(key: key);

  @override
  _EmployeeLateExcuseState createState() => _EmployeeLateExcuseState();
}

class _EmployeeLateExcuseState extends State<EmployeeLateExcuse> {

  final GlobalKey<FormState> _formKey = GlobalKey();

  String _lateExcuseDate = '', _lateExcuseTime = '', _lateExcuseError = '';
  DateTime? expectedLateDate;
  int? _periodOfDayId;
  final TextEditingController _lateReason = TextEditingController();
  bool _isAllowTime = true;

  @override
  void dispose() {
    super.dispose();
    _lateReason.dispose();
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
              height: MediaQuery.of(context).size.height * 0.3
          ),
          Card(
              elevation: 20.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              margin: const EdgeInsets.only(top: 90),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 5.0),
                  children: <Widget>[
                    //Xin đi trễ ngày
                    const SizedBox(height: 20.0,),
                    CustomEditableTextFormField(
                      text: _lateExcuseDate,
                      title: 'Xin đi trễ ngày',
                      readonly: true,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final excuseDate = await DatePicker.showDatePicker(
                          context,
                          locale : LocaleType.vi,
                          minTime: DateTime.now(),
                          currentTime: DateTime.now(),
                          maxTime: DateTime.now().add(const Duration(days: 36500)),
                        );
                        if(excuseDate != null){
                          setState(() {
                            expectedLateDate =  DateTime.tryParse(DateFormat('yyyy-MM-dd').format(excuseDate));
                            _lateExcuseDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(expectedLateDate!)}';
                          });
                          print('Ngày xin đi trễ $expectedLateDate');
                        }
                      },
                    ),
                    //Xin đi muộn ca làm việc
                    const SizedBox(height: 20,),
                    CustomDropdownFormField2(
                        value: _periodOfDayId != null ? periodOfDayNames[_periodOfDayId!] : null,
                        label: 'Xin đi muộn ca',
                        hintText: const Text(''),
                        items: periodOfDayNamesFilter,
                        onChanged: (value){
                          for(int i = 0; i < periodOfDay.length; i++){
                            if(value.toString() == periodOfDay[i].name){
                              setState(() {
                                _periodOfDayId = periodOfDay[i].periodOfDayId;
                              });
                            }
                          }
                        }
                    ),
                    //Thời gian dự kiến đến công ty
                    const SizedBox(height: 20.0,),
                    if(_periodOfDayId != null)
                    CustomEditableTextFormField(
                        text: _lateExcuseTime,
                        title: 'Thời gian dự kiến đến công ty',
                        readonly: true,
                        onTap: () async {
                          DatePicker.showTimePicker(context,
                              showSecondsColumn: false,
                              showTitleActions: true,
                              onConfirm: (date){
                                _lateExcuseTime = DateFormat.Hm().format(date);
                                print(date.hour);

                                if(_periodOfDayId == 0){
                                  if(  ( (date.hour + date.minute/100) >= 9.30 ) && ( (date.hour + date.minute/100) <= 10.30 ) ){
                                    setState(() {
                                      _isAllowTime = false;
                                      _lateExcuseError = 'Bạn chỉ được xin phép đi trễ từ 9 giờ 30 - 10 giờ 30';
                                    });
                                  }else{
                                    setState(() {
                                      _isAllowTime = true;
                                      _lateExcuseError = '';
                                    });
                                  }
                                }else if(_periodOfDayId == 1){
                                  if(  ( (date.hour + date.minute/100) < 9.30 ) ){
                                    setState(() {
                                      _isAllowTime = false;
                                      _lateExcuseError = 'Bạn chỉ được xin phép đi trễ từ 9 giờ 30 - 10 giờ 30';
                                    });
                                  }else{
                                    setState(() {
                                      _isAllowTime = true;
                                      _lateExcuseError = '';
                                    });
                                  }
                                }

                              },
                              locale: LocaleType.vi
                          );
                        },
                    ),
                    if(_isAllowTime == false)Center(child: Text(_lateExcuseError, style: const TextStyle(color: Colors.red),)),

                    //Lý do
                    const SizedBox(height: 20.0,),
                    CustomEditableTextFormField(
                        text: _lateReason.text.isEmpty ? '' : _lateReason.text,
                        title: 'Lý do',
                        readonly: false,
                        textEditingController: _lateReason,
                        inputNumberOnly: false,
                        isLimit: true,
                        limitNumbChar: 250,
                    ),

                    //Nút gửi đơn xin phép đi trễ
                    const SizedBox(height: 20.0,),
                    CustomTextButton(
                        color: mainBgColor,
                        text: 'Gửi đơn',
                        onPressed: (){
                          if(!_formKey.currentState!.validate()){
                            return;
                          }
                        },
                    ),
                    const SizedBox(height: 20.0),
                    IconTextButtonSmall2(
                        imageUrl: 'assets/images/attendance-report.png',
                        text: 'Danh sách đơn xin đi trễ',
                        colorsButton: const [Colors.green, Colors.white],
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const EmployeeLateExcuseList()
                          ));
                        }
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
              // Add AppBar here only
              iconTheme: const IconThemeData(color: Colors.blueGrey),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Xin đi trễ",
                style: TextStyle(
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

