import 'package:flutter/material.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/department_view_model.dart';
import 'package:login_sample/widgets/CustomDropdownFormField2.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';

class AdminDepartmentAddNew extends StatefulWidget {
  const AdminDepartmentAddNew({Key? key}) : super(key: key);

  @override
  State<AdminDepartmentAddNew> createState() => _AdminDepartmentAddNewState();
}

class _AdminDepartmentAddNewState extends State<AdminDepartmentAddNew> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  int? _filterBlockId;
  final TextEditingController _departmentName = TextEditingController();
  bool _isSimilar = false;

  @override
  void dispose() {
    super.dispose();
    _departmentName.dispose();
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
              child: Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      children: <Widget>[
                        CustomDropdownFormField2(
                            borderColor: mainBgColor,
                            value: _filterBlockId != null ? blocks[_filterBlockId!].name : null,
                            label: 'Khối',
                            hintText: const Text(''),
                            items: blockNames,
                            onChanged: (value){
                              for(int i = 0 ;i < blocks.length; i++){
                                if(value.toString() == blocks[i].name){
                                  setState(() {
                                    _filterBlockId = blocks[i].blockId;
                                  });
                                }
                              }
                            }
                        ),
                        const SizedBox(height: 20.0,),

                        if(_filterBlockId != null)
                          if(_filterBlockId == 1)
                        CustomEditableTextFormField(
                            borderColor: mainBgColor,
                            text: _departmentName.text.isEmpty ? '' : _departmentName.text,
                            title: 'Tên phòng ban',
                            readonly: false,
                            textEditingController: _departmentName,
                        ),

                        if(_isSimilar == true) const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Center(child: Text('Tên phòng ban đã tồn tại', style: TextStyle(color: Colors.red),)),
                        ),

                        if(_filterBlockId != null)
                          if(_filterBlockId == 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: CustomTextButton(
                              color: mainBgColor,
                              text: 'Tạo thêm phòng ban',
                              onPressed: () async {

                                setState(() {
                                  _isSimilar = false;
                                });

                                if(!_formKey.currentState!.validate()){
                                  return;
                                }

                                for(int i = 0; i < departments.length; i++){
                                  if(_departmentName.text == departments[i].name){
                                    setState(() {
                                      _isSimilar = true;
                                    });
                                    return;
                                  }else{
                                    setState(() {
                                      _isSimilar = false;
                                    });
                                  }
                                }

                                showLoaderDialog(context);

                                bool data = await _createNewDepartment();
                                if(data == true){
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Tạo thêm phòng ban thành công')),
                                  );
                                  Future.delayed(const Duration(seconds: 1), (){
                                    Navigator.pop(context);
                                  });
                                }else{
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Tạo thêm phòng ban thất bại')),
                                  );

                                }
                              },
                          ),
                        ),
                      ],
                    )
                ),
              )),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              iconTheme: const IconThemeData(
                  color: Colors.blueGrey), // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: const Text(
                'Tạo thêm phòng ban',
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

  Future<bool> _createNewDepartment() async {
    Department department = Department(
      departmentId: 0,
      blockId: _filterBlockId!,
      name: _departmentName.text
    );

    final data = await DepartmentViewModel().createNewDepartment(department);

    if(data != null){
      return true;
    }else{
      return false;
    }
  }
}
