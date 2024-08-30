import 'package:flutter/material.dart';
import '../models/loan.dart';
import '../models/loan_application.dart';
import '../services/loan_service.dart';
import '../services/loan_application_service.dart';
import '../services/user_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, dynamic>> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = _fetchDashboardData();
  }

  Future<Map<String, dynamic>> _fetchDashboardData() async {
    final currentUser = UserService.currentUser;
    if (currentUser == null) {
      throw Exception('User not logged in');
    }

    final loans = await LoanService.getLoansByUserId(currentUser.id);
    final applications = await LoanApplicationService.getLoanApplicationsByUserId(currentUser.id);

    return {
      'loans': loans,
      'applications': applications,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          } else {
            final loans = snapshot.data!['loans'] as List<Loan>;
            final applications = snapshot.data!['applications'] as List<LoanApplication>;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${UserService.currentUser?.name ?? "User"}!',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(height: 24),
                  _buildSummaryCard('Active Loans', loans.where((loan) => loan.status == LoanStatus.disbursed).length),
                  const SizedBox(height: 16),
                  _buildSummaryCard('Pending Applications', applications.where((app) => app.status == ApplicationStatus.pending).length),
                  const SizedBox(height: 24),
                  Text('Recent Loans', style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 8),
                  _buildLoansList(loans),
                  const SizedBox(height: 24),
                  Text('Recent Applications', style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 8),
                  _buildApplicationsList(applications),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, int count) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.subtitle1),
            const SizedBox(height: 8),
            Text(count.toString(), style: Theme.of(context).textTheme.headline4),
          ],
        ),
      ),
    );
  }

  Widget _buildLoansList(List<Loan> loans) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: loans.take(3).length,
      itemBuilder: (context, index) {
        final loan = loans[index];
        return ListTile(
          title: Text('Loan #${loan.id}'),
          subtitle: Text('\$${loan.amount.toStringAsFixed(2)}'),
          trailing: Chip(
            label: Text(loan.status.toString().split('.').last),
            backgroundColor: _getLoanStatusColor(loan.status),
          ),
        );
      },
    );
  }

  Widget _buildApplicationsList(List<LoanApplication> applications) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: applications.take(3).length,
      itemBuilder: (context, index) {
        final application = applications[index];
        return ListTile(
          title: Text('Application #${application.id}'),
          subtitle: Text('\$${application.requestedAmount.toStringAsFixed(2)}'),
          trailing: Chip(
            label: Text(application.status.toString().split('.').last),
            backgroundColor: _getApplicationStatusColor(application.status),
          ),
        );
      },
    );
  }

  Color _getLoanStatusColor(LoanStatus status) {
    switch (status) {
      case LoanStatus.pending:
        return Colors.orange;
      case LoanStatus.approved:
        return Colors.green;
      case LoanStatus.rejected:
        return Colors.red;
      case LoanStatus.disbursed:
        return Colors.blue;
      case LoanStatus.closed:
        return Colors.grey;
    }
  }

  Color _getApplicationStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Colors.orange;
      case ApplicationStatus.underReview:
        return Colors.blue;
      case ApplicationStatus.approved:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
    }
  }
}