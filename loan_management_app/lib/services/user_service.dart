import '../models/user.dart';

class UserService {
  static final Map<String, User> _users = {
    'user@example.com': User(
      id: 'user1',
      name: 'John Doe',
      email: 'user@example.com',
      role: 'customer',
    ),
    'admin@example.com': User(
      id: 'admin1',
      name: 'Admin User',
      email: 'admin@example.com',
      role: 'admin',
    ),
  };

  static User? currentUser;

  static bool authenticate(String email, String password) {
    // TODO: Implement actual authentication logic
    if (_users.containsKey(email)) {
      currentUser = _users[email];
      return true;
    }
    return false;
  }

  static void logout() {
    currentUser = null;
  }

  static bool isLoggedIn() {
    return currentUser != null;
  }
}