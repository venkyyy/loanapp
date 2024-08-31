import 'package:flutter/material.dart';
import '../models/loan_application.dart';
import '../services/loan_application_service.dart';
import '../services/loan_service.dart';
import '../services/loan_disbursement_service.dart';
import '../models/loan.dart';

class LoanApprovalScreen extends StatefulWidget {
  const LoanApprovalScreen({Key? key}) : super(key: key);

  @override
  _LoanApprovalScreenState createState() => _LoanApprovalScreenState();
}

class _LoanApprovalScreenState extends State<LoanApprovalScreen> {
  late Future<List<LoanApplication>> _pendingApplicationsFuture;

  @override
  void initState() {
    super.initState();
    _pendingApplicationsFuture = _fetchPendingApplications();
  }

  Future<List<LoanApplication>> _fetchPendingApplications() async {
    final applications = await LoanApplicationService.getAllLoanApplications();
    return applications.where((app) => app.status == ApplicationStatus.pending).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Approval'),
      ),
      body: FutureBuilder<List<LoanApplication>>(
        future: _pendingApplicationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pending loan applications.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final application = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text('Application #${application.id}'),
                    subtitle: Text('Amount: \$${application.requestedAmount.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => _approveApplication(application),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _rejectApplication(application),
                        ),
                      ],
                    ),
                    onTap: () => _showApplicationDetails(application),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showApplicationDetails(LoanApplication application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Application #${application.id}'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Amount: \$${application.requestedAmount.toStringAsFixed(2)}'),
            Text('Term: ${application.requestedTermMonths} months'),
            Text('Application Date: ${application.applicationDate.toString().split(' ')[0]}'),
            Text('Status: ${application.status.toString().split('.').last}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _approveApplication(LoanApplication application) async {
    try {
      // Update application status
      application.status = ApplicationStatus.approved;
      await LoanApplicationService.updateLoanApplication(application);

      // Create a new loan
      final loan = Loan(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: application.userId,
        amount: application.requestedAmount,
        interestRate: 5.0, // TODO: Implement dynamic interest rate calculation
        termMonths: application.requestedTermMonths,
        applicationDate: application.applicationDate,
        status: LoanStatus.approved,
      );

      await LoanService.createLoan(loan);

      // Disburse the loan
      await LoanDisbursementService.disburseLoan(loan);

      // Simulate bank transfer
      await LoanDisbursementService.simulateBankTransfer(loan);

      setState(() {
        _pendingApplicationsFuture = _fetchPendingApplications();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application approved and loan disbursed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving application: $e')),
      );
    }
  }

  Future<void> _rejectApplication(LoanApplication application) async {
    try {
      application.status = ApplicationStatus.rejected;
      await LoanApplicationService.updateLoanApplication(application);

      setState(() {
        _pendingApplicationsFuture = _fetchPendingApplications();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application rejected successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting application: $e')),
      );
    }
  }
}