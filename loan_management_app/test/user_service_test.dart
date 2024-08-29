import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:loan_management_app/models/user.dart';
import 'package:loan_management_app/services/user_service.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveBox extends Mock implements Box<User> {}

void main() {
  late MockHiveBox mockUsersBox;

  setUp(() {
    mockUsersBox = MockHiveBox();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(UserRoleAdapter());
  });

  group('UserService', () {
    test('authenticate should return true for valid credentials', () async {
      final user = User(id: '1', name: 'John Doe', email: 'john@example.com', role: UserRole.customer);
      when(() => mockUsersBox.values).thenReturn([user]);

      final result = await UserService.authenticate('john@example.com', 'password');

      expect(result, true);
      expect(UserService.currentUser, user);
    });

    test('authenticate should return false for invalid credentials', () async {
      when(() => mockUsersBox.values).thenReturn([]);

      final result = await UserService.authenticate('invalid@example.com', 'password');

      expect(result, false);
      expect(UserService.currentUser, null);
    });

    test('registerUser should add a new user', () async {
      final user = User(id: '1', name: 'John Doe', email: 'john@example.com', role: UserRole.customer);
      when(() => mockUsersBox.put(any(), any())).thenAnswer((_) async {});

      await UserService.registerUser(user);

      verify(() => mockUsersBox.put(user.id, user)).called(1);
    });

    test('getAllUsers should return all users', () async {
      final users = [
        User(id: '1', name: 'John Doe', email: 'john@example.com', role: UserRole.customer),
        User(id: '2', name: 'Jane Doe', email: 'jane@example.com', role: UserRole.loanOfficer),
      ];
      when(() => mockUsersBox.values).thenReturn(users);

      final result = await UserService.getAllUsers();

      expect(result, users);
    });

    test('deleteUser should remove a user', () async {
      when(() => mockUsersBox.delete(any())).thenAnswer((_) async {});

      await UserService.deleteUser('1');

      verify(() => mockUsersBox.delete('1')).called(1);
    });
  });
}