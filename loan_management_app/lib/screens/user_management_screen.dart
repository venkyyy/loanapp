import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'user_form_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUsers();
  }

  Future<List<User>> _fetchUsers() async {
    return UserService.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: Text(user.role.toString().split('.').last),
                    onTap: () => _showUserDetails(user),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewUser,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showUserDetails(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.name),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Email: ${user.email}'),
            Text('Role: ${user.role.toString().split('.').last}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () => _editUser(user),
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () => _deleteUser(user),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _addNewUser() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserFormScreen()),
    );

    if (result == true) {
      setState(() {
        _usersFuture = _fetchUsers();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added successfully')),
      );
    }
  }

  Future<void> _editUser(User user) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserFormScreen(user: user)),
    );

    if (result == true) {
      setState(() {
        _usersFuture = _fetchUsers();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully')),
      );
    }
  }

  Future<void> _deleteUser(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await UserService.deleteUser(user.id);
        setState(() {
          _usersFuture = _fetchUsers();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting user: $e')),
        );
      }
    }
  }
}