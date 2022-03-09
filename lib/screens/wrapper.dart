import 'package:flutter/material.dart';
import 'package:login_sample/screens/providers/login.dart';
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
    super.initState();
    setState(() {
      getOverallInfor();
    });
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
    getAllExcuseLateStatusesName();
    getAllLeadSourcesName();
    getAllPermissionStatusName();
    getAllRoleName();
    getAllGendersName();
    getAllTeams();
  }

  //Convert Future<List<Model> to List<Model> to List<String>
  void getAllDealServicesName(){
    ApiService().getAllService().then((value) {
        if(dealServices.isNotEmpty){
          dealServices.clear();
        }
        dealServices.addAll(value);

        if(dealServicesNameUtilities.isNotEmpty){
          dealServicesNameUtilities.clear();
        }
        for(int i = 0; i < dealServices.length; i++){
          dealServicesNameUtilities.add(dealServices[i].name);
        }
    });
  }

  void getAllDealVatName(){
    ApiService().getAllVat().then((value) {
        if(dealVats.isNotEmpty){
          dealVats.clear();
        }
        dealVats.addAll(value);

        if(dealVatsNameUtilities.isNotEmpty){
          dealVatsNameUtilities.clear();
        }
        for(int i = 0; i < dealVats.length; i++){
          dealVatsNameUtilities.add(dealVats[i].name);
        }
    });
  }

  void getAllDealStageName(){
    ApiService().getAllDealStages().then((value) {
        if(dealStages.isNotEmpty){
          dealStages.clear();
        }
        dealStages.addAll(value);

        if(dealStagesNameUtilities.isNotEmpty){
          dealStagesNameUtilities.clear();
        }
        for(int i = 0; i < dealStages.length; i++){
          dealStagesNameUtilities.add(dealStages[i].name);
        }
    });
  }

  void getAllDealTypeName(){
    ApiService().getAllDealType().then((value) {
        if(dealTypes.isNotEmpty){
          dealTypes.clear();
        }
        dealTypes.addAll(value);

        if(dealTypesNameUtilities.isNotEmpty){
          dealTypesNameUtilities.clear();
        }
        for(int i = 0; i < dealTypes.length; i++){
          dealTypesNameUtilities.add(dealTypes[i].name);
        }
    });
  }

  void getAllPermissionStatusName(){
    ApiService().getAllPermissionStatus().then((value) {
        if(permissionStatuses.isNotEmpty){
          permissionStatuses.clear();
        }
        permissionStatuses.addAll(value);

        if(permissionStatusesNameUtilities.isNotEmpty){
          permissionStatusesNameUtilities.clear();
        }
        for(int i = 0; i < permissionStatuses.length; i++){
          permissionStatusesNameUtilities.add(permissionStatuses[i].name);
        }
    });
  }

  void getAllRoleName(){
    ApiService().getAllRoles().then((value) {
        if(roles.isNotEmpty){
          roles.clear();
        }
        roles.addAll(value);

        if(rolesNameUtilities.isNotEmpty){
          rolesNameUtilities.clear();
        }
        for(int i = 0; i < roles.length; i++){
          rolesNameUtilities.add(roles[i].name);
        }
    });
  }

  void getAllLeadSourcesName(){
    ApiService().getAllLeadSource().then((value) {
        if(leadSources.isNotEmpty){
          leadSources.clear();
        }
        leadSources.addAll(value);

        if(leadSourceNameUtilities.isNotEmpty){
          leadSourceNameUtilities.clear();
        }
        for(int i = 0; i < leadSources.length; i++){
          leadSourceNameUtilities.add(leadSources[i].name);
        }
    });
  }

  void getAllExcuseLateStatusesName(){
    ApiService().getAllExcuseLateStatus().then((value) {
        if(excuseLateStatuses.isNotEmpty){
          excuseLateStatuses.clear();
        }
        excuseLateStatuses.addAll(value);

        if(excuseLateStatusesNameUtilities.isNotEmpty){
          excuseLateStatuses.clear();
        }
        for(int i = 0; i < excuseLateStatuses.length; i++){
          excuseLateStatusesNameUtilities.add(excuseLateStatuses[i].name);
        }
    });
  }

  void getAllGendersName(){
    ApiService().getAllGender().then((value) {
      if(genders.isNotEmpty){
        genders.clear();
      }
      genders.addAll(value);

      if(gendersUtilities.isNotEmpty){
        gendersUtilities.clear();
      }
      for(int i = 0; i < genders.length; i++){
        gendersUtilities.add(genders[i].name);
      }
    });
  }

  void getAllTeams(){
    ApiService().getAllTeam().then((value) {
      if(teams.isNotEmpty){
        teams.clear();
      }
      teams.addAll(value);
    });
  }

}
