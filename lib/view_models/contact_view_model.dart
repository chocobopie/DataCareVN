import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/services/api_service.dart';

class ContactViewModel with ChangeNotifier{
  Future<Contact> getContactByContactId(int contactId) async {
    Contact contact = await ApiService().getContactByContactId(contactId);

    notifyListeners();

    return contact;
  }
}