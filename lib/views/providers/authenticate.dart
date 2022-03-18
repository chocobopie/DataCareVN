import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:login_sample/models/account.dart';

enum Status {
  notLoggedIn,
  notRegistered,
  loggedIn,
  registered,
  authenticating,
  registering,
  loggedOut,
  loggedInFailed
}

class AuthProvider with ChangeNotifier{
  String stockUrl = 'https://trungpd2022.azurewebsites.net/api/v1/';

  late Status _loggedInStatus = Status.notLoggedIn;

  Status get loggedInStatus => _loggedInStatus;

  Future<Account> login(String email, String password) async{
    String url = stockUrl + 'authentications';

    _loggedInStatus = Status.authenticating;
    notifyListeners();

    final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password
      }),
    );

    if(response.statusCode == 200){
      print('Login successful');
      print(jsonDecode(response.body));

      _loggedInStatus = Status.loggedIn;
      notifyListeners();

      return Account.fromJson(jsonDecode(response.body));
    }else{
      _loggedInStatus = Status.loggedInFailed;
      notifyListeners();
      throw Exception('Login failed');
    }
  }
}
