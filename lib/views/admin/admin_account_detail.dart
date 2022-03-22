import 'package:flutter/material.dart';
import 'package:login_sample/models/account.dart';

class AdminAccountDetail extends StatefulWidget {
  const AdminAccountDetail({Key? key, required this.account}) : super(key: key);

  final Account account;

  @override
  State<AdminAccountDetail> createState() => _AdminAccountDetailState();
}

class _AdminAccountDetailState extends State<AdminAccountDetail> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
