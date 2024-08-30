import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import 'loan_application_screen.dart';
import 'loan_status_screen.dart';
import 'repayment_screen.dart';
import 'login_screen.dart';
import 'loan_approval_screen.dart';
import 'user_management_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashboardScreen(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Loan Management App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            if (UserService.hasRole(UserRole.customer))
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Apply for Loan'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoanApplicationScreen()),
                  );
                },
              ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Loan Status'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoanStatusScreen()),
                );
              },
            ),
            if (UserService.hasRole(UserRole.customer))
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Make Repayment'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RepaymentScreen()),
                  );
                },
              ),
            if (UserService.canApproveLoans())
              ListTile(
                leading: Icon(Icons.approval),
                title: Text('Approve Loans'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoanApprovalScreen()),
                  );
                },
              ),
            if (UserService.canManageUsers())
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Manage Users'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserManagementScreen()),
                  );
                },
              ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () => _logout(context),
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