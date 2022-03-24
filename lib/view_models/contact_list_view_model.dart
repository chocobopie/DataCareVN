import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/services/api_service.dart';

class ContactListViewModel with ChangeNotifier{

  Future<List<Contact>> getAllContactByAccountId({required bool isRefresh, required int accountId, required int currentPage, int? limit, DateTime? fromDate, DateTime? toDate}) async {

    List<Contact> contactList = await ApiService().getAllContactsByAccountId(isRefresh: isRefresh,accountId: accountId, currentPage: currentPage, limit: limit, fromDate: fromDate, toDate: toDate);

    notifyListeners();

    return contactList;
  }

  Future<List<Contact>> getAllContactByOwnerId({required bool isRefresh, required int contactOwnerId, required int currentPage, DateTime? fromDate, DateTime? toDate}) async {

    List<Contact> contactList = await ApiService().getAllContactByContactOwnerId(isRefresh: isRefresh, currentPage: currentPage, contactOwnerId: contactOwnerId, fromDate: fromDate, toDate: toDate);

    notifyListeners();

    return contactList;
  }

  Future<List<Contact>> searchNameAndEmail({required Account currentAccount, required String query}) async {

    List<Contact> contactList = await ApiService().getAllContactByFullnameOrEmail(currentAccount.accountId!, query.toLowerCase());

    notifyListeners();

    return contactList;
  }

}