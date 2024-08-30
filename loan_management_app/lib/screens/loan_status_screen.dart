import 'package:flutter/material.dart';
import '../models/loan.dart';
import '../services/loan_service.dart';
import '../services/user_service.dart';

class LoanStatusScreen extends StatefulWidget {
  const LoanStatusScreen({Key? key}) : super(key: key);

  @override
  _LoanStatusScreenState createState() => _LoanStatusScreenState();
}

class _LoanStatusScreenState extends State<LoanStatusScreen> {
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
        title: const Text('Loan Status'),
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
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text('Loan #${loan.id}'),
                    subtitle: Text('Amount: \$${loan.amount.toStringAsFixed(2)}'),
                    trailing: _getLoanStatusChip(loan.status),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Interest Rate: ${loan.interestRate}%'),
                            Text('Term: ${loan.termMonths} months'),
                            Text('Application Date: ${_formatDate(loan.applicationDate)}'),
                            const SizedBox(height: 8),
                            Text('Status: ${loan.status.toString().split('.').last}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Implement view repayment schedule
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Repayment schedule not implemented yet')),
                                );
                              },
                              child: const Text('View Repayment Schedule'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _getLoanStatusChip(LoanStatus status) {
    Color color;
    switch (status) {
      case LoanStatus.pending:
        color = Colors.orange;
        break;
      case LoanStatus.approved:
        color = Colors.green;
        break;
      case LoanStatus.rejected:
        color = Colors.red;
        break;
      case LoanStatus.disbursed:
        color = Colors.blue;
        break;
      case LoanStatus.closed:
        color = Colors.grey;
        break;
    }
    return Chip(
      label: Text(status.toString().split('.').last),
      backgroundColor: color,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}