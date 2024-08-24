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
                  child: ListTile(
                    title: Text('Loan #${loan.id}'),
                    subtitle: Text('Amount: \$${loan.amount.toStringAsFixed(2)}'),
                    trailing: Text(loan.status.toString().split('.').last),
                    onTap: () {
                      // TODO: Navigate to detailed loan view
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Detailed loan view not implemented yet')),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}