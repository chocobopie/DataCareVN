import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login_sample/models/WorldTimeAPI.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/models/block.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/models/deal_stage.dart';
import 'package:login_sample/models/deal_type.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/models/excuse_late.dart';
import 'package:login_sample/models/excuse_late_status.dart';
import 'package:login_sample/models/gender.dart';
import 'package:login_sample/models/lead_source.dart';
import 'package:login_sample/models/permission_status.dart';
import 'package:login_sample/models/role.dart';
import 'package:login_sample/models/service.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/models/timeline.dart';
import 'package:login_sample/models/vat.dart';

class ApiService {
  String stockUrl = 'https://trungpd2022.azurewebsites.net/api/v1/';

  //Contacts
  Future<List<Contact>> getAllContactsByAccountId( {required bool isRefresh, required int accountId, required int currentPage, int? limit} ) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'contacts?account-id=$accountId&page=$currentPage&limit=10';

    if(limit != null){
      url = stockUrl + 'contacts?account-id=$accountId&page=$currentPage&limit=$limit';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all contacts by account id| 200');
      return jsonResponse.map((data) => Contact.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all contacts by account Id");
    }
  }

  Future<List<Contact>> getAllContactByFullnameOrEmail(int accountId, String fullnameOrEmail) async {
    String url = stockUrl + 'contacts?account-id=$accountId&fullname=$fullnameOrEmail&limit=999';

    if(fullnameOrEmail.contains('@')){
      url = stockUrl + 'contacts?account-id=$accountId&email=$fullnameOrEmail&limit=999';
    }else{
      url;
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all contacts by Fullname or Email | 200');
      return jsonResponse.map((data) => Contact.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all contacts");
    }
  }

  Future<List<Contact>> getAllContactByContactOwnerId({required bool isRefresh, required int contactOwnerId, required int currentPage}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'contacts?contact-owner=$contactOwnerId&page=$currentPage&limit=10';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all contacts by contact owner id | 200');
      return jsonResponse.map((data) => Contact.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all contacts");
    }
  }

  Future<List<Contact>> getAllContacts() async {
    String url = stockUrl + 'contacts';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all contacts | 200');
      return jsonResponse.map((data) => Contact.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all contacts");
    }
  }

  Future<http.Response> deleteContact(int? contactId) async {
    String url = stockUrl + 'contacts/$contactId';

    final http.Response response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  Future<http.Response> createNewContact(Contact contact) {
    String url = 'https://trungpd2022.azurewebsites.net/api/v1/contacts';
    return http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'fullname': contact.fullname,
        'email': contact.email,
        'phoneNumber': contact.phoneNumber,
        'contactOwnerId': contact.contactOwnerId,
        'companyName': contact.companyName,
        'leadSourceId': contact.leadSourceId,
        'genderId': contact.genderId
      }),
    );
  }

  Future<http.Response> updateAContact(Contact contact){
    String url = stockUrl + 'contacts/${contact.contactId}';
    return http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'contactId': contact.contactId,
        'fullname': contact.fullname,
        'email': contact.email,
        'phoneNumber': contact.phoneNumber,
        'contactOwnerId': contact.contactOwnerId,
        'companyName': contact.companyName,
        'leadSourceId': contact.leadSourceId,
        'genderId': contact.genderId
      }),

    );
  }

  Future<Contact> getContactByContactId(int contactId) async {
    String url = stockUrl + 'contacts/$contactId';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Got contact by contact id | 200');
      return Contact.fromJson(jsonResponse);
    } else {
      throw Exception("Failed to get contact by contact id | 500 | 404");
    }

  }


  //Deals
  Future<List<Deal>> getAllDeals() async {
    String url = 'https://trungpd2022.azurewebsites.net/api/v1/deals';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all deals | 200');
      return jsonResponse.map((data) => Deal.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all deals");
    }
  }

  Future<Deal> getADealByDealId({required int accountId, required int dealId}) async {
    String url = stockUrl + 'deals?account-id=$accountId&deal-id=$dealId';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Got deal by dealId | 200');
      return Deal.fromJson(jsonResponse[0]);
    } else {
      throw Exception("Failed to get deal by dealId");
    }
  }

  Future<List<Deal>> getAllDealByAccountId({required bool isRefresh, required int accountId, required int currentPage, int? contactId, DateTime? fromDate, DateTime? toDate}) async {
    if(isRefresh == true){
      currentPage = 0;
    }
    String url = stockUrl + 'deals?account-id=$accountId&page=$currentPage&limit=10';

    if(fromDate != null && toDate != null && contactId == null){
      url = stockUrl + 'deals?account-id=$accountId&from-date=$fromDate&to-date=$toDate&page=$currentPage&limit=10';
    }else if(fromDate != null && toDate != null && contactId != null){
      url = stockUrl + 'deals?account-id=$accountId&contact-id=$contactId&from-date=$fromDate&to-date=$toDate&page=$currentPage&limit=10';
    }else if(fromDate == null && toDate == null && contactId != null){
      url = stockUrl + 'deals?account-id=$accountId&contact-id=$contactId&page=$currentPage&limit=10';
    }


    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Got all deals by account id | 200');
      return jsonResponse.map((data) => Deal.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all deals by account id | 500 | 404");
    }
  }

  Future<List<Deal>> getAllDealByDealOwnerId({required bool isRefresh, required int dealOwnerId, required int currentPage, int? contactId, DateTime? fromDate, DateTime? toDate}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'deals?deal-owner=$dealOwnerId&page=$currentPage&limit=10';

    if(fromDate != null && toDate != null && contactId != null){
      url = stockUrl + 'deals?deal-owner=$dealOwnerId&contact-id=$contactId&from-date=$fromDate&to-date=$toDate&page=$currentPage&limit=10';
    }else if(fromDate != null && toDate != null && contactId == null){
      url = stockUrl + 'deals?deal-owner=$dealOwnerId&from-date=$fromDate&to-date=$toDate&page=$currentPage&limit=10';
    }else if(fromDate == null && toDate == null && contactId != null){
      url = stockUrl + 'deals?deal-owner=$dealOwnerId&contact-id=$contactId&page=0&limit=10';
    }

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Got all deals by deal owner id | 200');
      return jsonResponse.map((data) => Deal.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all deals by deal owner id | 500 | 404");
    }
  }

  Future<http.Response> createNewDeal(Deal deal) {
    String url = 'https://trungpd2022.azurewebsites.net/api/v1/deals';
    return http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': deal.title,
        'dealStageId': deal.dealStageId,
        'amount': deal.amount,
        'closedDate' :deal.closedDate.toIso8601String(),
        'dealOwnerId': deal.dealOwnerId,
        'linkTrello': deal.linkTrello,
        'vatId': deal.vatId,
        'serviceId': deal.serviceId,
        'dealTypeId': deal.dealTypeId,
        'contactId': deal.contactId
      }),
    );
  }

  Future<http.Response> deleteDeal(int dealId) async {
    String url = 'https://trungpd2022.azurewebsites.net/api/v1/deals/$dealId';

    final http.Response response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  Future<int> getDealCount() async {
    String url = 'https://trungpd2022.azurewebsites.net/api/v1/deals/count';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to get all deals");
    }
  }

  Future<http.Response> updateADeal(Deal deal){
    String url = stockUrl + 'deals/${deal.dealId}';
    return http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'dealId': deal.dealId,
        'title': deal.title,
        'dealStageId': deal.dealStageId,
        'amount': deal.amount,
        'closedDate': deal.closedDate.toIso8601String(),
        'dealOwnerId': deal.dealOwnerId,
        'linkTrello': deal.linkTrello,
        'vatId': deal.vatId,
        'serviceId': deal.serviceId,
        'dealTypeId': deal.dealTypeId,
        'contactId': deal.contactId
      }),
    );
  }

  //DealStages
  Future<List<DealStage>> getAllDealStages() async {
    String url = 'https://trungpd2022.azurewebsites.net/api/v1/deal-stages';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all deal stages | 200');
      return jsonResponse.map((data) => DealStage.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all deals");
    }
  }

  //Accounts
  Future<Account> getAccountById(int accountId) async{
    String url = stockUrl + 'accounts/$accountId';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Got account by accountId | 200');
      return Account.fromJson(jsonResponse);
    } else {
      throw Exception("Failed to account by accountId");
    }
  }

  Future<List<Account>> getAllAccounts({required bool isRefresh, required currentPage, required int accountId}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'accounts?account-id=$accountId&page=$currentPage&limit=10';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all accounts | 200');
      return jsonResponse.map((data) => Account.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all accounts");
    }
  }

  Future<List<Account>> getAllAccountByBlockIdDepartmentIdOrTeamId({required bool isRefresh, required int currentPage, required int blockId, required int departmentId, int? teamId, int? limit}) async {
    if(isRefresh == true){
      currentPage = 0;
    }
    String url = stockUrl + 'accounts/sales-ignore-technical-employee?block-id=$blockId&department-id=$departmentId&page=$currentPage&limit=10';

    if(teamId != null && limit == null){
      url = stockUrl + 'accounts/sales-ignore-technical-employee?block-id=$blockId&department-id=$departmentId&team-id=$teamId&page=$currentPage&limit=10';
    }else if(teamId != null && limit != null){
      url = stockUrl + 'accounts/sales-ignore-technical-employee?block-id=$blockId&department-id=$departmentId&team-id=$teamId&page=$currentPage&limit=$limit';
    }else if(teamId == null && limit != null){
      url = stockUrl + 'accounts/sales-ignore-technical-employee?block-id=$blockId&department-id=$departmentId&page=$currentPage&limit=$limit';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all accounts by BlockId, DepartmentId or TeamId | 200');
      return jsonResponse.map((data) => Account.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all accounts by BlockId, DepartmentId or TeamId");
    }
  }

  Future<List<Account>> getAllSalesEmployeeAccount() async {
    String url = stockUrl + 'accounts/sales-ignore-technical-employee';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all sales employee accounts ignore technical staff| 200');
      return jsonResponse.map((data) => Account.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all sales employee accounts");
    }
  }

  Future<List<Account>> getAccountByFullname({required bool isRefresh, required int currentPage, required int blockId, required int departmentId, required String fullname}) async{
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'accounts/sales?fullname=$fullname&block-id=$blockId&department-id=$departmentId&page=$currentPage&limit=10';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all accounts by fullname| 200');
      return jsonResponse.map((data) => Account.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all accounts by fullname");
    }
  }

  //Department
  Future<List<Department>> getAllDepartment() async {
    String url = 'https://trungpd2022.azurewebsites.net/api/v1/departments';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all departments | 200');
      return jsonResponse.map((data) => Department.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all deals");
    }
  }

  //Team
  Future<List<Team>> getAllTeam() async {
    String url = stockUrl + 'teams';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all teams | 200');
      return jsonResponse.map((data) => Team.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all deals");
    }
  }

  //Service
  Future<List<Service>> getAllService() async{
    String url = stockUrl + 'services';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all servicse | 200');
      return jsonResponse.map((data) => Service.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all services");
    }
  }

  //Vat
  Future<List<Vat>> getAllVat() async{
    String url = stockUrl + 'vats';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all vats | 200');
      return jsonResponse.map((data) => Vat.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all vats");
    }
  }

  //DealStage
  Future<List<DealStage>> getAllDealStage() async{
    String url = stockUrl + 'deal-stages';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all deal stages | 200');
      return jsonResponse.map((data) => DealStage.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get deal stages");
    }
  }

  //DealType
  Future<List<DealType>> getAllDealType() async{
    String url = stockUrl + 'deal-types';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all deal types | 200');
      return jsonResponse.map((data) => DealType.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get deal types");
    }
  }

  //ExcuseLate
  Future<http.Response> createNewExcuseLate(ExcuseLate excuseLate) {

      String url = stockUrl + 'excuse-lates';

      return http.post(Uri.parse(url), headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'attendanceId': excuseLate.attendanceId,
          'dateRequest': excuseLate.dateRequest,
          'description': excuseLate.description,
          'expectedWorkingTime': excuseLate.expectedWorkingTime,
          'excuseLateStatusId': 0
        }),
      );
  }


  //ExcuseLateStatus
  Future<List<ExcuseLateStatus>> getAllExcuseLateStatus() async{
    String url = stockUrl + 'excuse-late-statuses';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all excuse late statuses | 200');
      return jsonResponse.map((data) => ExcuseLateStatus.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get excuse late statuses");
    }
  }

  //Gender
  Future<List<Gender>> getAllGender() async{
    String url = stockUrl + 'genders';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all genders | 200');
      return jsonResponse.map((data) => Gender.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get genders");
    }
  }

  //LeadSource
  Future<List<LeadSource>> getAllLeadSource() async{
    String url = stockUrl + 'lead-sources';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all lead sources | 200');
      return jsonResponse.map((data) => LeadSource.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get excuse lead sources");
    }
  }

  //PermissionStatus
  Future<List<PermissionStatus>> getAllPermissionStatus() async{
    String url = stockUrl + 'permission-statuses';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all permission statuses | 200');
      return jsonResponse.map((data) => PermissionStatus.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get excuse permission statuses");
    }
  }

  //Role
  Future<List<Role>> getAllRoles() async{
    String url = stockUrl + 'roles';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all roles | 200');
      return jsonResponse.map((data) => Role.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get roles");
    }
  }

  //Timelines
  Future<List<Timeline>> getTimelineByDealId({ required bool isRefresh ,required dealId, required currentPage}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'timelines?deal-id=$dealId&page=$currentPage&limit=10';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Got all timelines by Deal Id | 200');
      return jsonResponse.map((data) => Timeline.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get timelines");
    }
  }

  //Attendance
  Future<Attendance> takeAttendance({required Attendance attendance}) async {

    String url = stockUrl + 'attendances';

    final response = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, dynamic>{
        "accountId": attendance.accountId,
        "date": attendance.date.toIso8601String(),
        "attendanceStatusId": attendance.attendanceStatusId,
      }),
    );

    if(response.statusCode == 200){
      print('Take attendance for ${attendance.date} successfully');
      return Attendance.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to create album');
    }
  }

  Future<List<Attendance>> getAttendanceListByAccountIdAndStatusId({required int accountId, required int statusId, required bool isRefresh, required DateTime selectedDate, required currentPage}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'attendances/other?account-id=$accountId&date=$selectedDate&attendance-status-id=$statusId&page=$currentPage&limit=10';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Got all attendace list by account id and status id | 200');
      return jsonResponse.map((data) => Attendance.fromJson(data)).toList();
    }else{
      throw Exception('Failed to get attendance list by account id and status id | 400');
    }
  }

  Future<List<Attendance>> getAttendanceListByAccountId({required bool isRefresh, required int accountId, required int currentPage,DateTime? fromDate, DateTime? toDate, int? attendanceStatusId}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'attendances/self?account-id=$accountId&page=$currentPage&limit=10';
    if(fromDate != null && toDate != null){
      url = stockUrl + 'attendances/self?account-id=$accountId&from-date=$fromDate&to-date=$toDate&page=$currentPage&limit=10';
    }

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Got attendance list by accountId | 200');
      return jsonResponse.map((data) => Attendance.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get attendance list");
    }
  }

  //WorldTimeAPI
  Future<WorldTimeApi> getCorrectTime() async {
    String url = 'http://worldtimeapi.org/api/timezone/Asia/Ho_Chi_Minh';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print('Get correct current time successfully | 200');
      return WorldTimeApi.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to get correct current time | 400');
    }
  }

  //Block
  Future<List<Block>> getAllBlocks() async {
    String url = stockUrl + 'blocks';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Get all blocks successfully | 200');
      return jsonResponse.map((data) => Block.fromJson(data)).toList();
    }else{
      throw Exception('Failed to get blocks | 400');
    }
  }
}

