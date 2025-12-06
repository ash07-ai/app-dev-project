// lib/core/services/firebase_auth_service.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCredential {
  final String uid;
  final String email;
  final String fullName;
  final String userType;
  final String? profileImage;
  final String? phoneNumber;
  final String? address;

  UserCredential({
    required this.uid,
    required this.email,
    required this.fullName,
    this.userType = 'user',
    this.profileImage,
    this.phoneNumber,
    this.address,
  });

  factory UserCredential.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserCredential(
      uid: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      userType: data['userType'] ?? 'user',
      profileImage: data['profileImage'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'fullName': fullName,
      'userType': userType,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'address': address,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class FirebaseAuthService extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserCredential? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = true;

  // Getters
  UserCredential? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _currentUser?.userType == 'admin';
  String get userName => _currentUser?.fullName ?? 'Guest';
  String get userEmail => _currentUser?.email ?? '';
  bool get isLoading => _isLoading;

  FirebaseAuthService() {
    _initAuthListener();
  }

  /// Initialize authentication state listener
  void _initAuthListener() {
    _auth.authStateChanges().listen((firebase_auth.User? firebaseUser) async {
      if (firebaseUser != null) {
        await _loadUserData(firebaseUser.uid);
      } else {
        _currentUser = null;
        _isAuthenticated = false;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  /// Load user data from Firestore
  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _currentUser = UserCredential.fromFirestore(doc);
        _isAuthenticated = true;
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
    }
  }

  /// Signup with email and password
  Future<Map<String, dynamic>> signup(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      // Validate password
      if (password.length < 6) {
        return {
          'success': false,
          'message': 'Password must be at least 6 characters',
        };
      }

      // Create Firebase Auth user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Create user document in Firestore
      final userCredential = UserCredential(
        uid: credential.user!.uid,
        email: email.trim(),
        fullName: fullName.trim(),
        userType: 'user',
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(userCredential.toFirestore());

      // Update display name
      await credential.user!.updateDisplayName(fullName);

      // Load user data
      await _loadUserData(credential.user!.uid);

      print('✅ Signup successful: ${credential.user!.email}');

      return {
        'success': true,
        'message': 'Signup successful',
        'user': _currentUser,
      };
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Signup failed';
      switch (e.code) {
        case 'weak-password':
          message = 'The password is too weak';
          break;
        case 'email-already-in-use':
          message = 'Email already exists';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        default:
          message = e.message ?? 'Signup failed';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Signup error: ${e.toString()}'};
    }
  }

  /// Login with email and password
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Load user data
      await _loadUserData(credential.user!.uid);

      print('✅ Login successful: ${credential.user!.email}');

      return {
        'success': true,
        'message': 'Login successful',
        'user': _currentUser,
      };
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Login failed';
      switch (e.code) {
        case 'user-not-found':
          message = 'Email not found';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later';
          break;
        default:
          message = e.message ?? 'Login failed';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Login error: ${e.toString()}'};
    }
  }

  /// Reset password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      print('✅ Password reset email sent to: $email');
      return {
        'success': true,
        'message': 'Password reset email sent. Check your inbox.',
      };
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Password reset failed';
      switch (e.code) {
        case 'user-not-found':
          message = 'Email not found';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        default:
          message = e.message ?? 'Password reset failed';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
    print('✅ Logged out');
  }

  /// Update user profile
  Future<bool> updateUserProfile({
    String? fullName,
    String? phoneNumber,
    String? address,
    String? profileImage,
  }) async {
    if (_currentUser == null) return false;

    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (fullName != null) updates['fullName'] = fullName;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (address != null) updates['address'] = address;
      if (profileImage != null) updates['profileImage'] = profileImage;

      await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .update(updates);

      // Reload user data
      await _loadUserData(_currentUser!.uid);

      print('✅ Profile updated');
      return true;
    } catch (e) {
      print('❌ Error updating profile: $e');
      return false;
    }
  }

  /// Get all users (for admin)
  Stream<List<UserCredential>> getAllUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserCredential.fromFirestore(doc))
          .toList();
    });
  }

  /// Toggle admin status (admin only)
  Future<bool> toggleAdminStatus(String userId) async {
    if (!isAdmin) return false;

    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return false;

      final currentType = doc.data()?['userType'] ?? 'user';
      final newType = currentType == 'admin' ? 'user' : 'admin';

      await _firestore.collection('users').doc(userId).update({
        'userType': newType,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Admin status toggled for user: $userId');
      return true;
    } catch (e) {
      print('❌ Error toggling admin status: $e');
      return false;
    }
  }

  /// Delete user (admin only)
  Future<bool> deleteUser(String userId) async {
    if (!isAdmin || userId == _currentUser?.uid) return false;

    try {
      await _firestore.collection('users').doc(userId).delete();
      print('✅ User deleted: $userId');
      return true;
    } catch (e) {
      print('❌ Error deleting user: $e');
      return false;
    }
  }

  /// Create initial admin account (call this once)
  Future<void> createInitialAdmin(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final adminUser = UserCredential(
        uid: credential.user!.uid,
        email: email,
        fullName: fullName,
        userType: 'admin',
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(adminUser.toFirestore());

      print('✅ Initial admin created: $email');
    } catch (e) {
      print('❌ Error creating admin: $e');
    }
  }
}
