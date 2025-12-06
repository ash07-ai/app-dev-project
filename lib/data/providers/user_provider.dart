import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = [];

  List<User> get users => [..._users];
  List<User> get adminUsers => _users.where((u) => u.isAdmin).toList();
  List<User> get regularUsers => _users.where((u) => !u.isAdmin).toList();

  // Load users from Firebase (Note: This needs to be implemented with Firestore)
  // For now, this is a placeholder that works with the current structure
  void loadUsers() {
    // TODO: Implement Firestore user loading
    // This will need to fetch users from Firestore collection
    _users = [];
    notifyListeners();
  }
  
  // Get all credentials (for compatibility with old code)
  // This method is deprecated - use FirebaseAuthService.getAllUsersStream() instead
  Map<String, dynamic> getAllCredentials() {
    // This is a compatibility method - Firebase doesn't work this way
    // But keeping it to prevent breaking existing code
    return {};
  }

  // Get user by email
  User? getUserByEmail(String email) {
    try {
      return _users.firstWhere((u) => u.email == email);
    } catch (e) {
      return null;
    }
  }

  // Update user
  void updateUser(User updatedUser) {
    final index = _users.indexWhere((u) => u.id == updatedUser.id);
    if (index >= 0) {
      _users[index] = updatedUser;
      notifyListeners();
    }
  }

  // Delete user (cannot delete current user)
  bool deleteUser(String userId, String currentUserEmail) {
    if (userId == currentUserEmail) {
      return false; // Cannot delete current user
    }
    _users.removeWhere((u) => u.id == userId);
    notifyListeners();
    return true;
  }

  // Toggle admin status
  void toggleAdminStatus(String userId) {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index >= 0) {
      final user = _users[index];
      _users[index] = User(
        id: user.id,
        name: user.name,
        email: user.email,
        isAdmin: !user.isAdmin,
        profileImage: user.profileImage,
        phoneNumber: user.phoneNumber,
        address: user.address,
      );
      notifyListeners();
    }
  }

  // Get total user count
  int get totalUsers => _users.length;
  int get adminCount => adminUsers.length;
  int get regularUserCount => regularUsers.length;
}

