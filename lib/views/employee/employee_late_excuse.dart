import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/excuse_late.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/views/employee/employee_late_excuse_list.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/hr_manager/hr_manager_attendance_report_list.dart';
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
  String _lateReason = '';
  bool _isAllowTime = true;

  final double _panelHeightClosed = 50.0;

  List<UserAttendance> userLateExcuses = [
    UserAttendance(id: '1', name: 'Nguyễn Văn A', team: 'Nhóm 1', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '2', name: 'Nguyễn Văn B', team: 'Nhóm 2', department: 'Đào tạo', attendance: 'Mới'),
    UserAttendance(id: '3', name: 'Nguyễn Văn C', team: 'Nhóm 3', department: 'Đào tạo', attendance: 'Chấp nhận'),
    UserAttendance(id: '4', name: 'Nguyễn Văn D', team: 'Nhóm 4', department: 'Đào tạo', attendance: 'Chấp nhận'),
    UserAttendance(id: '5', name: 'Nguyễn Văn E', team: 'Nhóm 5', department: 'Đào tạo', attendance: 'Chấp nhận'),
    UserAttendance(id: '6', name: 'Nguyễn Văn F', team: 'Nhóm 6', department: 'Đào tạo', attendance: 'Chấp nhận'),
    UserAttendance(id: '7', name: 'Nguyễn Văn G', team: 'Nhóm 7', department: 'Đào tạo', attendance: 'Từ chối'),
    UserAttendance(id: '8', name: 'Nguyễn Văn H', team: 'Nhóm 8', department: 'Đào tạo', attendance: 'Từ chối'),
    UserAttendance(id: '9', name: 'Nguyễn Văn I', team: 'Nhóm 9', department: 'Đào tạo', attendance: 'Từ chối'),
  ];

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
                    //Ngày xin đi trễ
                    const SizedBox(height: 20.0,),
                    CustomEditableTextFormField(
                        text: _lateExcuseDate,
                        title: 'Ngày xin đi trễ',
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
                              _lateExcuseDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(excuseDate)}';
                            });
                            print('Ngày xin đi trễ $excuseDate');
                          }
                        },

                    ),

                    //Thời gian dự kiến đến công ty
                    const SizedBox(height: 20.0,),
                    CustomEditableTextFormField(
                        text: _lateExcuseTime,
                        title: 'Thời gian dự kiến đến công ty',
                        readonly: true,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DatePicker.showTime12hPicker(context,
                              showTitleActions: true,
                              onConfirm: (date){
                                _lateExcuseTime = DateFormat.jm().format(date);
                                if( (date.hour + date.month/100) > 9 ){
                                  setState(() {
                                    _isAllowTime = false;
                                    _lateExcuseError = 'Bạn không được phép đi trễ quá 9 giờ sáng';
                                  });
                                }else{
                                  setState(() {
                                    _isAllowTime = true;
                                    _lateExcuseError = '';
                                  });
                                }
                                print(_lateExcuseTime);
                              },
                              locale: LocaleType.vi
                          );
                        },
                    ),
                    Center(child: Text(_lateExcuseError, style: const TextStyle(color: Colors.red),)),

                    //Lý do
                    const SizedBox(height: 10.0,),
                    CustomEditableTextFormField(
                        text: _lateReason,
                        title: 'Lý do',
                        readonly: false
                    ),

                    //Nút gửi đơn xin phép đi trễ
                    const SizedBox(height: 20.0,),
                    CustomTextButton(
                        color: Colors.blue,
                        text: 'Gửi',
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

  Widget _buildSlideUpPanel(){
    return SlidingUpPanel(
      parallaxEnabled: true,
      parallaxOffset: .5,
      maxHeight: MediaQuery.of(context).size.height * 0.9,
      minHeight: _panelHeightClosed,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      header: Padding(
        padding: const EdgeInsets.only(left: 70.0),
        child: TextButton.icon(
            onPressed: (){},
            icon: const Icon(Icons.arrow_upward),
            label: const Text('Danh sách đơn xin phép đi trễ')
        ),
      ),
      panel: Card(
        elevation: 20.0,
        color: mainBgColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 50.0),
        child: ListView.builder(
            itemCount: userLateExcuses.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                child: ListTile(
                  selected: true,
                  selectedTileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  trailing: Text(userLateExcuses[index].attendance),
                  leading: SizedBox(
                    height: 50.0,
                    width: 200.0,
                    child: Row(
                      children: [
                        Column(
                          children: <Widget>[
                            const Text('Ngày gửi', style: TextStyle(color: defaultFontColor),),
                            Text(DateFormat('dd-MM-yyyy').format(DateTime.now())),
                          ],
                        ),
                        const SizedBox(width: 40.0,),
                        Column(
                          children: <Widget>[
                            const Text('Ngày xin đi trễ', style: TextStyle(color: defaultFontColor),),
                            Text(DateFormat('dd-MM-yyyy').format(DateTime.now())),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}

