import 'package:hive/hive.dart';
import '../models/user.dart';

class UserService {
  static User? currentUser;

  static Future<bool> authenticate(String email, String password) async {
    final usersBox = Hive.box<User>('users');
    final user = usersBox.values.firstWhere(
      (user) => user.email == email,
      orElse: () => User(id: '', name: '', email: '', role: UserRole.customer),
    );

    if (user.id.isNotEmpty) {
      // TODO: Implement actual password checking
      currentUser = user;
      return true;
    }
    return false;
  }

  static Future<void> registerUser(User user) async {
    final usersBox = Hive.box<User>('users');
    await usersBox.put(user.id, user);
  }

  static void logout() {
    currentUser = null;
  }

  static bool isLoggedIn() {
    return currentUser != null;
  }

  static bool hasRole(UserRole role) {
    return currentUser?.role == role;
  }

  static bool canApproveLoans() {
    return currentUser?.role == UserRole.loanOfficer || currentUser?.role == UserRole.admin;
  }

  static bool canManageUsers() {
    return currentUser?.role == UserRole.admin;
  }

  static Future<List<User>> getAllUsers() async {
    final usersBox = Hive.box<User>('users');
    return usersBox.values.toList();
  }

  static Future<User?> getUserById(String id) async {
    final usersBox = Hive.box<User>('users');
    return usersBox.get(id);
  }

  static Future<void> updateUser(User user) async {
    final usersBox = Hive.box<User>('users');
    await usersBox.put(user.id, user);
  }

  static Future<void> deleteUser(String id) async {
    final usersBox = Hive.box<User>('users');
    await usersBox.delete(id);
  }
}