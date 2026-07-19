import '../../core/utils/app_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../model/user.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth get auth => _auth;

  /// Get user profile from Firestore
  Future<UserModel?> getUserProfile(String uid) async {
    AppLogger.log(
      "Fetching user profile",
      name: "AuthService",
    );

    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      AppLogger.log(
        "Document Exists: ${doc.exists}",
        name: "AuthService",
      );

      AppLogger.log(
        "Document Data: ${doc.data()}",
        name: "AuthService",
      );

      if (!doc.exists || doc.data() == null) {
        AppLogger.log(
          "User document not found",
          name: "AuthService",
        );
        return null;
      }

      final user = UserModel.fromMap(
        doc.data() as Map<String, dynamic>,
        uid,
      );

      AppLogger.log(
        "UserModel Created",
        name: "AuthService",
      );

      AppLogger.log(
        "Email: ${user.email}",
        name: "AuthService",
      );

      AppLogger.log(
        "Role: ${user.role}",
        name: "AuthService",
      );

      return user;
    }catch (e) {
      AppLogger.error(
        "Get user profile failed",
        error: e,
        name: "AuthService",
      );

      rethrow;
    }
  }

  /// Register new user without logging out current admin
  Future<void> registerUser({
    required String email,
    required String password,
    required String role,
  }) async {
    FirebaseApp? secondaryApp;

    try {
      AppLogger.log(
        "Creating user: $email",
        name: "AuthService",
      );

      final appName =
          'UserCreationApp_${DateTime.now().millisecondsSinceEpoch}';

      secondaryApp = await Firebase.initializeApp(
        name: appName,
        options: Firebase.app().options,
      );

      final secondaryAuth =
      FirebaseAuth.instanceFor(app: secondaryApp);

      final credential =
      await secondaryAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
        });

        AppLogger.log(
          "User Created",
          name: "AuthService",
        );

        AppLogger.log(
          "UID: ${credential.user!.uid}",
          name: "AuthService",
        );
      }
    } catch (e) {

      AppLogger.error(
        "Register Error",
        error: e,
        name: "AuthService",
      );

      rethrow;
    } finally {
      if (secondaryApp != null) {
        await secondaryApp.delete();
      }
    }
  }
  Future<void> changePassword(String password) async {

    try {

      AppLogger.log(
        "Updating password",
        name: "AuthService",
      );

      if (_auth.currentUser != null) {
        await _auth.currentUser!.updatePassword(password);
      }

    } catch (e) {

      AppLogger.error(
        "Password update failed",
        error: e,
        name: "AuthService",
      );

      rethrow;
    }
  }

  Future<void> logout() async {
    AppLogger.log(
      "Updating password",
      name: "AuthService",
    );

    await _auth.signOut();
  }
}