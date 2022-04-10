import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_sample/models/contact.dart';
import 'package:login_sample/services/api_service.dart';

class ContactViewModel with ChangeNotifier{
  Future<Contact> getContactByContactId(int contactId) async {
    Contact contact = await ApiService().getContactByContactId(contactId);

    notifyListeners();

    return contact;
  }

  Future<bool> createNewContact(Contact contact) async {
    bool result = await ApiService().createNewContact(contact);

    notifyListeners();

    return result;
  }

  Future<bool> updateAContact(Contact contact) async {
    bool result = await ApiService().updateAContact(contact);

    notifyListeners();

    return result;
  }

  Future<bool> deleteContact(int contactId) async {
    bool result = await ApiService().deleteContact(contactId);

    notifyListeners();

    return result;
  }
}