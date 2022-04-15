import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/application.dart';
import 'package:login_sample/view_models/application_view_model.dart';
import 'package:login_sample/views/employee/employee_application_list.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/models/providers/account_provider.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';
import 'package:login_sample/widgets/IconTextButtonSmall2.dart';
import 'package:provider/provider.dart';

class EmployeeLateExcuse extends StatefulWidget {
  const EmployeeLateExcuse({Key? key}) : super(key: key);

  @override
  _EmployeeLateExcuseState createState() => _EmployeeLateExcuseState();
}

class _EmployeeLateExcuseState extends State<EmployeeLateExcuse> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  Account? _currentAccount;
  double? _currentTimeCalculated;
  String _lateExcuseDateString = '', _expectedWorkingTimeString = '', _expectedWorkingTimeError = '', _periodOfDayError = '';
  DateTime? _assignedDate, _expectedWorkingTime, _currentDate, _currentTime;
  int? _periodOfDayId, _applicationTypeId;
  final TextEditingController _description = TextEditingController();
  bool _isAllowTime = true;

  @override
  void initState() {
    super.initState();
    _currentAccount = Provider.of<AccountProvider>(context, listen: false).account;
    _currentDate = DateTime.tryParse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    _currentTime = _currentDate!.add(Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute));
    _currentTimeCalculated = _currentTime!.hour + _currentTime!.minute/100;
    print(_currentDate );
    print(_currentTime);
  }

  @override
  void dispose() {
    super.dispose();
    _description.dispose();
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

                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: CustomDropdownFormField2(
                          value: _applicationTypeId != null ? applicationTypesNames[_applicationTypeId!] : null,
                          label: 'Loại đơn',
                          hintText: const Text(''),
                          items: applicationTypesNames,
                          onChanged: (value){
                            for(int i = 0; i < applicationTypes.length; i++){
                              if(value.toString() == applicationTypes[i].name){
                                setState(() {
                                  _applicationTypeId = applicationTypes[i].applicationTypeId;
                                });
                              }
                            }
                            if(_applicationTypeId == 0){
                              _isAllowTime = true;
                              _expectedWorkingTime = null;
                              _expectedWorkingTimeString = '';
                              _periodOfDayId = null;
                              _periodOfDayError = '';
                            }else if(_applicationTypeId == 1){
                              setState(() {
                                _isAllowTime = true;
                                _expectedWorkingTime = null;
                                _expectedWorkingTimeString = '';
                                _periodOfDayId = null;
                                _periodOfDayError = '';
                              });
                            }
                          }
                      ),
                    ),


                    if(_applicationTypeId != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: CustomEditableTextFormField(
                            text: _lateExcuseDateString,
                            title: _applicationTypeId == 1 ? 'Xin đi trễ ngày' : 'Xin nghỉ phép ngày',
                            readonly: true,
                            onTap: () async {
                              final excuseDate = await DatePicker.showDatePicker(
                                context,
                                locale : LocaleType.vi,
                                minTime: DateTime.now(),
                                currentTime: DateTime.now(),
                                maxTime: DateTime.now().add(const Duration(days: 36500)),
                              );
                              if(excuseDate != null){
                                setState(() {
                                  _assignedDate =  DateTime.tryParse(DateFormat('yyyy-MM-dd').format(excuseDate));
                                  _lateExcuseDateString = 'Ngày ${DateFormat('dd-MM-yyyy').format(_assignedDate!)}';
                                  _isAllowTime = true;
                                  _expectedWorkingTime = null;
                                  _expectedWorkingTimeString = '';
                                  _periodOfDayId = null;
                                  _periodOfDayError = '';
                                });

                              }
                            },
                          ),
                      ),

                    if(_applicationTypeId != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: CustomDropdownFormField2(
                            value: _periodOfDayId != null ? periodOfDayNames[_periodOfDayId!] : null,
                            label: _applicationTypeId == 1 ? 'Xin đi trễ buổi' : 'Xin nghỉ phép buổi',
                            hintText: const Text(''),
                            items: _applicationTypeId == 1 ? periodOfDayNamesFilter : periodOfDayNames,
                            onChanged: (value){
                              for(int i = 0; i < periodOfDay.length; i++){
                                if(value.toString() == periodOfDay[i].name){
                                  setState(() {
                                    _periodOfDayId = periodOfDay[i].periodOfDayId;
                                  });
                                }
                              }
                              if( (_applicationTypeId != null) && (_periodOfDayId == 0 || _periodOfDayId == 2) && _assignedDate == _currentDate && _currentTimeCalculated! >= 8.30 ){
                                setState(() {
                                  _isAllowTime = false;
                                  _periodOfDayError = 'Bạn không thể gửi ${applicationTypesNames[_applicationTypeId!]} cho ${periodOfDayNames[_periodOfDayId!]} vì đã quá 8 giờ 30';
                                  _periodOfDayId = null;
                                });
                              }else if( (_applicationTypeId != null) && _periodOfDayId == 1 && _assignedDate == _currentDate && _currentTimeCalculated! >= 12.30 ){
                                setState(() {
                                  _isAllowTime = false;
                                  _periodOfDayError = 'Bạn không thể gửi ${applicationTypesNames[_applicationTypeId!]} cho ${periodOfDayNames[_periodOfDayId!]} vì đã quá 12 giờ 30';
                                  _periodOfDayId = null;
                                });
                              }else{
                                setState(() {
                                  _isAllowTime = true;
                                  _periodOfDayError = '';
                                });
                              }
                              print(_periodOfDayId);
                              setState(() {
                                _expectedWorkingTime = null;
                                _expectedWorkingTimeString = '';
                              });

                            }
                        ),
                      ),

                    if(_isAllowTime == false && _periodOfDayError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text( _periodOfDayError, style: const TextStyle(color: Colors.red),),
                      ),

                    //Thời gian dự kiến đến công ty
                    if(_periodOfDayId != null && _assignedDate != null && _applicationTypeId == 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: CustomEditableTextFormField(
                          text: _expectedWorkingTimeString,
                          title: 'Thời gian dự kiến đến công ty',
                          readonly: true,
                          onTap: () async {
                            DatePicker.showTimePicker(context,
                                showSecondsColumn: false,
                                showTitleActions: true,
                                onConfirm: (date){
                                  _expectedWorkingTime = DateTime.tryParse(DateFormat('yyyy-MM-dd').format(_assignedDate!));
                                  _expectedWorkingTime = _assignedDate?.add(Duration(hours: date.hour, minutes: date.minute));
                                  _expectedWorkingTimeString = DateFormat.Hm().format(date);
                                  print(_assignedDate);
                                  print(_expectedWorkingTime);
                                  print(date);

                                  if(_periodOfDayId == 0){
                                    if(  ( (date.hour + date.minute/100) < 9.30 ) || ( (date.hour + date.minute/100) > 10.30 ) ){
                                      setState(() {
                                        _isAllowTime = false;
                                        _expectedWorkingTimeError = 'Bạn chỉ được xin phép đi trễ từ 9 giờ 30 - 10 giờ 30';
                                        _expectedWorkingTime = null;
                                        _expectedWorkingTimeString = '';
                                      });
                                    }else{
                                      setState(() {
                                        _isAllowTime = true;
                                        _expectedWorkingTimeError = '';
                                      });
                                    }
                                  }else if(_periodOfDayId == 1){
                                    if(  ( (date.hour + date.minute/100) < 13.30 ) || (date.hour + date.minute/100) > 14.30 ){
                                      setState(() {
                                        _isAllowTime = false;
                                        _expectedWorkingTimeError = 'Bạn chỉ được xin phép đi trễ từ 13 giờ 30 - 14 giờ 30';
                                        _expectedWorkingTime = null;
                                        _expectedWorkingTimeString = '';
                                      });
                                    }else{
                                      setState(() {
                                        _isAllowTime = true;
                                        _expectedWorkingTimeError = '';
                                      });
                                    }
                                  }
                                },
                                locale: LocaleType.vi
                            );
                          },
                      ),
                    ),
                    if(_isAllowTime == false && _expectedWorkingTimeError.isNotEmpty)Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Center(child: Text(_expectedWorkingTimeError, style: const TextStyle(color: Colors.red),)),
                    ),

                    //Lý do
                    const SizedBox(height: 20.0,),
                    CustomEditableTextFormField(
                        text: _description.text.isEmpty ? '' : _description.text,
                        title: 'Lý do',
                        readonly: false,
                        textEditingController: _description,
                        inputNumberOnly: false,
                        isLimit: true,
                        limitNumbChar: 100,
                    ),

                    //Nút gửi đơn xin phép đi trễ
                    const SizedBox(height: 20.0,),
                    CustomTextButton(
                        color: mainBgColor,
                        text: 'Gửi đơn',
                        onPressed: () async {
                          if(!_formKey.currentState!.validate() || _isAllowTime == false){
                            return;
                          }
                          showLoaderDialog(context);
                          bool data = await _sendApplication();
                          if(data == true){
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gửi ${applicationTypesNames[_applicationTypeId!]} thành công') ));
                          }else{
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gửi ${applicationTypesNames[_applicationTypeId!]} thất bại') ));
                          }
                        },
                    ),
                    const SizedBox(height: 20.0),
                    IconTextButtonSmall2(
                        imageUrl: 'assets/images/attendance-report.png',
                        text: 'Xem danh sách đơn xin phép',
                        colorsButton: const [Colors.green, Colors.white],
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const EmployeeApplicationList()
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
                "Gửi đơn xin phép",
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

  Future<bool> _sendApplication() async {
    Application application = Application(
        accountId: _currentAccount!.accountId!,
        assignedDate: _assignedDate!,
        description: _description.text,
        expectedWorkingTime: _applicationTypeId == 0 ? null : _expectedWorkingTime!,
        applicationTypeId: _applicationTypeId!,
        periodOfDayId: _periodOfDayId!,
    );

    bool result = await ApplicationViewModel().sendApplication(application);

    return result;
  }
}

