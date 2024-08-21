import 'package:flutter/material.dart';
import '../models/loan.dart';
import '../models/payment.dart';

class RepaymentScreen extends StatelessWidget {
  const RepaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch actual loan and payment data
    final Loan loan = Loan(
      id: '1',
      userId: 'user1',
      amount: 10000,
      interestRate: 5.5,
      termMonths: 12,
      applicationDate: DateTime.now().subtract(const Duration(days: 30)),
      status: LoanStatus.disbursed,
    );

    final List<Payment> payments = [
      Payment(
        id: '1',
        loanId: '1',
        amount: 865.28,
        dueDate: DateTime.now().add(const Duration(days: 30)),
        status: PaymentStatus.scheduled,
      ),
      Payment(
        id: '2',
        loanId: '1',
        amount: 865.28,
        dueDate: DateTime.now().add(const Duration(days: 60)),
        status: PaymentStatus.scheduled,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repayment'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Loan #${loan.id}', style: Theme.of(context).textTheme.headline6),
                  Text('Amount: \$${loan.amount.toStringAsFixed(2)}'),
                  Text('Interest Rate: ${loan.interestRate}%'),
                  Text('Term: ${loan.termMonths} months'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                return Card(
                  child: ListTile(
                    title: Text('Payment #${index + 1}'),
                    subtitle: Text('Due: ${payment.dueDate.toString().split(' ')[0]}'),
                    trailing: Text('\$${payment.amount.toStringAsFixed(2)}'),
                    onTap: () {
                      // TODO: Implement payment functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Payment of \$${payment.amount.toStringAsFixed(2)} processed')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}