import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import 'loan_application_screen.dart';
import 'loan_status_screen.dart';
import 'repayment_screen.dart';
import 'login_screen.dart';
import 'loan_approval_screen.dart';
import 'user_management_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Management App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${UserService.currentUser?.name ?? "User"}!'),
            const SizedBox(height: 20),
            if (UserService.hasRole(UserRole.customer))
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoanApplicationScreen()),
                  );
                },
                child: const Text('Apply for Loan'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoanStatusScreen()),
                );
              },
              child: const Text('Check Loan Status'),
            ),
            const SizedBox(height: 20),
            if (UserService.hasRole(UserRole.customer))
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RepaymentScreen()),
                  );
                },
                child: const Text('Make Repayment'),
              ),
            if (UserService.canApproveLoans())
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoanApprovalScreen()),
                  );
                },
                child: const Text('Approve Loans'),
              ),
            if (UserService.canManageUsers())
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserManagementScreen()),
                  );
                },
                child: const Text('Manage Users'),
              ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    UserService.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}