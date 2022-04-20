import 'package:flutter/material.dart';
import 'package:login_sample/view_models/application_status_list_view_model.dart';
import 'package:login_sample/view_models/application_type_list_view_model.dart';
import 'package:login_sample/view_models/attendance_status_list_view_model.dart';
import 'package:login_sample/view_models/period_of_day_list_view_model.dart';
import 'package:login_sample/views/login.dart';
import 'package:login_sample/services/api_service.dart';
import 'package:login_sample/utilities/utils.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  void initState() {
    getOverallInfor();
    super.initState();
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
  void getAllBlocksName() async {

    blocks.clear();

    blocks = await ApiService().getAllBlocks();

    blockNames.clear();

    for(int i = 0; i < blocks.length; i++){
      blockNames.add(blocks[i].name);
    }
  }

  void getAllDealServicesName() async {

    dealServices.clear();

    dealServices = await ApiService().getAllService();

    dealServicesNames.clear();

    for(int i = 0; i < dealServices.length; i++){
      dealServicesNames.add(dealServices[i].name);
    }
  }

  void geAllDepartment() async {
    departments.clear();

    departments = await ApiService().getAllDepartment();
  }

  void getAllDealVatName() async {

    dealVats.clear();

    dealVats = await ApiService().getAllVat();

    dealVatsNames.clear();

    for(int i = 0; i < dealVats.length; i++){
      dealVatsNames.add(dealVats[i].name);
    }
  }

  void getAllDealStageName() async {

    dealStages.clear();

    dealStages = await ApiService().getAllDealStages();

    dealStagesNames.clear();

    for(int i = 0; i < dealStages.length; i++){
      dealStagesNames.add(dealStages[i].name);
    }
  }

  void getAllDealTypeName() async {

    dealTypes.clear();

    dealTypes = await ApiService().getAllDealType();

    dealTypesNames.clear();

    for(int i = 0; i < dealTypes.length; i++){
      dealTypesNames.add(dealTypes[i].name);
    }
  }


  void getAllPermissionStatusName() async {

    permissionStatuses.clear();

    permissionStatuses = await ApiService().getAllPermissionStatus();

    permissionStatusesNames.clear();

    for(int i = 0; i < permissionStatuses.length; i++){
      permissionStatusesNames.add(permissionStatuses[i].name);
    }
  }

  void getAllRoleName() async {

    roles.clear();

    roles = await ApiService().getAllRoles();

    rolesNames.clear();

    for(int i = 0; i < roles.length; i++){
      rolesNames.add(roles[i].name);
    }
  }

  void getAllLeadSourcesName() async {

    leadSources.clear();

    leadSources = await ApiService().getAllLeadSource();

    leadSourceNames.clear();

    for(int i = 0; i < leadSources.length; i++){
      leadSourceNames.add(leadSources[i].name);
    }
  }

  void getAllGendersName() async {
    genders.clear();

    genders = await ApiService().getAllGender();

    gendersNames.clear();

    for(int i = 0; i < genders.length; i++){
      gendersNames.add(genders[i].name);
    }
  }

  void getAllTeams()async{
    teams.clear();
    
    teams = await ApiService().getAllTeam();
  }

  void getAllApplicationStatuses() async {

    applicationStatuses.clear();

    applicationStatuses = await ApplicationStatusListViewModel().getApplicationsStatus();

    applicationStatusesNames.clear();

    for(int i = 0; i < applicationStatuses.length; i++){
      applicationStatusesNames.add(applicationStatuses[i].name);
    }
  }

  void getAllApplicationTypes() async {

    applicationTypes.clear();

    applicationTypes = await ApplicationTypeListViewModel().getApplicationType();

    applicationTypesNames.clear();

    for(int i = 0; i < applicationTypes.length; i++){
      applicationTypesNames.add(applicationTypes[i].name);
    }
  }

  void getAllPeriodOfDay() async {

    periodOfDay.clear();

    periodOfDay = await PeriodOfDayListViewModel().getPeriodOfDay();

    periodOfDayNames.clear();

    for(int i = 0; i < periodOfDay.length; i++){
      periodOfDayNames.add(periodOfDay[i].name);
    }
  }

  void getAttendanceStatuses() async {

    attendanceStatuses.clear();

    attendanceStatuses = await AttendanceStatusListViewModel().getAttendanceStatus();

    attendanceStatusNames.clear();

    for(int i = 0; i < attendanceStatuses.length; i++){
      attendanceStatusNames.add(attendanceStatuses[i].name);
    }
  }
}
