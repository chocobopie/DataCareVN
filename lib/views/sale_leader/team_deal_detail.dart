import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/temp/deal_temp.dart';
import 'package:login_sample/utilities/utils.dart';

class TeamDealDetail extends StatefulWidget {
  const TeamDealDetail({Key? key, required this.deal}) : super(key: key);

  final Deal deal;

  @override
  _TeamDealDetailState createState() => _TeamDealDetailState();
}

class _TeamDealDetailState extends State<TeamDealDetail> {

  late String dealId = '';
  late String name = '';
  late String dealName = '';
  late String dealStage = '';
  late String amount = '';
  late String dealOwner = '';
  late String department = '';
  late String team = '';
  late bool vat;
  late String service = '';
  late String dealType = '';
  late String priority = '';
  late DateTime dealDate;
  late DateTime closeDate = widget.deal.closeDate;
  late String item = '';
  late String quantity = '';
  late String company = '';

  String _closeDate = '';
  String? selectedValue;

  List<String> services = [
    'Đào tạo',
    'Website Content',
    'Facebook Content',
    'Chạy Ads',
    'Thiết kế Website',
    'TMDT',
    'Setup Ads'
  ];

  List<String> vats = [
    'Có',
    'Không'
  ];

  List<String> dealStages = [
    'Gửi báo giá',
    'Đang suy nghĩ',
    'Gặp trao đổi',
    'Đồng ý mua',
    'Gửi hợp đồng',
    'Xuống tiền',
    'Thất bại'
  ];

  List<String> priorities = [
    'Thấp',
    'Vừa',
    'Cao'
  ];

  List<String> dealTypes = [
    'Ký mới',
    'Tái ký'
  ];

  @override
  Widget build(BuildContext context) {
    vat = widget.deal.vat;
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
                    Row(
                      children: [
                        SizedBox(
                          child: TextField(
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.only(left: 20.0),
                              labelText: 'ID hợp đồng',
                              hintText: widget.deal.dealId,
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
                            readOnly: true,
                          ),
                          width: 120.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: SizedBox(
                            child: TextField(
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.only(left: 20.0),
                                labelText: 'Tên khách hàng',
                                hintText: widget.deal.name,
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
                              readOnly: true,
                            ),
                            width: 210.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0,),

                    //Tên hợp đồng
                    SizedBox(
                      child: TextField(
                        onChanged: (val) {
                          dealName = val;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Tên hợp đồng',
                          hintText: widget.deal.dealName,
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

                    //Tiến trình hợp đồng
                    Padding(
                      padding: EdgeInsets.only(left: leftRight, right: leftRight),
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                          labelText: 'Tiến trình hợp đồng',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 107, 106, 144),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        isExpanded: true,
                        hint: dealStages.contains(widget.deal.dealStage) ? Text(
                          widget.deal.dealStage,
                          style: const TextStyle(fontSize: 14),
                        ) : const Text(
                          'Hãy cập nhật tiến trình của hợp đồng',
                          style: TextStyle(fontSize: 14),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                        buttonHeight: 50,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        items: dealStages
                            .map((item) =>
                            DropdownMenuItem<String>(
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
                            return widget.deal.dealStage;
                          }
                        },
                        onChanged: (value){
                          dealStage = value.toString();
                          print(dealStage);
                        },
                        onSaved: (value){
                          selectedValue = value.toString();
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0,),

                    //Loại hợp đồng
                    Padding(
                      padding: EdgeInsets.only(left: leftRight, right: leftRight),
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                          labelText: 'Loại hợp đồng',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 107, 106, 144),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        isExpanded: true,
                        hint: dealTypes.contains(widget.deal.dealType) ? Text(
                          widget.deal.dealType,
                          style: const TextStyle(fontSize: 14),
                        ) : const Text(
                          'Hãy cập nhật loại hợp đồng',
                          style: TextStyle(fontSize: 14),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                        buttonHeight: 50,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        items: dealTypes
                            .map((item) =>
                            DropdownMenuItem<String>(
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
                            return widget.deal.dealType;
                          }
                        },
                        onChanged: (value){
                          dealType = value.toString();
                          print(dealType);
                        },
                        onSaved: (value){
                          selectedValue = value.toString();
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0,),

                    //Tổng giá trị
                    SizedBox(
                      child: TextField(
                        onChanged: (val) {
                          amount = val;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Tổng giá trị (VNĐ)',
                          hintText: widget.deal.amount,
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

                    //Vat
                    Padding(
                      padding: EdgeInsets.only(left: leftRight, right: leftRight),
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                          labelText: 'VAT',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 107, 106, 144),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        isExpanded: true,
                        hint: widget.deal.vat == true ? const Text(
                          'Có',
                          style: TextStyle(fontSize: 14),
                        ) : const Text(
                          'Không',
                          style: TextStyle(fontSize: 14),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                        buttonHeight: 50,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        items: vats
                            .map((item) =>
                            DropdownMenuItem<String>(
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
                            return 'Hãy cập nhật VAT';
                          }
                        },
                        onChanged: (value){
                          if(value.toString().contains('Có')){
                            vat = true;
                          }else{
                            vat = false;
                          }
                          print(vat.toString());
                        },
                        onSaved: (value){
                          selectedValue = value.toString();
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0,),


                    //Ngày tạo
                    SizedBox(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Ngày tạo',
                          hintText: 'Ngày ${DateFormat('dd-MM-yyyy').format(widget.deal.dealDate)}',
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

                    //Ngày đóng
                    SizedBox(
                      child: TextField(
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final date = await DatePicker.showDatePicker(
                            context,
                            locale : LocaleType.vi,
                            minTime: DateTime.now(),
                            currentTime: DateTime.now(),
                            maxTime: DateTime.now().add(const Duration(days: 36500)),
                          );
                          if(date != null){
                            closeDate = date;
                            _closeDate = 'Ngày ${DateFormat('dd-MM-yyyy').format(closeDate)}';
                            print(date);
                          }
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Ngày đóng',
                          hintText: _closeDate.isNotEmpty ? _closeDate : 'Ngày ${DateFormat('dd-MM-yyyy').format(widget.deal.closeDate)}',
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

                    //Deal owner
                    SizedBox(
                      child: TextField(
                        onChanged: (val) {
                          dealOwner = val;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Chủ hợp đồng',
                          hintText: widget.deal.dealOwner,
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

                    //Phòng ban
                    SizedBox(
                      child: TextField(
                        onChanged: (val) {
                          department = val;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Phòng ban',
                          hintText: widget.deal.department,
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

                    //Nhóm
                    SizedBox(
                      child: TextField(
                        onChanged: (val) {
                          team = val;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Nhóm',
                          hintText: widget.deal.team,
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

                    //Loại dịch vụ
                    Padding(
                      padding: EdgeInsets.only(left: leftRight, right: leftRight),
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                          labelText: 'Loại dịch vụ',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 107, 106, 144),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        isExpanded: true,
                        hint: services.contains(widget.deal.service) ? Text(
                          widget.deal.service,
                          style: const TextStyle(fontSize: 14),
                        ) : const Text(
                          'Hãy cập nhật loại dịch vụ của hợp đồng',
                          style: TextStyle(fontSize: 14),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                        buttonHeight: 50,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        items: services
                            .map((item) =>
                            DropdownMenuItem<String>(
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
                            return 'Hãy cập nhật mức độ ưu tiên';
                          }
                        },
                        onChanged: (value){
                          service = value.toString();
                          print(service);
                        },
                        onSaved: (value){
                          selectedValue = value.toString();
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0,),

                    //Tên công ty
                    SizedBox(
                      child: TextField(
                        onChanged: (val) {
                          company = val;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.only(left: 20.0),
                          labelText: 'Tên công ty khách hàng',
                          hintText: '',
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

                    //Mức độ ưu tiên
                    Padding(
                      padding: EdgeInsets.only(left: leftRight, right: leftRight),
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                          labelText: 'Mức độ ưu tiên',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 107, 106, 144),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        isExpanded: true,
                        hint: widget.deal.priority == 'Thấp' ? const Text(
                          'Thấp',
                          style: TextStyle(fontSize: 14),
                        ) : widget.deal.priority == 'Vừa' ? const Text(
                          'Vừa',
                          style: TextStyle(fontSize: 14),
                        ) : const Text(
                          'Cao',
                          style: TextStyle(fontSize: 14),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                        buttonHeight: 50,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        items: priorities
                            .map((item) =>
                            DropdownMenuItem<String>(
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
                            return 'Hãy cập nhật mức độ ưu tiên';
                          }
                        },
                        onChanged: (value){
                          priority = value.toString();
                          print(priority);
                        },
                        onSaved: (value){
                          selectedValue = value.toString();
                        },
                      ),
                    ),


                    //Button
                    const SizedBox(height: 20.0,),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.red,
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
                              onPressed: () {
                                Deal contact = Deal(
                                    dealId: 'delete',
                                    name: widget.deal.name,
                                    dealName: dealName.isEmpty ? widget.deal.dealName : dealName,
                                    dealStage: dealStage.isEmpty ? widget.deal.dealStage : dealStage,
                                    amount: amount.isEmpty ? widget.deal.amount : amount,
                                    vat: vat == true ? widget.deal.vat : vat,
                                    service: service.isEmpty ? widget.deal.service : service,
                                    dealOwner: dealOwner.isEmpty ? widget.deal.dealOwner : dealOwner,
                                    department: department.isEmpty ? widget.deal.department : department,
                                    team: team.isEmpty ? widget.deal.team : team,
                                    dealType: dealType.isEmpty ? widget.deal.dealType : dealType,
                                    priority: priority.isEmpty ? widget.deal.priority : priority,
                                    dealDate: widget.deal.dealDate,
                                    closeDate: widget.deal.closeDate,
                                );
                                Navigator.pop(context, contact);
                              },
                              child: const Text(
                                'Xoá Hợp Đồng',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0,),
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
                                Deal contact = Deal(
                                  dealId: widget.deal.dealId,
                                  name: widget.deal.name,
                                  dealName: dealName.isEmpty ? widget.deal.dealName : dealName,
                                  dealStage: dealStage.isEmpty ? widget.deal.dealStage : dealStage,
                                  amount: amount.isEmpty ? widget.deal.amount : amount,
                                  vat: vat,
                                  service: service.isEmpty ? widget.deal.service : service,
                                  dealOwner: dealOwner.isEmpty ? widget.deal.dealOwner : dealOwner,
                                  department: department.isEmpty ? widget.deal.department : department,
                                  team: team.isEmpty ? widget.deal.team : team,
                                  dealType: dealType.isEmpty ? widget.deal.dealType : dealType,
                                  priority: priority.isEmpty ? widget.deal.priority : priority,
                                  dealDate: widget.deal.dealDate,
                                  closeDate: closeDate.toString().isNotEmpty ? closeDate : widget.deal.closeDate,
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
                widget.deal.dealName.toString(),
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
