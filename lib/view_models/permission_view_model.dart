import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:login_sample/models/permission.dart';
import 'package:login_sample/services/api_service.dart';

class PermissionViewModel with ChangeNotifier{
  Future<Permission> getPermByPermId({required int permId}) async {
    Permission permission = await ApiService().getPermByPermId(permId: permId);

    notifyListeners();

    return permission;
  }
}