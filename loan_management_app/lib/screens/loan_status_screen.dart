import 'package:flutter/material.dart';
import '../models/loan.dart';

class LoanStatusScreen extends StatelessWidget {
  const LoanStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch actual loan data
    final List<Loan> loans = [
      Loan(
        id: '1',
        userId: 'user1',
        amount: 10000,
        interestRate: 5.5,
        termMonths: 12,
        applicationDate: DateTime.now().subtract(const Duration(days: 30)),
        status: LoanStatus.approved,
      ),
      Loan(
        id: '2',
        userId: 'user1',
        amount: 5000,
        interestRate: 6.0,
        termMonths: 6,
        applicationDate: DateTime.now().subtract(const Duration(days: 15)),
        status: LoanStatus.pending,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Status'),
      ),
      body: ListView.builder(
        itemCount: loans.length,
        itemBuilder: (context, index) {
          final loan = loans[index];
          return Card(
            child: ListTile(
              title: Text('Loan #${loan.id}'),
              subtitle: Text('Amount: \$${loan.amount.toStringAsFixed(2)}'),
              trailing: Text(loan.status.toString().split('.').last),
              onTap: () {
                // TODO: Navigate to detailed loan view
              },
            ),
          );
        },
      ),
    );
  }
}