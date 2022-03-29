import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/block.dart';
import 'package:login_sample/models/deal_stage.dart';
import 'package:login_sample/models/deal_type.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/models/excuse_late_status.dart';
import 'package:login_sample/models/gender.dart';
import 'package:login_sample/models/lead_source.dart';
import 'package:login_sample/models/permission_status.dart';
import 'package:login_sample/models/role.dart';
import 'package:login_sample/models/service.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/models/vat.dart';

const mainBgColor = Color(0xFFFFC000);
const defaultFontColor = Color.fromARGB(255, 107, 106, 144);

const locale = 'vi';
String formatNumber(String s) => NumberFormat.decimalPattern(locale).format(int.parse(s));
String get currency => NumberFormat.compactSimpleCurrency(locale: locale).currencySymbol;

//------------------------------------------------------------------List model----------------------------------------------------
List<Service> dealServices = [];
List<Vat> dealVats = [];
List<DealStage> dealStages = [];
List<DealType> dealTypes = [];
List<PermissionStatus> permissionStatuses = [];
List<Role> roles = [];
List<LeadSource> leadSources = [];
List<ExcuseLateStatus> excuseLateStatuses = [];
List<Gender> genders = [];
List<Team> teams = [];
List<Department> departments = [];
List<Block> blocks = [];
//------------------------------------------------------------------List String---------------------------------------------
List<String> dealServicesNameUtilities = [];
List<String> dealVatsNameUtilities = [];
List<String> dealStagesNameUtilities = [];
List<String> dealTypesNameUtilities = [];
List<String> permissionStatusesNameUtilities = [];
List<String> rolesNameUtilities = [];
List<String> leadSourceNameUtilities = [];
List<String> excuseLateStatusesNameUtilities = [];
List<String> gendersUtilities = [];
List<String> blockNameUtilities = [];


List<String> sortUtilities = [
  'Tăng dần',
  'Giảm dần'
];

List<String> attendanceStatusUtilities = [
  'Đúng giờ',
  'Cho phép trễ',
  'Trễ',
  'Vắng'
];
List<String> saleEmpCreatePermNames = [
  'Không cho phép',
  'Cho phép'
];
List<String> saleEmpViewPermNames = [
  'Chỉ bản thân',
  'Chỉ trong nhóm',
  'Chỉ trong phòng ban'
];
List<String> saleEmpUpdateDeletePermNames = [
  'Không cho phép',
  'Chỉ bản thân',
  'Chỉ trong nhóm',
  'Chỉ trong phòng ban'
];
List<String> hrInternViewPermNames = [
  'Chỉ trong phòng ban',
  'Tất cả'
];
List<String> hrInternCreatePermNames = [
  'Không cho phép',
  'Cho phép'
];
List<String> hrInternUpdateDeletePermNames = [
  'Không cho phép',
  'Chỉ trong phòng ban',
  'Tất cả'
];
List<String> roleFilter = [
  'Thực tập sinh nhân sự',
  'Trưởng phòng kinh doanh',
  'Trưởng nhóm kinh doanh',
  'Nhân viên kinh doanh',
  'Nhân viên kỹ thuật'
];

//-------------------------------------------------------------------------------------------------------------------
Department getDepartment({required int departmentId, int? blockId}){
  Department? department;

  for(int i = 0; i < departments.length; i++){
    if(departmentId == departments[i].departmentId && blockId == departments[i].blockId){
      department = departments[i];
    }else if(departmentId == departments[i].departmentId){
      department = departments[i];
    }
  }

  return department!;
}

Block getBlock({required int blockId}){
  Block? block;
  for(int i = 0; i < blocks.length; i++){
    if(blockId == blocks[i].blockId){
      block = blocks[i];
    }
  }
  return block!;
}

String getDepartmentName(int departmentId, int? blockId){
  String name = '';

  if(blockId != null){
    for(int i = 0; i < departments.length; i++){
      if(departmentId == departments[i].departmentId && blockId == departments[i].blockId){
        name = departments[i].name;
      }
    }
  }else{
    for(int i = 0; i < departments.length; i++){
      if(departmentId == departments[i].departmentId){
        name = departments[i].name;
      }
    }
  }
  return name;
}

String getTeamName(int teamId, departmentId){
  String name = '';
  for(int i = 0; i < teams.length; i++){
    if(teamId == teams[i].teamId && departmentId == teams[i].departmentId){
      name = teams[i].name;
    }
  }
  return name;
}

List<Department> getDepartmentListInBlock({required Block block}){
  List<Department> departmentList = [];
  for(int i = 0; i < departments.length; i++){
    if(block.blockId == departments[i].blockId){
      departmentList.add(departments[i]);
    }
  }
  return departmentList;
}

List<Team> getTeamListInDepartment({required Department department}){
  List<Team> teamList = [];
  for(int i = 0; i < teams.length; i++){
    if(department.departmentId == teams[i].departmentId){
      teamList.add(teams[i]);
    }
  }
  return teamList;
}


// ---------------------------------Temp List For Testing------------------------------------------
List<String> rolesTemp = [
  'Nhân viên kinh doanh',
  'Trưởng nhóm kinh doanh',
  'Trưởng phòng kinh doanh',
  'Kỹ thuật viên',
  'Trưởng phòng quản lý nhân sự',
  'Thực tập sinh quản lý nhân sự',
  'Admin'
];

List<String> blocksTemp = [
  'Khối HCNS',
  'Khối kinh doanh',
  'Khối kỹ thuật',
];

List<String> departmentTemp = [
  'Phòng học viện',
  'Phòng Digital Care'
];

List<String> teamTemp = [
  'Nhóm Thảo Vy',
  'Nhóm Quang Tiến',
  'Nhóm Trung Anh'
];

List<String> statusTemp = [
  'Hoạt động',
  'Vô hiệu hoá'
];