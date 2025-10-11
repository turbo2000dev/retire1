import 'package:retire1/features/auth/domain/user.dart';

/// Mock authentication repository for testing
/// Accepts any email/password combination and simulates network delay
class AuthRepositoryMock {
  // In-memory storage of registered users
  final Map<String, Map<String, String>> _users = {};
  User? _currentUser;

  /// Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Mock login - accepts any email/password
  Future<User> login(String email, String password) async {
    await _simulateDelay();

    // Check if user exists in our mock storage
    if (_users.containsKey(email)) {
      final userData = _users[email]!;
      // In a real app, we'd check password here
      // For mock, we accept any password

      _currentUser = User(
        id: email.hashCode.toString(),
        email: email,
        displayName: userData['displayName'],
      );

      return _currentUser!;
    }

    // If user doesn't exist, throw error
    throw Exception('Invalid email or password');
  }

  /// Mock registration - stores user in memory
  Future<User> register(String email, String password, String displayName) async {
    await _simulateDelay();

    // Check if user already exists
    if (_users.containsKey(email)) {
      throw Exception('Email already in use');
    }

    // Store user in memory
    _users[email] = {
      'password': password,
      'displayName': displayName,
    };

    _currentUser = User(
      id: email.hashCode.toString(),
      email: email,
      displayName: displayName,
    );

    return _currentUser!;
  }

  /// Mock logout
  Future<void> logout() async {
    await _simulateDelay();
    _currentUser = null;
  }

  /// Get current user
  User? get currentUser => _currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => _currentUser != null;
}
