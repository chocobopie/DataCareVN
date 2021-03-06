import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/application_type.dart';
import 'package:login_sample/models/attendance_status.dart';
import 'package:login_sample/models/block.dart';
import 'package:login_sample/models/deal_stage.dart';
import 'package:login_sample/models/deal_type.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/models/application_status.dart';
import 'package:login_sample/models/gender.dart';
import 'package:login_sample/models/lead_source.dart';
import 'package:login_sample/models/period_of_day.dart';
import 'package:login_sample/models/permission_status.dart';
import 'package:login_sample/models/role.dart';
import 'package:login_sample/models/service.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/models/vat.dart';

const mainBgColor = Color(0xFFFFC000);
const defaultFontColor = Color.fromARGB(255, 107, 106, 144);

const locale = 'vi';
String formatNumber(String s) => NumberFormat.decimalPattern(locale).format(int.parse(s));
String moneyFormat(String s){
  return formatNumber(s.replaceAll('.', ''));
}
String get currency => NumberFormat.compactSimpleCurrency(locale: locale).currencySymbol;
//==================================================================Loading dialog
showLoaderDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    contentPadding: const EdgeInsets.all(20.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(margin: const EdgeInsets.only(left: 20),child:const Text("Vui lòng đợi..." )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}
//------------------------------------------------------------------List model----------------------------------------------------
List<Service> dealServices = [];
List<Vat> dealVats = [];
List<DealStage> dealStages = [];
List<DealType> dealTypes = [];
List<PermissionStatus> permissionStatuses = [];
List<Role> roles = [];
List<LeadSource> leadSources = [];
List<Gender> genders = [];
List<Team> teams = [];
List<Department> departments = [];
List<Block> blocks = [];
List<ApplicationStatus> applicationStatuses = [];
List<ApplicationType> applicationTypes = [];
List<PeriodOfDay> periodOfDay = [];
List<AttendanceStatus> attendanceStatuses = [];
//------------------------------------------------------------------List String---------------------------------------------
List<String> dealServicesNames = [];
List<String> dealVatsNames = [];
List<String> dealStagesNames = [];
List<String> dealTypesNames = [];
List<String> permissionStatusesNames = [];
List<String> rolesNames = [];
List<String> leadSourceNames = [];
List<String> excuseLateStatusesNames = [];
List<String> gendersNames = [];
List<String> blockNames = [];
List<String> applicationStatusesNames = [];
List<String> applicationTypesNames = [];
List<String> periodOfDayNames = [];
List<String> attendanceStatusNames = [];


List<String> periodOfDayNamesFilter = [
  'Buổi sáng',
  'Buổi chiều'
];

List<String> statusUtilities = [
  'Mới',
  'Kích hoạt',
  'Vô hiệu hóa'
];

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
List<String> saleEmpUpdateDeletePermTeamOnlyNames = [
  'Không cho phép',
  'Chỉ bản thân',
  'Chỉ trong nhóm',
];
List<String> saleEmpUpdateDeletePermSelfOnlyNames = [
  'Không cho phép',
  'Chỉ bản thân',
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
Role? getRole({required int roleId}){
  Role? role;
  for(int i = 0; i < roles.length; i++){
    if(roleId == roles[i].roleId){
      role = roles[i];
    }
  }
  return role;
}

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

List<Department> getDepartmentListInBlock({required Block block,}){
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