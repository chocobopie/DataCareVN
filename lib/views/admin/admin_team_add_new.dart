import 'package:flutter/material.dart';
import 'package:login_sample/main.dart';
import 'package:login_sample/models/block.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/utilities/utils.dart';
import 'package:login_sample/view_models/team_view_model.dart';
import 'package:login_sample/views/admin/admin_department_filter.dart';
import 'package:login_sample/widgets/CustomEditableTextField.dart';
import 'package:login_sample/widgets/CustomTextButton.dart';

class AdminTeamAddNew extends StatefulWidget {
  const AdminTeamAddNew({Key? key}) : super(key: key);

  @override
  State<AdminTeamAddNew> createState() => _AdminTeamAddNewState();
}

class _AdminTeamAddNewState extends State<AdminTeamAddNew> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  Department? _departmentFilter;
  final TextEditingController _teamName = TextEditingController();
  bool _isSimilar = false;

  @override
  void dispose() {
    super.dispose();
    _teamName.dispose();
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: CustomEditableTextFormField(
                              borderColor: mainBgColor,
                              text: _departmentFilter == null ? '' : _departmentFilter!.name,
                              title: 'Phòng ban',
                              readonly: true,
                              onTap: () async {
                                final data = await Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => AdminDepartmentFilter(departmentList: getDepartmentListInBlock(block: Block(blockId: 1, name: ''))),
                                ));
                                if(data != null){
                                  setState(() {
                                    _departmentFilter = data;
                                  });
                                }
                              },
                          ),
                        ),
                        if(_departmentFilter != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: CustomEditableTextFormField(
                                text: _teamName.text.isEmpty ? '' : _teamName.text,
                                title: 'Tên nhóm',
                                readonly: false,
                                textEditingController: _teamName,
                            ),
                          ),

                        if(_isSimilar == true) const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Center(child: Text('Tên phòng ban đã tồn tại', style: TextStyle(color: Colors.red),)),
                        ),

                        if(_departmentFilter != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: CustomTextButton(
                                color: mainBgColor,
                                text: 'Tạo thêm nhóm',
                                onPressed: () async {

                                  setState(() {
                                    _isSimilar = false;
                                  });

                                  if(!_formKey.currentState!.validate()){
                                    return;
                                  }
                                  for(int i = 0; i < teams.length; i++){
                                    if(_teamName.text == teams[i].name){
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


                                  bool data = await _createNewTeam();
                                  if(data == true){
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Tạo thêm nhóm thành công')),
                                    );
                                    Future.delayed(const Duration(seconds: 1), (){
                                      Navigator.pop(context);
                                    });
                                  }else{
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Tạo thêm nhóm thất bại')),
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
                'Tạo thêm nhóm',
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

  Future<bool> _createNewTeam() async {

    Team team = Team(
        departmentId: _departmentFilter!.departmentId!,
        name: _teamName.text
    );

    final data = await TeamViewMode().createNewTeam(team);

    if(data != null){
      return true;
    }else{
      return false;
    }
  }
}
