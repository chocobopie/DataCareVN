import 'package:login_sample/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPreferences{
  Future<bool> saveAccount(Account account) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("accountId", int.parse('${account.accountId}'));
    prefs.setInt("roleId", int.parse('${account.roleId}'));
    prefs.setInt("blockId", int.parse('${account.blockId}'));
    prefs.setInt("departmentId", int.parse('${account.departmentId}'));
    prefs.setInt("teamId", int.parse('${account.teamId}'));
    prefs.setInt("permissionId", int.parse('${account.permissionId}'));
    prefs.setInt("statusId", int.parse('${account.statusId}'));

    return prefs.commit();
  }

  Future<Account> getAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? accountId = prefs.getInt("accountId");
    int? roleId = prefs.getInt("roleId");
    int? blockId = prefs.getInt("blockId");
    int? departmentId = prefs.getInt("departmentId");
    int? teamId = prefs.getInt("teamId");
    int? permissionId = prefs.getInt("permissionId");
    int? statusId = prefs.getInt("statusId");

    return Account(
      accountId: accountId,
      roleId: roleId,
      blockId: blockId,
      departmentId: departmentId,
      teamId: teamId,
      permissionId: permissionId,
      statusId: statusId
    );
  }

  void removeAccount() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("accountId");
    prefs.remove("roleId");
    prefs.remove("blockId");
    prefs.remove("departmentId");
    prefs.remove("teamId");
    prefs.remove("permissionId");
    prefs.remove("statusId");
  }

  Future<int?> getAccountId(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? accountId = prefs.getInt("accountId");
    return accountId;
  }
}