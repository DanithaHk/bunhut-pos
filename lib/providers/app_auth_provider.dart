import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/service/auth_service.dart';
import '../model/user.dart';

class AppAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUserModel;
  bool _isLoadingRole = false;

  UserModel? get currentUserModel => _currentUserModel;
  bool get isLoadingRole => _isLoadingRole;

  bool get isAdmin =>
      _currentUserModel?.role.toLowerCase() == "admin";

  AppAuthProvider() {
    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    print("[Provider] Initializing Auth Listener");

    _authService.auth.authStateChanges().listen(
          (User? user) async {
        print("[Provider] Auth State Changed");

        if (user != null) {
          print("[Provider] User Logged In");
          print("[Provider] UID: ${user.uid}");
          print("[Provider] Email: ${user.email}");

          await fetchUserRole(user.uid);
        } else {
          print("[Provider] User Logged Out");

          _currentUserModel = null;
          notifyListeners();
        }
      },
    );
  }

  Future<void> fetchUserRole(String uid) async {
    print("[Provider] fetchUserRole Started");

    _isLoadingRole = true;
    notifyListeners();

    try {
      _currentUserModel =
      await _authService.getUserProfile(uid);

      if (_currentUserModel != null) {
        print("[Provider] User Loaded");
        print(
            "[Provider] Role: ${_currentUserModel!.role}");
      } else {
        print("[Provider] No User Profile Found");
      }
    } catch (e) {
      print("[Provider] ERROR: $e");
      _currentUserModel = null;
    } finally {
      _isLoadingRole = false;

      print("[Provider] fetchUserRole Finished");

      notifyListeners();
    }
  }

  Future<void> registerNewUser({
    required String email,
    required String password,
    required String role,
  }) async {
    print("[Provider] Registering User");

    await _authService.registerUser(
      email: email,
      password: password,
      role: role,
    );

    print("[Provider] User Registration Completed");
  }

  Future<void> changeCurrentPassword(
      String newPassword) async {
    print("[Provider] Changing Password");

    await _authService.changePassword(newPassword);
  }

  Future<void> logout() async {
    print("[Provider] Logout Started");

    await _authService.logout();

    _currentUserModel = null;

    notifyListeners();

    print("[Provider] Logout Completed");
  }
}