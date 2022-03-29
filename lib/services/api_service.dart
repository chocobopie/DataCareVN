import 'dart:convert';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:login_sample/models/WorldTimeAPI.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/account_permission.dart';
import 'package:login_sample/models/attendance.dart';
import 'package:login_sample/models/attendance_permission.dart';
import 'package:login_sample/models/block.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/models/contact_permission.dart';
import 'package:login_sample/models/deal.dart';
import 'package:login_sample/models/deal_permission.dart';
import 'package:login_sample/models/deal_stage.dart';
import 'package:login_sample/models/deal_type.dart';
import 'package:login_sample/models/department.dart';
import 'package:login_sample/models/excuse_late.dart';
import 'package:login_sample/models/excuse_late_status.dart';
import 'package:login_sample/models/gender.dart';
import 'package:login_sample/models/issue.dart';
import 'package:login_sample/models/issue_permission.dart';
import 'package:login_sample/models/lead_source.dart';
import 'package:login_sample/models/payroll_permission.dart';
import 'package:login_sample/models/permission.dart';
import 'package:login_sample/models/permission_status.dart';
import 'package:login_sample/models/role.dart';
import 'package:login_sample/models/service.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/models/timeline.dart';
import 'package:login_sample/models/vat.dart';

class ApiService {
  String stockUrl = 'https://trungpd2022.azurewebsites.net/api/v1/';

  //Contacts
  Future<List<Contact>> getAllContactsByAccountId( {required bool isRefresh, required int accountId, required int currentPage, int? limit, DateTime? fromDate, DateTime? toDate} ) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'contacts?account-id=$accountId&from-date=${fromDate ?? ''}&to-date=${toDate ?? ''}&page=$currentPage&limit=${limit ?? 10}';


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

  Future<List<Contact>> getAllContactByContactOwnerId({required bool isRefresh, required int contactOwnerId, required int currentPage, DateTime? fromDate, DateTime? toDate}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'contacts?contact-owner=$contactOwnerId&from-date=${fromDate ?? ''}&to-date=${toDate ?? ''}&page=$currentPage&limit=10';

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

  Future<Contact> createNewContact(Contact contact) async {
    String url = 'https://trungpd2022.azurewebsites.net/api/v1/contacts';

    final response = await http.post(Uri.parse(url),
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

    if(response.statusCode == 200){
      print('Create new contact successfully');

      return Contact.fromJson(jsonDecode(response.body));
    }else{
      print('Create new contact failed');

      Contact? contact;

      return contact!;
    }
  }

  Future<http.Response> updateAContact(Contact contact){
    String url = stockUrl + 'contacts/${contact.contactId}';
    return http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'contactId': contact.contactId,
        'fullname': contact.fullname,
        'createdDate': contact.createdDate.toIso8601String(),
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
      throw('Failed to get deal by dealId | 400');
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

  Future<Deal> createNewDeal(Deal deal) async {
    String url = 'https://trungpd2022.azurewebsites.net/api/v1/deals';

    final response = await http.post(
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

    if(response.statusCode == 200){
      print('Create new deal successfully | 200');

      return Deal.fromJson(jsonDecode(response.body));
    }else{
      print('Failed to create new deal | 400');

      Deal? deal;

      return deal!;
    }
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

  Future<List<Account>> getAllAccounts({required bool isRefresh, required currentPage, required int accountId, int? blockId, int? departmentId, int? teamId, int? roleId}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'accounts?account-id=$accountId&block-id=${blockId ?? ''}&department-id=${departmentId ?? ''}&team-id=${teamId ?? ''}&role-id=${roleId ?? ''}&page=$currentPage&limit=10';

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

  // Future<Account> updateAnAccount({required Account account}) async {
  //   String url = stockUrl + 'accounts/${account.accountId}';
  //
  //   final response = await http.put(Uri.parse(url), headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   },
  //     body: jsonEncode(<String, dynamic>{
  //       "accountId": account.accountId,
  //       "email": account.email,
  //       "emailToken": account.emailToken,
  //       "password": account.password,
  //       "fullname": account.fullname,
  //       "phoneNumber": account.phoneNumber,
  //       "address": account.address,
  //       "citizenIdentityCardNumber": account.citizenIdentityCardNumber,
  //       "nationality": account.nationality,
  //       "bankName": account.bankName,
  //       "bankAccountName": account.bankAccountName,
  //       "bankAccountNumber": account.bankAccountNumber,
  //       "roleId": account.roleId,
  //       "blockId": account.blockId,
  //       "departmentId": account.departmentId,
  //       "teamId": account.teamId,
  //       "permissionId": account.permissionId,
  //       "statusId": account.statusId,
  //       "genderId": account.genderId,
  //       "dateOfBirth": account.dateOfBirth!.toIso8601String(),
  //     }),
  //   );
  //
  //
  // }

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

  Future<List<Attendance>> getSelfAttendanceListByAccountId({required bool isRefresh, required int accountId, required int currentPage,DateTime? fromDate, DateTime? toDate, int? attendanceStatusId}) async {
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
      print('Got self attendance list by accountId | 200');
      return jsonResponse.map((data) => Attendance.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get self attendance list");
    }
  }

  Future<List<Attendance>?> getOtherAttendanceListByAccountId({required bool isRefresh, int? accountId, required int currentPage, DateTime? date, int? attendanceStatusId}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'attendances/other?account-id=${accountId ?? ''}&date=${date ?? ''}&attendance-status-id=${attendanceStatusId ?? ''}&page=$currentPage&limit=10';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Got other attendance list by accountId | 200');
      return jsonResponse.map((data) => Attendance.fromJson(data)).toList();
    } else {
      print('Failed to other attendance list by accountId | 400');
      List<Attendance>? attendanceList;
      return attendanceList;
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

  //Permission
  Future<Permission> getPermByPermId({required int permId}) async {
    String url = stockUrl + 'permission/$permId';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print('Got Permission by Permission Id | 200');
      return Permission.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to get permission by permission id | 400');
    }
  }

  Future<Permission?> updatePermission({required Permission permission}) async {
    String url = stockUrl + 'permission/${permission.permissionId}';

    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'permissionId': permission.permissionId,
        'accountPermissionId': permission.accountPermissionId,
        'attendancePermissionId' : permission.attendancePermissionId,
        'contactPermissionId' : permission.contactPermissionId,
        'dealPermissionId' : permission.dealPermissionId,
        'issuePermissionId' : permission.issuePermissionId,
        'departmentId' : permission.departmentId,
        'teamId' : permission.teamId
      }),
    );

    if(response.statusCode == 200){
      print('Update Permission successfully | 200');
      return Permission.fromJson(jsonDecode(response.body));
    }else{
      print('Update Permission failed | 400');
      Permission? permission;
      return permission;
    }
  }

  //AccountPermissionId,
  Future<AccountPermission?> getAccountPermissionById({required int accountPermissionId}) async {
    String url = stockUrl + 'account-permission/$accountPermissionId';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print('Got account permission | 200');
      return AccountPermission.fromJson(jsonDecode(response.body));
    }else{
      print('Failed to get account permission | 400');
      AccountPermission? accountPermission;
      return accountPermission;
    }
  }

  Future<AccountPermission?> updateAccountPermission({required AccountPermission accountPermission}) async {
    String url = stockUrl + 'account-permission/${accountPermission.accountPermissionId}';

    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'accountPermissionId': accountPermission.accountPermissionId,
        'create': accountPermission.create,
        'view': accountPermission.view,
        'update':accountPermission.update,
        'delete':accountPermission.delete
      }),
    );

    if(response.statusCode == 200){
      print('Update AccountPermission successfully | 200');
      return AccountPermission.fromJson(jsonDecode(response.body));
    }else{
      print('Update AccountPermission failed | 400');
      AccountPermission? accountPermission;
      return accountPermission;
    }
  }

  Future<AccountPermission?> createAccountPermission({required AccountPermission accountPermission}) async {
    String url = stockUrl + 'account-permission';

    final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'view':accountPermission.view,
      }),
    );

    if(response.statusCode == 200){
      print('Create AccountPermission successfully | 200');
      return AccountPermission.fromJson(jsonDecode(response.body));
    }else{
      print('Create AccountPermission failed | 400');
      AccountPermission? accountPermission;
      print(accountPermission);
      return accountPermission;
    }
  }

  //AttendancePermissionId,
  Future<AttendancePermission?> getAttendancePermissionById({required int attendancePermissionId}) async {
    String url = stockUrl + 'attendance-permission/$attendancePermissionId';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print('Got attendance permission | 200');
      return AttendancePermission.fromJson(jsonDecode(response.body));
    }else{
      print('Failed to get attendance permission | 400');
      AttendancePermission? attendancePermission;
      return attendancePermission;
    }
  }

  Future<AttendancePermission?> updateAttendancePermission({required AttendancePermission attendancePermission}) async {
    String url = stockUrl + 'attendance-permission/${attendancePermission.attendancePermissionId}';

    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'attendancePermissionId': attendancePermission.attendancePermissionId,
        'view': attendancePermission.view,
        'update': attendancePermission.update,
      }),
    );

    if(response.statusCode == 200){
      print('Update AttendancePermission successfully | 200');
      return AttendancePermission.fromJson(jsonDecode(response.body));
    }else{
      print('Update AttendancePermission failed | 400');
      AttendancePermission? attendancePermission;
      return attendancePermission;
    }
  }

  Future<AttendancePermission?> createAttendancePermission({required AttendancePermission attendancePermission}) async {
    String url = stockUrl + 'attendance-permission';

    final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'view': attendancePermission.view,
        'update': attendancePermission.update,
      }),
    );

    if(response.statusCode == 200){
      print('Update AttendancePermission successfully | 200');
      return AttendancePermission.fromJson(jsonDecode(response.body));
    }else{
      print('Update AttendancePermission failed | 400');
      AttendancePermission? attendancePermission;
      return attendancePermission;
    }
  }


  //PayrollPermissionId,
  Future<PayrollPermission> getPayrollPermissionById({required int payrollPermissionId}) async {
    String url = stockUrl + 'payroll-permission/$payrollPermissionId';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print('Got payroll permission | 200');
      return PayrollPermission.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to get payroll permission | 400');
    }
  }
  //ContactPermissionId,
  Future<ContactPermission?> getContactPermissionById({required int contactPermissionId}) async {
    String url = stockUrl + 'contact-permission/$contactPermissionId';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print('Got contact permission | 200');
      return ContactPermission.fromJson(jsonDecode(response.body));
    }else{
      print('Failed to get contact permission | 400');
      ContactPermission? contactPermission;
      return contactPermission;
    }
  }

  Future<ContactPermission?> updateContactPermission({required ContactPermission contactPermission}) async {
    String url = stockUrl + 'contact-permission/${contactPermission.contactPermissionId}';

    final response = await http.put(Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
      body: jsonEncode(<String, dynamic>{
        'contactPermissionId': contactPermission.contactPermissionId,
        'create': contactPermission.create,
        'view':contactPermission.view,
        'update':contactPermission.update,
        'delete':contactPermission.delete
      }),
    );

    if(response.statusCode == 200){
      print('Update ContactPermission successfully | 200');
      return ContactPermission.fromJson(jsonDecode(response.body));
    }else{
      print('Update ContactPermission failed | 400');
      ContactPermission? contactPermission;
      return contactPermission;
    }
  }

  Future<ContactPermission?> createContactPermission({required ContactPermission contactPermission}) async {
    String url = stockUrl + 'contact-permission';

    final response = await http.post(Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
      body: jsonEncode(<String, dynamic>{
        'create': contactPermission.create,
        'view':contactPermission.view,
        'update':contactPermission.update,
        'delete':contactPermission.delete
      }),
    );

    if(response.statusCode == 200){
      print('Update ContactPermission successfully | 200');
      return ContactPermission.fromJson(jsonDecode(response.body));
    }else{
      print('Update ContactPermission failed | 400');
      ContactPermission? contactPermission;
      return contactPermission;
    }
  }

  //DealPermissionId,
  Future<DealPermission?> getDealPermissionById({required int dealPermissionId}) async {
    String url = stockUrl + 'deal-permission/$dealPermissionId';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print('Got deal permission | 200');
      return DealPermission.fromJson(jsonDecode(response.body));
    }else{
      print('Failed to get deal permission | 400');
      DealPermission? dealPermission;
      return dealPermission;
    }
  }

  Future<DealPermission?> updateDealPermission({required DealPermission dealPermission}) async {
    String url = stockUrl + 'deal-permission/${dealPermission.dealPermissionId}';

    final response = await http.put(Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
      body: jsonEncode(<String, dynamic>{
        'dealPermissionId': dealPermission.dealPermissionId,
        'create': dealPermission.create,
        'view':dealPermission.view,
        'update':dealPermission.update,
        'delete':dealPermission.delete
      }),
    );
    if(response.statusCode == 200){
      print('Update DealPermission successfully | 200');
      return DealPermission.fromJson(jsonDecode(response.body));
    }else{
      print('Update DealPermission failed | 400');
      DealPermission? dealPermission;
      return dealPermission;
    }
  }

  Future<DealPermission?> createDealPermission({required DealPermission dealPermission}) async {
    String url = stockUrl + 'deal-permission';

    final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'create':dealPermission.create,
        'view':dealPermission.view,
        'update':dealPermission.update,
        'delete':dealPermission.delete
      }),
    );

    if(response.statusCode == 200){
      print('Create DealPermission successfully | 200');
      return DealPermission.fromJson(jsonDecode(response.body));
    }else{
      print('Create DealPermission failed | 400');
      DealPermission? dealPermission;
      print(dealPermission);
      return dealPermission;
    }
  }

  //IssuePermissionId,
  Future<IssuePermission?> getIssuePermissionById({required int issuePermissionId}) async {
    String url = stockUrl + 'issue-permission/$issuePermissionId';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print('Got issue permission | 200');
      return IssuePermission.fromJson(jsonDecode(response.body));
    }else{
      print('Failed to get issue permission | 400');
      IssuePermission? issuePermission;
      return issuePermission;
    }
  }
  Future<IssuePermission?> updateIssuePermission({required IssuePermission issuePermission}) async {
    String url = stockUrl + 'issue-permission/${issuePermission.issuePermissionId}';

    final response = await http.put(Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
      body: jsonEncode(<String, dynamic>{
        'issuePermissionId': issuePermission.issuePermissionId,
        'create' : issuePermission.create,
        'view' : issuePermission.view,
        'update' : issuePermission.update,
        'delete' : issuePermission.delete
      }),
    );
    if(response.statusCode == 200){
      print('Update IssuePermission successfully | 200');
      return IssuePermission.fromJson(jsonDecode(response.body));
    }else{
      print('Update IssuePermission failed | 400');
      IssuePermission? issuePermission;
      return issuePermission;
    }
  }

  Future<IssuePermission?> createIssuePermission({required IssuePermission issuePermission}) async {
    String url = stockUrl + 'issue-permission';

    final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'create':issuePermission.create,
        'view':issuePermission.view,
        'update':issuePermission.update,
        'delete':issuePermission.delete
      }),
    );

    if(response.statusCode == 200){
      print('Create IssuePermission successfully | 200');
      return IssuePermission.fromJson(jsonDecode(response.body));
    }else{
      print('Create IssuePermission failed | 400');
      IssuePermission? issuePermission;
      print(issuePermission);
      return issuePermission;
    }
  }

  //issue
  Future<List<Issue>?> getAllIssue() async {
    String url = stockUrl + 'issues';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all issue | 200');
      return jsonResponse.map((data) => Issue.fromJson(data)).toList();
    } else {
      print('Failed to get all issue | 400');
      List<Issue>? issueList;
      return issueList;
    }
  }
}

