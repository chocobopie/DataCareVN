import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:login_sample/models/deal_stage.dart';
import 'package:login_sample/models/deal_type.dart';
import 'package:login_sample/models/excuse_late_status.dart';
import 'package:login_sample/models/gender.dart';
import 'package:login_sample/models/lead_source.dart';
import 'package:login_sample/models/permission_status.dart';
import 'package:login_sample/models/role.dart';
import 'package:login_sample/models/service.dart';
import 'package:login_sample/models/vat.dart';

const mainBgColor = Color(0xFFFFC000);
const defaultFontColor = Color.fromARGB(255, 107, 106, 144);

const locale = 'vi';
String formatNumber(String s) => NumberFormat.decimalPattern(locale).format(int.parse(s));
String get currency => NumberFormat.compactSimpleCurrency(locale: locale).currencySymbol;

//List model
List<Service> dealServices = [];
List<Vat> dealVats = [];
List<DealStage> dealStages = [];
List<DealType> dealTypes = [];
List<PermissionStatus> permissionStatuses = [];
List<Role> roles = [];
List<LeadSource> leadSources = [];
List<ExcuseLateStatus> excuseLateStatuses = [];
List<Gender> genders = [];
//List String
List<String> dealServicesNameUtilities = [];
List<String> dealVatsNameUtilities = [];
List<String> dealStagesNameUtilities = [];
List<String> dealTypesNameUtilities = [];
List<String> permissionStatusesNameUtilities = [];
List<String> rolesNameUtilities = [];
List<String> leadSourceNameUtilities = [];
List<String> excuseLateStatusesNameUtilities = [];
List<String> gendersUtilities = [];

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