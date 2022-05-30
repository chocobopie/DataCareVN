import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login_sample/models/basic_salary_by_grade.dart';
import 'package:login_sample/models/management_commission.dart';
import 'package:login_sample/models/payroll_company.dart';
import 'package:login_sample/models/personal_commission.dart';
import 'package:login_sample/models/application_type.dart';
import 'package:login_sample/models/attendance_rule.dart';
import 'package:login_sample/models/attendance_status.dart';
import 'package:login_sample/models/change_password.dart';
import 'package:login_sample/models/payroll.dart';
import 'package:login_sample/models/period_of_day.dart';
import 'package:login_sample/models/register_account.dart';
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
import 'package:login_sample/models/application.dart';
import 'package:login_sample/models/application_status.dart';
import 'package:login_sample/models/gender.dart';
import 'package:login_sample/models/issue.dart';
import 'package:login_sample/models/issue_permission.dart';
import 'package:login_sample/models/lead_source.dart';
import 'package:login_sample/models/payroll_permission.dart';
import 'package:login_sample/models/permission.dart';
import 'package:login_sample/models/permission_status.dart';
import 'package:login_sample/models/role.dart';
import 'package:login_sample/models/sale.dart';
import 'package:login_sample/models/service.dart';
import 'package:login_sample/models/team.dart';
import 'package:login_sample/models/timeline.dart';
import 'package:login_sample/models/vat.dart';

class ApiService {
  String stockUrl = 'https://datacarevn.azurewebsites.net/api/v1/';

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

  Future<bool> deleteContact(int contactId) async {
    String url = stockUrl + 'contacts/$contactId';

    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if(response.statusCode == 200){
      print('Delete contact successfully | 200');
      return true;
    }else{
      print('Delete contact failed | 400');
      return false;
    }
  }

  Future<bool> createNewContact(Contact contact) async {
    String url = stockUrl + 'contacts';

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
      // return Contact.fromJson(jsonDecode(response.body));
      return true;
    }else{
      print('Create new contact failed');

      // Contact? contact;

      return false;
    }
  }

  Future<bool> updateAContact(Contact contact) async {

    String url = stockUrl + 'contacts/${contact.contactId}';
    final response = await http.put(Uri.parse(url),
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

    if(response.statusCode == 200){
      print('Update a contact successfully | 200');
      return true;
    }else{
      print('Update a contact failed | 400');
      return false;
    }
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
    String url = stockUrl + 'deals';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all deals | 200');
      return jsonResponse.map((data) => Deal.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all deals");
    }
  }

  Future<List<Deal>?> getDealListBySaleId({required int saleId, required bool isRefresh, required int currentPage,int? limit}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'deals?sale-id=$saleId&page=$currentPage&limit=${limit ?? 10}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all deals by SaleId| 200');
      return jsonResponse.map((data) => Deal.fromJson(data)).toList();
    } else {
      print("Failed to get all deals by SaleId");
      List<Deal>? result;
      return result;
    }
  }

  Future<Deal> getADealByAccountIdDealId({required int accountId, required int dealId}) async {
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

  Future<Deal?> getADealByDealId({required int dealId}) async {
    String url = stockUrl + 'deals/$dealId';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Got deal by dealId | 200');
      return Deal.fromJson(jsonResponse);
    } else {
      print('Failed to get deal by dealId | 400');
      Deal? deal;
      return deal;
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

  Future<bool> createNewDeal(Deal deal) async {
    String url = stockUrl + 'deals';

    final response = await http.post(Uri.parse(url),
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
      // return Deal.fromJson(jsonDecode(response.body));
      return true;
    }else{
      print('Failed to create new deal | 400');
      return false;
    }
  }

  Future<bool> deleteDeal(int dealId) async {
    String url = stockUrl + 'deals/$dealId';

    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if(response.statusCode == 200){
      print('Delete deal successfully | 200');
      return true;
    }else{
      return false;
    }
  }

  Future<int> getDealCount() async {
    String url = stockUrl + 'deals/count';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to get all deals");
    }
  }

  Future<bool> updateADeal(Deal deal, int accountId) async {
    String url = stockUrl + 'deals/${deal.dealId}';

    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "accountId": accountId,
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

    if(response.statusCode == 200){
      print('Update deal successfully | 200');
      return true;
    }else{
      print('Update deal failed | 400');
      return false;
    }
  }

  //DealStages
  Future<List<DealStage>> getAllDealStages() async {
    String url = stockUrl + 'deal-stages';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all deal stages | 200');
      return jsonResponse.map((data) => DealStage.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all deals");
    }
  }

  //password
  Future<bool> changePassword(ChangePassword changePassword) async {
    String url = stockUrl + 'authentications/change-password?id=${changePassword.accountId}';

    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "accountId": changePassword.accountId,
        "email": changePassword.email,
        "currentPassword": changePassword.currentPassword,
        "newPassword": changePassword.newPassword
      }),
    );

    if(response.statusCode == 200){
      print('Change password successfully | 200');
      return true;
    }else{
      print('Change password failed | 400');
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    String url = stockUrl + 'authentications/reset-password?email=$email';

    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      print('Reset password successfully | 200');
      return true;
    }else{
      print('Reset password failed | 400');
      return false;
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

  Future<bool> deleteAnAccount({required int accountId}) async {
    String url = stockUrl + 'accounts/$accountId';

    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if(response.statusCode == 200){
      print('Delete account successfully | 200');
      return true;
    }else{
      print('Delete account failed | 200');
      return false;
    }
  }

  Future<RegisterAccount?> registerAnAccount(RegisterAccount registerAccount) async {
    String url = stockUrl + 'accounts';

    final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "email": registerAccount.email,
        "roleId": registerAccount.roleId,
        "blockId": registerAccount.blockId,
        "departmentId": registerAccount.departmentId,
        "teamId": registerAccount.teamId,
        "manageDepartmentId": registerAccount.manageDepartmentId,
        "manageTeamId": registerAccount.manageTeamId,
        "viewAccountPermissionId": registerAccount.viewAccountPermissionId,
        "viewAttendancePermissionId": registerAccount.viewAttendancePermissionId,
        "updateAttendancePermissionId": registerAccount.updateAttendancePermissionId,
        "createContactPermissionId": registerAccount.createContactPermissionId,
        "viewContactPermissionId": registerAccount.viewContactPermissionId,
        "updateContactPermissionId": registerAccount.updateContactPermissionId,
        "deleteContactPermissionId": registerAccount.deleteContactPermissionId,
        "createDealPermissionId": registerAccount.createDealPermissionId,
        "viewDealPermissionId": registerAccount.viewDealPermissionId,
        "updateDealPermissionId": registerAccount.updateDealPermissionId,
        "deleteDealPermissionId": registerAccount.deleteDealPermissionId,
        "createIssuePermissionId": registerAccount.createIssuePermissionId,
        "viewIssuePermissionId": registerAccount.viewIssuePermissionId,
        "updateIssuePermissionId": registerAccount.updateIssuePermissionId,
        "deleteIssuePermissionId": registerAccount.deleteIssuePermissionId,
        "basicSalary": registerAccount.basicSalary,
        "kpi": registerAccount.kpi
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Register an account successfully | 200');
      return RegisterAccount.fromJson(jsonResponse);
    } else {
      print("Failed to Register an account | 400");
      RegisterAccount? registerAccount;
      return registerAccount;
    }
  }

  Future<Account?> updateAnAccount(Account account) async{
    String url = stockUrl + 'accounts/${account.accountId}';

    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "accountId": account.accountId,
        "email": account.email,
        "fullname": account.fullname,
        "phoneNumber": account.phoneNumber,
        "address": account.address,
        "citizenIdentityCardNumber": account.citizenIdentityCardNumber,
        "nationality": account.nationality,
        "bankName": account.bankName,
        "bankAccountName": account.bankAccountName,
        "bankAccountNumber": account.bankAccountNumber,
        "roleId": account.roleId,
        "blockId": account.blockId,
        "departmentId": account.departmentId,
        "teamId": account.teamId,
        "permissionId": account.permissionId,
        "statusId": account.statusId,
        "genderId": account.genderId,
        "dateOfBirth": account.dateOfBirth!.toIso8601String()
      }),
    );

    if(response.statusCode == 200){
      final jsonResponse = json.decode(response.body);
      print('Update account profile successfully | 200');
      return Account.fromJson(jsonResponse);
    }else{
      print('Update account profile failed | 400');
      Account? account;
      return account;
    }
  }

  Future<List<Account>> getAllAccounts({required bool isRefresh, required currentPage, required int accountId, int? blockId, int? departmentId, int? teamId, int? roleId, int? limit, String? search}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'accounts?account-id=$accountId&fullname=${search ?? ''}&block-id=${blockId ?? ''}&department-id=${departmentId ?? ''}&team-id=${teamId ?? ''}&role-id=${roleId ?? ''}&page=$currentPage&limit=${limit ?? 10}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all accounts | 200');
      return jsonResponse.map((data) => Account.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all accounts");
    }
  }

  Future<List<Account>?> getAllSalesForContact({required bool isRefresh, required int currentPage, required int accountId, String? fullname, int? blockId, int? departmentId, int? teamId, int? limit}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'accounts/sales-for-contact?account-id=$accountId&fullname=${fullname ?? ''}&block-id=${blockId ?? ''}&department-id=${departmentId ?? ''}&team-id=${teamId ?? ''}&page=$currentPage&limit=${limit ?? 10}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all sales for contact | 200');
      return jsonResponse.map((data) => Account.fromJson(data)).toList();
    } else {
      print("Failed to get all sales for contact | 400");
      List<Account>? accountList;
      return accountList;
    }
  }

  Future<List<Account>?> getAllSalesForIssue({required bool isRefresh, required int currentPage, required int accountId, String? fullname, int? blockId, int? departmentId, int? teamId, int? limit}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'accounts/sales-for-issue?account-id=$accountId&fullname=${fullname ?? ''}&block-id=${blockId ?? ''}&department-id=${departmentId ?? ''}&team-id=${teamId ?? ''}&page=$currentPage&limit=${limit ?? 10}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all sales for deal | 200');
      return jsonResponse.map((data) => Account.fromJson(data)).toList();
    } else {
      print("Failed to get all sales for deals | 400");
      List<Account>? accountList;
      return accountList;
    }
  }

  Future<List<Account>?> getAllSalesForDeal({required bool isRefresh, required int currentPage, required int accountId, String? fullname, int? blockId, int? departmentId, int? teamId, int? limit}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'accounts/sales-for-deal?account-id=$accountId&fullname=${fullname ?? ''}&block-id=${blockId ?? ''}&department-id=${departmentId ?? ''}&team-id=${teamId ?? ''}&page=$currentPage&limit=${limit ?? 10}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all sales for deal | 200');
      return jsonResponse.map((data) => Account.fromJson(data)).toList();
    } else {
      print("Failed to get all sales for deals | 400");
      List<Account>? accountList;
      return accountList;
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

  Future<List<Account>?> getAllSalesTaggedByAnother({required bool isRefresh, required int currentPage, required int accountId, String? fullname, int? blockId, int? departmentId, int? teamId, int? limit}) async{
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'accounts/sales-for-issue-tagged-by-another?account-id=$accountId&fullname=${fullname ?? ''}&block-id=${blockId ?? ''}&department-id=${departmentId ?? ''}&team-id=${teamId ?? ''}&page=$currentPage&limit=${limit ?? 10}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all sales tagged by another | 200');
      return jsonResponse.map((data) => Account.fromJson(data)).toList();
    } else {
      print("Failed to get all sales tagged by another | 400");
      List<Account>? accountList;
      return accountList;
    }
  }

  Future<List<Account>?> getAccountByFullname({required bool isRefresh, required int currentPage, required int accountId, required String fullname}) async{
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'accounts/sales-for-contact?account-id=$accountId&fullname=$fullname&page=$currentPage&limit=10';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all accounts by fullname| 200');
      return jsonResponse.map((data) => Account.fromJson(data)).toList();
    } else {
      print("Failed to get all accounts by fullname");
      List<Account>? accountList;
      return accountList;
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
    String url = stockUrl + 'departments';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all departments | 200');
      return jsonResponse.map((data) => Department.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all deals");
    }
  }

  Future<Department?> createNewDepartment(Department department) async {

    String url = stockUrl + 'departments';

    final response = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, dynamic>{
        "blockId": department.blockId,
        "name" : department.name
      }),
    );

    if(response.statusCode == 200){
      final jsonResponse = json.decode(response.body);
      print('Create new department successfully | 200');
      return Department.fromJson(jsonResponse);
    }else{
      print('Create new department failed | 400');
      Department? department;
      return department;
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

  Future<Team?> createNewTeam(Team team) async {

    String url = stockUrl + 'teams';

    final response = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, dynamic>{
        "departmentId": team.departmentId,
        "name": team.name
      }),
    );

    if(response.statusCode == 200){
      final jsonResponse = json.decode(response.body);
      print('Create new team successfully | 200');
      return Team.fromJson(jsonResponse);
    }else{
      print('Create new team failed | 400');
      Team? team;
      return team;
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
  Future<Attendance?> takeAttendance({required Account account}) async {

    String url = stockUrl + 'attendances/take-attendance?account-id=${account.accountId}';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print('Take attendance for ${account.fullname} successfully');
      return Attendance.fromJson(jsonDecode(response.body));
    }else{
      print('Failed to take attendance for ${account.fullname}');
      Attendance? attendance;
      return attendance;
    }
  }


  Future<int?> getCountAttendance({required int accountId, required DateTime fromDate, required DateTime toDate, int? attendanceStatusId}) async {

    String url = stockUrl + 'attendances/count?account-id=$accountId&from-date=$fromDate&to-date=$toDate&attendance-status-id=${attendanceStatusId ?? ''}';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print('Take attendance count for StatusId $attendanceStatusId successfully');
      return int.tryParse(response.body);
    }else{
      print('Failed to get attendance count for StatusId: $attendanceStatusId');
      return 0;
    }
  }

  Future<int?> getExceedApprovedLateCount({required int accountId, required DateTime fromDate}) async {

    String url = stockUrl + 'attendances/count-exceed-approved-lates?account-id=$accountId&date=$fromDate';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print('Get exceed approved late count successfully');
      return int.tryParse(response.body);
    }else{
      print('Failed to get exceed approved late count');
      return 0;
    }
  }

  Future<int?> getExceedApprovedAbsencesCount({required int accountId, required DateTime fromDate}) async {

    String url = stockUrl + 'attendances/count-exceed-approved-absences?account-id=$accountId&date=$fromDate';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print('Get exceed approved absences count successfully');
      return int.tryParse(response.body);
    }else{
      print('Failed to get exceed approved absences count');
      return 0;
    }
  }

  Future<int?> getCountAvailableApprovedAbsence({required int accountId, required DateTime fromDate}) async {

    String url = stockUrl + 'attendances/count-available-approved-absences?account-id=$accountId&date=$fromDate';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print('Take available approved absence successfully');
      return int.tryParse(response.body);
    }else{
      print('Failed to get available approved absence');
      return 0;
    }
  }

  Future<bool> updateAnAttendance({required Attendance attendance}) async {
    String url = stockUrl + 'attendances/${attendance.attendanceId}';

    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "attendanceId": attendance.attendanceId,
        "accountId": attendance.accountId,
        "date": attendance.date.toIso8601String(),
        "attendanceStatusId": attendance.attendanceStatusId,
        "periodOfDayId": attendance.periodOfDayId
      }),
    );

    if(response.statusCode == 200){
      print('Update an attendance successfully | 200');
      return true;
    }else{
      print('Update an attendance failed | 400');
      return false;
    }
  }

  //AttendanceStatus
  Future<List<AttendanceStatus>> getAttendanceStatus() async {
    String url = stockUrl + 'attendance-statuses';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Got all attendance statuses | 200');
      return jsonResponse.map((data) => AttendanceStatus.fromJson(data)).toList();
    } else {
      throw Exception("Failed to get all attendance statuses | 400");
    }
  }

  Future<List<Attendance>?> getOtherAttendanceList({required int accountId, required bool isRefresh, DateTime? selectedDate, required currentPage, int? attendanceStatusId , int? periodOfDay, int? limit}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'attendances/other?account-id=$accountId&date=${selectedDate ?? ''}&attendance-status-id=${attendanceStatusId ?? ''}&period-of-day-id=${periodOfDay ?? ''}&page=$currentPage&limit=${limit ?? 10}';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Got all other attendance list | 200');
      return jsonResponse.map((data) => Attendance.fromJson(data)).toList();
    }else{
      print('Failed to get other attendance list | 400');
      List<Attendance>? otherAttendanceList;
      return otherAttendanceList;
    }
  }

  Future<List<Attendance>?> getSelfAttendanceList({required bool isRefresh, required int accountId, required int currentPage, DateTime? fromDate, DateTime? toDate, int? attendanceStatusId, int? periodOfDayId, int? limit}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'attendances/self?account-id=$accountId&from-date=${fromDate ?? ''}&to-date=${toDate ?? ''}&attendance-status-id=${attendanceStatusId ?? ''}&period-of-day-id=${periodOfDayId ?? ''}&page=$currentPage&limit=${limit ?? 10}';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Got self attendance list by accountId | 200');
      return jsonResponse.map((data) => Attendance.fromJson(data)).toList();
    } else {
      print("Failed to get self attendance list");
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
  Future<List<Issue>?> getAllIssue({required bool isRefresh, required currentPage ,int? issueId, int? dealId, int? ownerId, int? taggedAccountId, DateTime? fromCreateDate, DateTime? toCreateDate, DateTime? fromDeadlineDate, DateTime? toDeadlineDate, int? limit}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'issues?deal-id=${dealId ?? ''}&owner-id=${ownerId ?? ''}&tagged-account-id=${taggedAccountId ?? ''}&from-created-date=${fromCreateDate ?? ''}&to-created-date=${toCreateDate ?? ''}&from-deadline-date=${fromDeadlineDate ?? ''}&to-deadline-date=${toDeadlineDate ?? ''}&page=$currentPage&limit=${limit ?? 10}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Got all issues | 200');
      return jsonResponse.map((data) => Issue.fromJson(data)).toList();
    } else {
      print('Failed to get all issues | 400');
      List<Issue>? issueList;
      return issueList;
    }
  }

  Future<Issue?> createNewIssue(Issue issue) async {
    String url = stockUrl + 'issues';

    final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "ownerId": issue.ownerId,
        "dealId": issue.dealId,
        "title": issue.title,
        "taggedAccountId": issue.taggedAccountId,
        "description": issue.description,
        "deadlineDate": issue.deadlineDate.toIso8601String()
      }),
    );

    if(response.statusCode == 200){
      print('Create new issue successfully | 200');
      return Issue.fromJson(jsonDecode(response.body));
    }else{
      print('Create new issue failed | 400');

      Issue? issue;

      return issue;
    }
  }

  Future<Issue?> updateAIssue(Issue issue) async {
    String url = stockUrl + 'issues/${issue.issueId}';

    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "issueId": issue.issueId,
        "ownerId": issue.ownerId,
        "dealId": issue.dealId,
        "title": issue.title,
        "taggedAccountId": issue.taggedAccountId,
        "description": issue.description,
        "createdDate": issue.createdDate?.toIso8601String(),
        "deadlineDate": issue.deadlineDate.toIso8601String()
      }),
    );

    if(response.statusCode == 200){
      print('Update a issue successfully | 200');
      return Issue.fromJson(jsonDecode(response.body));
    }else{
      print('Update a issue failed | 400');

      Issue? issue;

      return issue;
    }
  }

  Future<bool> deleteIssue(int issueId) async {
    String url = stockUrl + 'issues/$issueId';

    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if(response.statusCode == 200){
      print('Delete issue successfully | 200');
      return true;
    }else{
      print('Delete issue failed | 200');
      return false;
    }
  }
  //Application
  Future<bool> sendApplication(Application application) async {
    String url = stockUrl + 'application';

    final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "accountId": application.accountId,
        "assignedDate": application.assignedDate.toIso8601String(),
        "description": application.description,
        "expectedWorkingTime": application.expectedWorkingTime?.toIso8601String(),
        "applicationTypeId": application.applicationTypeId,
        "periodOfDayId": application.periodOfDayId,
      }),
    );

    if(response.statusCode == 200){
      print('Send application successfully | 200');
      // return Contact.fromJson(jsonDecode(response.body));
      return true;
    }else{
      print('Send application failed | 400');

      // Contact? contact;

      return false;
    }
  }

  Future<bool> updateAnApplication({required Application application}) async {
    String url = stockUrl + 'application/${application.applicationId}';

    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "applicationId": application.applicationId,
        "accountId": application.accountId,
        "createdDate": application.createdDate?.toIso8601String(),
        "assignedDate": application.createdDate?.toIso8601String(),
        "description": application.description,
        "expectedWorkingTime": application.expectedWorkingTime?.toIso8601String(),
        "applicationStatusId": application.applicationStatusId,
        "applicationTypeId": application.applicationTypeId,
        "periodOfDayId": application.periodOfDayId
      }),
    );

    if(response.statusCode == 200){
      print('Update an application successfully | 200');
      return true;
    }else{
      print('Update an application failed | 400');
      return false;
    }
  }

  Future<List<Application>?> getSelfApplicationList({required bool isRefresh, required int currentPage, required int accountId, DateTime? fromCreatedDate, DateTime? toCreatedDate, DateTime? fromAssignedDate, DateTime? toAssignedDate, int? applicationStatusId, int? periodOfDayId, int? limit}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'application/self?account-id=$accountId&from-created-date=${fromCreatedDate ?? ''}&to-created-date=${toCreatedDate ?? ''}&from-assigned-date=${fromAssignedDate ?? ''}&to-assigned-date=${toAssignedDate ?? ''}&application-status-id=${applicationStatusId ?? ''}&period-of-day-id=${periodOfDayId ?? ''}&page=$currentPage&limit=${limit ?? 10}';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Got self application list successfully | 200');
      return jsonResponse.map((data) => Application.fromJson(data)).toList();
    }else{
      print('Get self application list failed | 400');
      List<Application>? applicationList;
      return applicationList;
    }
  }

  Future<List<Application>?> getOtherApplicationList({required bool isRefresh, required int currentPage, required int accountId, DateTime? fromCreatedDate, DateTime? toCreatedDate, DateTime? fromAssignedDate, DateTime? toAssignedDate, int? applicationStatusId, int? periodOfDayId, int? limit}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'application/other?account-id=$accountId&from-created-date=${fromCreatedDate ?? ''}&to-created-date=${toCreatedDate ?? ''}&from-assigned-date=${fromAssignedDate ?? ''}&to-assigned-date=${toAssignedDate ?? ''}&application-status-id=${applicationStatusId ?? ''}&period-of-day-id=${periodOfDayId ?? ''}&page=$currentPage&limit=${limit ?? 10}';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Got other application list successfully | 200');
      return jsonResponse.map((data) => Application.fromJson(data)).toList();
    }else{
      print('Get other application list failed | 400');
      List<Application>? applicationList;
      return applicationList;
    }
  }




  //ApplicationType
  Future<List<ApplicationType>> getApplicationType() async {
    String url = stockUrl + 'application-types';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Get application types successfully | 200');
      return jsonResponse.map((data) => ApplicationType.fromJson(data)).toList();
    }else{
      throw Exception("Failed to get application types | 400");
    }
  }

  //ApplicationStatus
  Future<List<ApplicationStatus>> getApplicationsStatus() async {
    String url = stockUrl + 'application-statuses';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Get application statuses successfully | 200');
      return jsonResponse.map((data) => ApplicationStatus.fromJson(data)).toList();
    }else{
      throw Exception("Failed to get application statuses | 400");
    }
  }

  //PeriodOfDay
  Future<List<PeriodOfDay>> getPeriodOfDay() async {
    String url = stockUrl + 'period-of-day';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Get period of day successfully | 200');
      return jsonResponse.map((data) => PeriodOfDay.fromJson(data)).toList();
    }else{
      throw Exception("Failed to get period of day | 400");
    }
  }

  //CompanyPayroll
  Future<List<PayrollCompany>?> getListPayrollCompany({required bool isRefresh, required int currentPage, int? payrollCompanyId, int? isClosing, DateTime? fromDate, DateTime? toDate, int? limit}) async {
    if(isRefresh == true){
      currentPage = 0;
    }
    String url = stockUrl + 'payroll-companies?payroll-company-id=${payrollCompanyId ?? ''}&is-closing=${isClosing ?? ''}&from-date=${fromDate ?? ''}&to-date=${toDate ?? ''}&page=$currentPage&limit=${limit ?? 1}';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Get list of payroll company successfully | 200');
      return jsonResponse.map((data) => PayrollCompany.fromJson(data)).toList();
    }else{
      print("Failed to get list of payroll company | 400");
      List<PayrollCompany>? result;
      return result;
    }
  }

  //Payroll
  Future<List<Payroll>?> getListPayroll({required bool isRefresh, required int currentPage, int? payrollCompanyId, int? accountId, int? limit}) async {
    if(isRefresh == true){
      currentPage = 0;
    }
    String url = stockUrl + 'payrolls?payroll-company-id=${payrollCompanyId ?? ''}&account-id=${accountId ?? ''}&page=$currentPage&limit=${limit ?? 1}';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Get list of payroll successfully| 200');
      return jsonResponse.map((data) => Payroll.fromJson(data)).toList();
    }else{
      print("Failed to get list of payroll | 400");
      List<Payroll>? result;
      return result;
    }
  }
  Future<bool> updatePayroll(Payroll payroll) async {

    String url = stockUrl + 'payrolls/${payroll.payrollId}';
    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "payrollId": payroll.payrollId,
        "basicSalary": payroll.basicSalary,
        "allowance": payroll.allowance,
        "parkingFee": payroll.parkingFee,
        "fine": payroll.fine,
        "personalInsurance": payroll.personalInsurance,
        "companyInsurance": payroll.companyInsurance,
        "newSignPersonalSalesBonus": payroll.newSignPersonalSalesBonus,
        "renewedPersonalSalesBonus": payroll.renewedPersonalSalesBonus,
        "managementSalesBonus": payroll.managementSalesBonus,
        "clB20SalesBonus": payroll.clB20SalesBonus,
        "contentManagerFanpageTechnicalEmployeeBonus": payroll.contentManagerFanpageTechnicalEmployeeBonus,
        "collaboratorFanpageTechnicalEmployeeBonus": payroll.collaboratorFanpageTechnicalEmployeeBonus,
        "renewedFanpageTechnicalEmployeeBonus": payroll.renewedFanpageTechnicalEmployeeBonus,
        "contentManagerWebsiteAdsTechnicalEmployeeBonus": payroll.contentManagerWebsiteAdsTechnicalEmployeeBonus,
        "collaboratorWebsiteTechnicalEmployeeBonus": payroll.collaboratorWebsiteTechnicalEmployeeBonus,
        "renewedWebsiteTechnicalEmployeeBonus": payroll.renewedWebsiteTechnicalEmployeeBonus,
        "collaboratorAdsTechnicalEmployeeBonus": payroll.collaboratorAdsTechnicalEmployeeBonus,
        "lecturerEducationTechnicalEmployeeBonus": payroll.lecturerEducationTechnicalEmployeeBonus,
        "tutorEducationTechnicalEmployeeBonus": payroll.tutorEducationTechnicalEmployeeBonus,
        "techcareEducationTechnicalEmployeeBonus": payroll.techcareEducationTechnicalEmployeeBonus,
        "emulationBonus": payroll.emulationBonus,
        "recruitmentBonus": payroll.recruitmentBonus,
        "personalBonus": payroll.personalBonus,
        "teamBonus": payroll.teamBonus,
        "tax": payroll.tax,
      }
      ),
    );

    if(response.statusCode == 200){
      print('Update payroll successfully | 200');
      return true;
    }else{
      print('Update payroll failed | 400');
      return false;
    }
  }

  //sales
  Future<List<Sale>?> getListSales({required bool isRefresh, required int currentPage,required int payrollCompanyId, int? payrollId, int? saleId, int? limit}) async {
    if(isRefresh == true){
      currentPage = 0;
    }

    String url = stockUrl + 'sales?payroll-company-id=$payrollCompanyId&payroll-id=${payrollId ?? ''}&page=$currentPage&limit=${limit ?? 1000000}';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Get list of sales successfully| 200');
      return jsonResponse.map((data) => Sale.fromJson(data)).toList();
    }else{
      print("Failed to get list of sales | 400");
      List<Sale>? result;
      return result;
    }
  }

  Future<bool> updateKPI(Sale sale) async {

    String url = stockUrl + 'sales/${sale.saleId}';
    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "saleId": sale.saleId,
        "kpi": sale.kpi
      }),
    );

    if(response.statusCode == 200){
      print('Update KPI successfully | 200');
      return true;
    }else{
      print('Update KPI failed | 400');
      return false;
    }
  }

  //AttendanceRule
  Future<AttendanceRule?> getAttendanceRule() async {
    String url = stockUrl + 'attendance-rules';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Got attendance rule | 200');
      return AttendanceRule.fromJson(jsonResponse);
    } else {
      print('Failed to get attendance rule | 400');
      AttendanceRule? result;
      return result;
    }
  }

  Future<bool> updateAttendanceRule(AttendanceRule attendanceRule) async {

    String url = stockUrl + 'attendance-rules/${attendanceRule.attendanceRuleId}';
    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "attendanceRuleId": attendanceRule.attendanceRuleId,
        "maximumApprovedLateShiftPerMonth": attendanceRule.maximumApprovedLateShiftPerMonth,
        "maximumApprovedAbsenceShiftPerMonth": attendanceRule.maximumApprovedAbsenceShiftPerMonth,
        "maximumApprovedAbsenceShiftPerYear": attendanceRule.maximumApprovedAbsenceShiftPerYear,
        "fineForEachLateShift": attendanceRule.fineForEachLateShift
      }),
    );

    if(response.statusCode == 200){
      print('Update a contact successfully | 200');
      return true;
    }else{
      print('Update a contact failed | 400');
      return false;
    }
  }

  //Commission
  Future<List<PersonalCommission>?> getListPersonalCommission() async {
    String url = stockUrl + 'personal-commissions';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Get list of personal commission successfully | 200');
      return jsonResponse.map((data) => PersonalCommission.fromJson(data)).toList();
    }else{
      print("Failed to get list of personal commission | 400");
      List<PersonalCommission>? result;
      return result;
    }
  }

  Future<List<ManagementCommission>?> getListManagementCommission() async {
    String url = stockUrl + 'management-commissions';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Get list of management commission successfully | 200');
      return jsonResponse.map((data) => ManagementCommission.fromJson(data)).toList();
    }else{
      print("Failed to get list of management commission | 400");
      List<ManagementCommission>? result;
      return result;
    }
  }

  Future<bool> updatePersonalCommission(PersonalCommission personalCommission) async {

    String url = stockUrl + 'personal-commissions/${personalCommission.personalCommissionId}';
    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "personalCommissionId": personalCommission.personalCommissionId,
        "percentageOfKPI": personalCommission.percentageOfKpi,
        "newSignCommissionForSalesManager": personalCommission.newSignCommissionForSalesManager,
        "renewedSignCommissionForSalesManager": personalCommission.renewedSignCommissionForSalesManager,
        "newSignCommissionForSalesLeader": personalCommission.newSignCommissionForSalesLeader,
        "renewedSignCommissionForSalesLeader": personalCommission.renewedSignCommissionForSalesLeader,
        "newSignCommissionForSalesEmloyee": personalCommission.newSignCommissionForSalesEmloyee,
        "renewedSignCommissionForSalesEmployee": personalCommission.renewedSignCommissionForSalesEmployee
      }),
    );

    if(response.statusCode == 200){
      print('Update Personal Commission successfully | 200');
      return true;
    }else{
      print('Update Personal Commission failed | 400');
      return false;
    }
  }

  Future<bool> updateManagementCommission(ManagementCommission managementCommission) async {

    String url = stockUrl + 'management-commissions/${managementCommission.managementCommissionId}';
    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "managementCommissionId": managementCommission.managementCommissionId,
        "percentageOfKPI": managementCommission.percentageOfKpi,
        "commission": managementCommission.commission
      }),
    );

    if(response.statusCode == 200){
      print('Update Management Commission successfully | 200');
      return true;
    }else{
      print('Update Management Commission failed | 400');
      return false;
    }
  }

  Future<bool> createNewPersonalCommission(PersonalCommission personalCommission) async {
    String url = stockUrl + 'personal-commissions';

    final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "percentageOfKPI": personalCommission.percentageOfKpi,
        "newSignCommissionForSalesManager": personalCommission.newSignCommissionForSalesManager,
        "renewedSignCommissionForSalesManager": personalCommission.renewedSignCommissionForSalesManager,
        "newSignCommissionForSalesLeader": personalCommission.newSignCommissionForSalesLeader,
        "renewedSignCommissionForSalesLeader": personalCommission.renewedSignCommissionForSalesLeader,
        "newSignCommissionForSalesEmloyee": personalCommission.newSignCommissionForSalesEmloyee,
        "renewedSignCommissionForSalesEmployee": personalCommission.renewedSignCommissionForSalesEmployee
      }),
    );

    if(response.statusCode == 200){
      print('Create new personal permission successfully');
      return true;
    }else{
      print('Create new personal permission failed');
      return false;
    }
  }

  Future<bool> deleteAPersonalPermission(int personalPermissionId) async {
    String url = stockUrl + 'personal-commissions/$personalPermissionId';

    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if(response.statusCode == 200){
      print('Delete personal permission successfully | 200');
      return true;
    }else{
      print('Delete personal permission failed | 400');
      return false;
    }
  }

  Future<List<BasicSalaryByGrade>?> getListBasicSalaryByGrade() async {
    String url = stockUrl + 'basic-salary-by-grades';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      print('Get list of basic salary by grade successfully | 200');
      return jsonResponse.map((data) => BasicSalaryByGrade.fromJson(data)).toList();
    }else{
      print("Failed to get list basic salary by grade | 400");
      List<BasicSalaryByGrade>? result;
      return result;
    }
  }

  Future<bool> createNewBasicSalaryGrade(BasicSalaryByGrade basicSalaryByGrade) async {
    String url = stockUrl + 'basic-salary-by-grades';

    final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "basicSalary": basicSalaryByGrade.basicSalary,
        "kpi": basicSalaryByGrade.kpi,
        "allowance": basicSalaryByGrade.allowance
      }),
    );

    if(response.statusCode == 200){
      print('Create new basic salary successfully | 200');
      return true;
    }else{
      print('Create new basic salary failed | 400');
      return false;
    }
  }

  Future<bool> deleteABasicSalaryGrade(int basicSalaryId) async {
    String url = stockUrl + 'basic-salary-by-grades/$basicSalaryId';

    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if(response.statusCode == 200){
      print('Delete personal basic salary successfully successfully | 200');
      return true;
    }else{
      print('Delete personal basic salary failed | 400');
      return false;
    }
  }

  Future<bool> updateBasicSalaryByGrade(BasicSalaryByGrade basicSalaryByGrade) async {

    String url = stockUrl + 'basic-salary-by-grades/${basicSalaryByGrade.basicSalaryByGradeId}';
    final response = await http.put(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "basicSalaryByGradeId": basicSalaryByGrade.basicSalaryByGradeId,
        "basicSalary": basicSalaryByGrade.basicSalary,
        "kpi": basicSalaryByGrade.kpi,
        "allowance": basicSalaryByGrade.allowance
      }),
    );

    if(response.statusCode == 200){
      print('Update Basic Salary By Grade successfully | 200');
      return true;
    }else{
      print('Update Basic Salary By Grade failed | 400');
      return false;
    }
  }
}

