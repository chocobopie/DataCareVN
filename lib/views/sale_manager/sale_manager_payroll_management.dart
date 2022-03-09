import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/widgets/CustomMonthPicker.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/views/sale_manager/sale_manager_payroll_detail.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class SaleManagerPayrollManagement extends StatefulWidget {
  const SaleManagerPayrollManagement({Key? key}) : super(key: key);

  @override
  _SaleManagerPayrollManagementState createState() => _SaleManagerPayrollManagementState();
}

class _SaleManagerPayrollManagementState extends State<SaleManagerPayrollManagement> {

  DateTime _selectedMonth = DateTime.now();

  final List<Map> teams =
  List.generate(5, (index) => {"id": index, "name": "Nhóm $index"})
      .toList();

  final List<Map> employees =
  List.generate(10, (index) => {"id": index, "name": "Nhân viên $index"})
      .toList();

  @override
  Widget build(BuildContext context) {
    double leftRight = MediaQuery.of(context).size.width;
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
              margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 100.0),
              child: ListView(
                padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 5.0),
                children: <Widget>[

                  //Nút chọn tháng
                  Container(
                    width: 200.0,
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: TextButton.icon(
                      onPressed: () async {
                        // _onPressed(context: context);
                        final date = await DatePicker.showPicker(context,
                            pickerModel: CustomMonthPicker(
                                currentTime: DateTime.now(),
                                minTime: DateTime(2016),
                                maxTime: DateTime.now(),
                                locale: LocaleType.vi,
                            ),
                        );

                        if (date != null) {
                          setState(() {
                            _selectedMonth = date;
                            print(_selectedMonth);
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Tháng ${DateFormat('dd-MM-yyyy').format(_selectedMonth).substring(3, 10)}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),

          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: MediaQuery.of(context).size.height * 0.21),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Card(
                elevation: 100.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                child: ListView(
                   children: <Widget>[
                     Padding(
                       padding: EdgeInsets.only(left: leftRight * 0.04, right: leftRight * 0.04),
                       child: SizedBox(
                         child: TextField(
                           readOnly: true,
                           decoration: InputDecoration(
                             floatingLabelBehavior: FloatingLabelBehavior.always,
                             contentPadding: const EdgeInsets.only(left: 20.0),
                             labelText: 'Tổng doanh thu của phòng tháng ${DateFormat('dd-MM-yyyy').format(_selectedMonth).substring(3, 10)}',
                             hintText: '32.490.000 VNĐ',
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
                       ),
                     ),
                     const SizedBox(height: 20.0,),

                     Padding(
                       padding: EdgeInsets.only(left: leftRight * 0.04, right: leftRight * 0.04),
                       child: Container(
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: const BorderRadius.all(
                             Radius.circular(5.0),
                           ),
                           boxShadow: [
                             BoxShadow(
                               color: Colors.grey.withOpacity(0.5),
                               blurRadius: 1,
                               offset: const Offset(0, 3), // changes position of shadow
                             ),
                           ],
                           gradient: const LinearGradient(
                             stops: [0.02, 0.01],
                             colors: [Colors.green, Colors.white],
                           ),
                         ),
                         child: ListTile(
                           title: const Text('Doanh thu của bản thân', style: TextStyle(fontSize: 12.0,),),
                           trailing: Row(
                             mainAxisSize: MainAxisSize.min,
                             children: <Widget>[
                               const Text(
                                 'KPI: 58.2%',
                                 style: TextStyle(
                                   fontSize: 10.0,
                                 ),
                               ),
                               TextButton.icon(
                                 onPressed: (){
                                   Navigator.push(context, MaterialPageRoute(
                                       builder: (context) => const SaleManagerPayrollDetail(empName: 'của bản thân',),
                                   ));
                                 },
                                 icon: const Icon(Icons.attach_money),
                                 label: const Text('13.200.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
                               ),
                             ],
                           ),
                           subtitle: const Text('Trưởng phòng kinh doanh', style: TextStyle(fontSize: 12.0,),),
                           dense: true,
                         ),
                       ),
                     ),
                     const SizedBox(height: 20.0,),

                     Padding(
                       padding: EdgeInsets.only(left: leftRight * 0.04, right: leftRight * 0.04),
                       child: Theme(
                         data: ThemeData().copyWith(dividerColor: Colors.transparent),
                         child: ListView.builder(
                           physics: const NeverScrollableScrollPhysics(),
                           shrinkWrap: true,
                           itemCount: teams.length,
                           itemBuilder: (BuildContext ctx, index){
                             return Padding(
                               padding: const EdgeInsets.only(bottom: 10.0),
                               child: Container(
                                 decoration: BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: const BorderRadius.all(
                                     Radius.circular(5.0),
                                   ),
                                   boxShadow: [
                                     BoxShadow(
                                       color: Colors.grey.withOpacity(0.5),
                                       blurRadius: 5,
                                       offset: const Offset(0, 1), // changes position of shadow
                                     ),
                                   ],
                                   gradient: const LinearGradient(
                                     stops: [0.02, 0.01],
                                     colors: [mainBgColor, Colors.white],
                                   ),
                                 ),
                                 child: ExpansionTile(
                                   collapsedBackgroundColor: mainBgColor,
                                   trailing: TextButton.icon(onPressed: (){}, icon: const Icon(Icons.attach_money),
                                       label: const Text('32.490.000 VNĐ')),
                                   subtitle: const Text(
                                     'Tổng doanh thu của nhóm:',
                                     style: TextStyle(
                                       fontSize: 12.0,
                                       color: Colors.red,
                                     ),
                                   ),
                                   title: Text(
                                     teams[index]['name'],
                                     style: const TextStyle(
                                       color: Colors.black,
                                     ),
                                   ),
                                   children: <Widget>[
                                     const Divider(color: mainBgColor, thickness: 1.0,),
                                     ListView.builder(
                                         physics: const NeverScrollableScrollPhysics(),
                                         shrinkWrap: true,
                                         itemCount: employees.length,
                                         itemBuilder: (context, index){
                                           return ListTile(
                                             title: Text(employees[index]['name'], style: const TextStyle(fontSize: 12.0,),),
                                             trailing: Row(
                                               mainAxisSize: MainAxisSize.min,
                                               children: <Widget>[
                                                 const Text(
                                                   'KPI: 58.2%',
                                                   style: TextStyle(
                                                     fontSize: 10.0,
                                                   ),
                                                 ),
                                                 TextButton.icon(
                                                   onPressed: (){
                                                     Navigator.push(context, MaterialPageRoute(
                                                         builder: (context) => SaleManagerPayrollDetail(empName: employees[index]['name'],)
                                                     ));
                                                   },
                                                   icon: const Icon(Icons.attach_money),
                                                   label: const Text('13.200.000 VNĐ', style: TextStyle(fontSize: 12.0,),),
                                                 ),
                                               ],
                                             ),
                                             subtitle: const Text('NVKD', style: TextStyle(fontSize: 12.0,),),
                                             dense: true,
                                           );
                                         }
                                     ),
                                   ],
                                 ),
                               ),
                             );
                           },
                         ),
                       ),
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
            child: AppBar(// Add AppBar here only
              iconTheme: const IconThemeData(color: Colors.blueGrey),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                "Quản lý lương",
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

