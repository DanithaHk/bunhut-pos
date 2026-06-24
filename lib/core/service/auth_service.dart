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
    print("[AuthService] Fetching user profile...");
    print("[AuthService] UID: $uid");

    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      print("[AuthService] Document Exists: ${doc.exists}");
      print("[AuthService] Document Data: ${doc.data()}");

      if (!doc.exists || doc.data() == null) {
        print("[AuthService] User document not found");
        return null;
      }

      final user = UserModel.fromMap(
        doc.data() as Map<String, dynamic>,
        uid,
      );

      print("[AuthService] UserModel Created");
      print("[AuthService] Email: ${user.email}");
      print("[AuthService] Role: ${user.role}");

      return user;
    } catch (e) {
      print("[AuthService] ERROR: $e");
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
      print("[AuthService] Creating user: $email");

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

        print("[AuthService] User Created");
        print("[AuthService] UID: ${credential.user!.uid}");
      }
    } catch (e) {
      print("[AuthService] Register Error: $e");
      rethrow;
    } finally {
      if (secondaryApp != null) {
        await secondaryApp.delete();
      }
    }
  }

  Future<void> changePassword(String password) async {
    print("[AuthService] Updating password");

    if (_auth.currentUser != null) {
      await _auth.currentUser!.updatePassword(password);
    }
  }

  Future<void> logout() async {
    print("[AuthService] Logging out");

    await _auth.signOut();
  }
}