import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class UserCredential {
  final String email;
  final String password;
  final String fullName;
  final String? userType;
  final String? profileImage;

  UserCredential({
    required this.email,
    required this.password,
    required this.fullName,
    this.userType = 'user',
    this.profileImage,
  });

  factory UserCredential.fromJson(Map<String, dynamic> json) {
    return UserCredential(
      email: json['email'] as String,
      password: json['password'] as String,
      fullName: json['fullName'] as String,
      userType: json['userType'] as String? ?? 'user',
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'fullName': fullName,
      'userType': userType,
      'profileImage': profileImage,
    };
  }
}

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  UserCredential? _currentUser;
  bool _isAuthenticated = false;
  Map<String, UserCredential> _credentials = {};
  bool _credentialsLoaded = false;

  // Getters
  UserCredential? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _currentUser?.userType == 'admin';
  String get userName => _currentUser?.fullName ?? 'Guest';
  String get userEmail => _currentUser?.email ?? '';
  bool get credentialsLoaded => _credentialsLoaded;

  /// Load credentials from JSON file
  Future<void> loadCredentialsFromJson() async {
    try {
      final jsonString = await rootBundle.loadString('assets/credentials.json');
      final jsonData = jsonDecode(jsonString);

      // Clear existing credentials
      _credentials.clear();

      // Parse the JSON and populate credentials
      if (jsonData['users'] is List) {
        for (var userJson in jsonData['users']) {
          final credential = UserCredential.fromJson(userJson);
          _credentials[credential.email] = credential;
        }
      }

      _credentialsLoaded = true;
      notifyListeners();
      print('✅ Credentials loaded: ${_credentials.length} users');
    } catch (e) {
      print('❌ Error loading credentials: $e');
      _credentialsLoaded = false;
      notifyListeners();
    }
  }

  /// Login with email and password
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Make sure credentials are loaded
      if (!_credentialsLoaded) {
        await loadCredentialsFromJson();
      }

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if credentials exist
      if (!_credentials.containsKey(email)) {
        return {'success': false, 'message': 'Email not found', 'user': null};
      }

      final credential = _credentials[email]!;

      // Verify password
      if (credential.password != password) {
        return {
          'success': false,
          'message': 'Incorrect password',
          'user': null,
        };
      }

      // Login successful
      _currentUser = credential;
      _isAuthenticated = true;
      notifyListeners();

      print('✅ Login successful: ${credential.email}');

      return {
        'success': true,
        'message': 'Login successful',
        'user': credential,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Login error: ${e.toString()}',
        'user': null,
      };
    }
  }

  /// Signup with new credentials
  Future<Map<String, dynamic>> signup(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      // Make sure credentials are loaded
      if (!_credentialsLoaded) {
        await loadCredentialsFromJson();
      }

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if email already exists
      if (_credentials.containsKey(email)) {
        return {
          'success': false,
          'message': 'Email already exists',
          'user': null,
        };
      }

      // Validate password
      if (password.length < 6) {
        return {
          'success': false,
          'message': 'Password must be at least 6 characters',
          'user': null,
        };
      }

      // Create new credential
      final newCredential = UserCredential(
        email: email,
        password: password,
        fullName: fullName,
        userType: 'user',
      );

      // Add to credentials map
      _credentials[email] = newCredential;

      // Login the new user
      _currentUser = newCredential;
      _isAuthenticated = true;
      notifyListeners();

      print('✅ Signup successful: ${newCredential.email}');

      return {
        'success': true,
        'message': 'Signup successful',
        'user': newCredential,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Signup error: ${e.toString()}',
        'user': null,
      };
    }
  }

  /// Password reset
  Future<Map<String, dynamic>> resetPassword(
    String email,
    String newPassword,
  ) async {
    try {
      // Make sure credentials are loaded
      if (!_credentialsLoaded) {
        await loadCredentialsFromJson();
      }

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      if (!_credentials.containsKey(email)) {
        return {'success': false, 'message': 'Email not found'};
      }

      if (newPassword.length < 6) {
        return {
          'success': false,
          'message': 'Password must be at least 6 characters',
        };
      }

      // Update password
      final credential = _credentials[email]!;
      _credentials[email] = UserCredential(
        email: credential.email,
        password: newPassword,
        fullName: credential.fullName,
        userType: credential.userType,
        profileImage: credential.profileImage,
      );

      print('✅ Password reset successful: $email');

      return {'success': true, 'message': 'Password reset successful'};
    } catch (e) {
      return {'success': false, 'message': 'Reset error: ${e.toString()}'};
    }
  }

  /// Logout
  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
    print('✅ Logged out');
  }

  /// Get all credentials (debugging)
  Map<String, UserCredential> getAllCredentials() => _credentials;

  /// Add credential manually
  void addCredential(UserCredential credential) {
    _credentials[credential.email] = credential;
    notifyListeners();
  }
}
