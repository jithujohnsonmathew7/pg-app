import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class AuthProvider extends ChangeNotifier {
  final DatabaseService _database;
  User? _currentUser;

  AuthProvider(this._database);

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> loadCurrentUser(String userId) async {
    try {
      _currentUser = await _database.getUser(userId);
      notifyListeners();
    } catch (e) {
      print('Error loading current user: $e');
    }
  }

  Future<User?> loginWithEmail(String email) async {
    try {
      final users = await _database.getAllUsers();
      final user = users.firstWhere(
        (u) => u.email == email && u.isActive,
        orElse: () => null as dynamic,
      );
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
      return user;
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  Future<void> signUp(User user) async {
    try {
      await _database.addUser(user);
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      print('Error during sign up: $e');
      rethrow;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  bool isOwner() => _currentUser?.role == UserRole.owner;
  bool isTenant() => _currentUser?.role == UserRole.tenant;
}
