import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:login_sample/models/account.dart';
import 'package:http/http.dart' as http;

enum Status {
  notLoggedIn,
  notRegistered,
  loggedIn,
  registered,
  authenticating,
  registering,
  loggedOut
}

class AuthService with ChangeNotifier {
}
