import 'package:flutter/material.dart';
import 'package:login_sample/view_models/application_status_list_view_model.dart';
import 'package:login_sample/view_models/application_type_list_view_model.dart';
import 'package:login_sample/view_models/attendance_status_list_view_model.dart';
import 'package:login_sample/view_models/period_of_day_list_view_model.dart';
import 'package:login_sample/views/providers/login.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/utilities/utils.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getOverallInfor();
  }

  @override
  Widget build(BuildContext context) {
    return const Login();
  }

  void getOverallInfor(){
    getAllDealServicesName();
    getAllDealStageName();
    getAllDealTypeName();
    getAllDealVatName();
    getAllLeadSourcesName();
    getAllPermissionStatusName();
    getAllRoleName();
    getAllGendersName();
    getAllTeams();
    geAllDepartment();
    getAllBlocksName();
    getAllApplicationStatuses();
    getAllApplicationTypes();
    getAllPeriodOfDay();
    getAttendanceStatuses();
  }

  //Convert Future<List<Model> to List<Model> to List<String>
  void getAllBlocksName(){

    blocks.clear();
    blockNames.clear();

    ApiService().getAllBlocks().then((value) {
      blocks.addAll(value);
      for(int i = 0; i < blocks.length; i++){
        blockNames.add(blocks[i].name);
      }
    });
  }

  void getAllDealServicesName(){

    dealServices.clear();
    dealServicesNames.clear();

    ApiService().getAllService().then((value) {
        dealServices.addAll(value);

        if(dealServicesNames.isNotEmpty){
          dealServicesNames.clear();
        }
        for(int i = 0; i < dealServices.length; i++){
          dealServicesNames.add(dealServices[i].name);
        }
    });
  }

  void geAllDepartment(){
    ApiService().getAllDepartment().then((value) {
      departments.clear();
      departments.addAll(value);
    });
  }

  void getAllDealVatName(){

    dealVats.clear();
    dealVatsNames.clear();

    ApiService().getAllVat().then((value) {
        dealVats.addAll(value);

        if(dealVatsNames.isNotEmpty){
          dealVatsNames.clear();
        }
        for(int i = 0; i < dealVats.length; i++){
          dealVatsNames.add(dealVats[i].name);
        }
    });
  }

  void getAllDealStageName(){

    dealStages.clear();
    dealStagesNames.clear();

    ApiService().getAllDealStages().then((value) {
        dealStages.addAll(value);

        if(dealStagesNames.isNotEmpty){
          dealStagesNames.clear();
        }
        for(int i = 0; i < dealStages.length; i++){
          dealStagesNames.add(dealStages[i].name);
        }
    });
  }

  void getAllDealTypeName(){

    dealTypes.clear();
    dealTypesNames.clear();

    ApiService().getAllDealType().then((value) {
        dealTypes.addAll(value);

        if(dealTypesNames.isNotEmpty){
          dealTypesNames.clear();
        }
        for(int i = 0; i < dealTypes.length; i++){
          dealTypesNames.add(dealTypes[i].name);
        }
    });
  }

  void getAllPermissionStatusName(){

    permissionStatuses.clear();
    permissionStatusesNames.clear();

    ApiService().getAllPermissionStatus().then((value) {
        permissionStatuses.addAll(value);

        if(permissionStatusesNames.isNotEmpty){
          permissionStatusesNames.clear();
        }
        for(int i = 0; i < permissionStatuses.length; i++){
          permissionStatusesNames.add(permissionStatuses[i].name);
        }
    });
  }

  void getAllRoleName(){

    roles.clear();
    rolesNames.clear();

    ApiService().getAllRoles().then((value) {
        roles.addAll(value);

        if(rolesNames.isNotEmpty){
          rolesNames.clear();
        }
        for(int i = 0; i < roles.length; i++){
          rolesNames.add(roles[i].name);
        }
    });
  }

  void getAllLeadSourcesName(){

    leadSources.clear();
    leadSourceNames.clear();

    ApiService().getAllLeadSource().then((value) {
        leadSources.addAll(value);

        if(leadSourceNames.isNotEmpty){
          leadSourceNames.clear();
        }
        for(int i = 0; i < leadSources.length; i++){
          leadSourceNames.add(leadSources[i].name);
        }
    });
  }

  void getAllGendersName(){
    genders.clear();
    gendersNames.clear();

    ApiService().getAllGender().then((value) {
      genders.addAll(value);

      if(gendersNames.isNotEmpty){
        gendersNames.clear();
      }
      for(int i = 0; i < genders.length; i++){
        gendersNames.add(genders[i].name);
      }
    });
  }

  void getAllTeams(){
    ApiService().getAllTeam().then((value) {
      teams.clear();
      teams.addAll(value);
    });
  }

  void getAllApplicationStatuses() async {

    applicationStatuses.clear();
    applicationStatusesNames.clear();

    applicationStatuses = await ApplicationStatusListViewModel().getApplicationsStatus();

    for(int i = 0; i < applicationStatuses.length; i++){
      applicationStatusesNames.add(applicationStatuses[i].name);
    }
  }

  void getAllApplicationTypes() async {

    applicationTypes.clear();
    applicationTypesNames.clear();

    applicationTypes = await ApplicationTypeListViewModel().getApplicationType();

    for(int i = 0; i < applicationTypes.length; i++){
      applicationTypesNames.add(applicationTypes[i].name);
    }
  }

  void getAllPeriodOfDay() async {

    periodOfDay.clear();
    periodOfDayNames.clear();

    periodOfDay = await PeriodOfDayListViewModel().getPeriodOfDay();

    for(int i = 0; i < periodOfDay.length; i++){
      periodOfDayNames.add(periodOfDay[i].name);
    }
  }

  void getAttendanceStatuses() async {

    attendanceStatuses.clear();
    attendanceStatusNames.clear();

    attendanceStatuses = await AttendanceStatusListViewModel().getAttendanceStatus();

    for(int i = 0; i < attendanceStatuses.length; i++){
      attendanceStatusNames.add(attendanceStatuses[i].name);
    }
  }
}
