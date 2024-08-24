import 'package:flutter/material.dart';
import '../models/loan.dart';
import '../models/payment.dart';
import '../services/loan_service.dart';
import '../services/payment_service.dart';
import '../services/user_service.dart';

class RepaymentScreen extends StatefulWidget {
  const RepaymentScreen({Key? key}) : super(key: key);

  @override
  _RepaymentScreenState createState() => _RepaymentScreenState();
}

class _RepaymentScreenState extends State<RepaymentScreen> {
  late Future<List<Loan>> _loansFuture;

  @override
  void initState() {
    super.initState();
    _loansFuture = _fetchLoans();
  }

  Future<List<Loan>> _fetchLoans() async {
    final currentUser = UserService.currentUser;
    if (currentUser == null) {
      throw Exception('User not logged in');
    }
    return LoanService.getLoansByUserId(currentUser.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repayment'),
      ),
      body: FutureBuilder<List<Loan>>(
        future: _loansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No loans found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final loan = snapshot.data![index];
                return ExpansionTile(
                  title: Text('Loan #${loan.id}'),
                  subtitle: Text('Amount: \$${loan.amount.toStringAsFixed(2)}'),
                  children: [
                    FutureBuilder<List<Payment>>(
                      future: PaymentService.getPaymentsByLoanId(loan.id),
                      builder: (context, paymentSnapshot) {
                        if (paymentSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (paymentSnapshot.hasError) {
                          return Center(child: Text('Error: ${paymentSnapshot.error}'));
                        } else if (!paymentSnapshot.hasData || paymentSnapshot.data!.isEmpty) {
                          return const Center(child: Text('No payments found.'));
                        } else {
                          return Column(
                            children: paymentSnapshot.data!.map((payment) {
                              return ListTile(
                                title: Text('Payment #${payment.id}'),
                                subtitle: Text('Amount: \$${payment.amount.toStringAsFixed(2)}'),
                                trailing: Text(payment.status.toString().split('.').last),
                                onTap: () {
                                  // TODO: Implement payment functionality
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Payment of \$${payment.amount.toStringAsFixed(2)} processed')),
                                  );
                                },
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}