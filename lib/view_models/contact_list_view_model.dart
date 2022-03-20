import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/account.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/services/api_service.dart';

class ContactListViewModel with ChangeNotifier{

  Future<List<Contact>> getAllContactByAccountId({required bool isRefresh, required int accountId, required int currentPage, int? limit}) async {

    List<Contact> contactList = await ApiService().getAllContactsByAccountId(isRefresh: isRefresh,accountId: accountId, currentPage: currentPage, limit: limit);

    notifyListeners();

    return contactList;
  }

  Future<List<Contact>> getAllContactByOwnerId({required bool isRefresh, required int contactOwnerId, required int currentPage}) async {

    List<Contact> contactList = await ApiService().getAllContactByContactOwnerId(isRefresh: isRefresh, currentPage: currentPage, contactOwnerId: contactOwnerId);

    notifyListeners();

    return contactList;
  }

  Future<List<Contact>> searchNameAndEmail({required Account currentAccount, required String query}) async {

    List<Contact> contactList = await ApiService().getAllContactByFullnameOrEmail(currentAccount.accountId!, query.toLowerCase());

    notifyListeners();

    return contactList;
  }

}