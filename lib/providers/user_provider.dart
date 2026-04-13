import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = const UserModel();
  bool _loading = true;

  UserModel get user => _user;
  bool get loading => _loading;

  Future<bool> fetchUser() async {
    _loading = true;
    notifyListeners();

    try {
      final data = await AuthService.getMe();
      if (data == null) {
        _loading = false;
        notifyListeners();
        return false;
      }
      _user = UserModel.fromJson(data);
      _loading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final token = await StorageService.getItem('auth_token');
    if (token != null) {
      await AuthService.logout(token);
    }
    await StorageService.deleteItem('auth_token');
    _user = const UserModel();
    notifyListeners();
  }
}
