import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/loan_application.dart';
import '../services/loan_application_service.dart';
import '../services/user_service.dart';

class LoanApplicationScreen extends StatefulWidget {
  const LoanApplicationScreen({Key? key}) : super(key: key);

  @override
  _LoanApplicationScreenState createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _termController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Application'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Loan Amount',
                  prefixText: '\$',
                  helperText: 'Enter an amount between \$1,000 and \$100,000',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateAmount,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _termController,
                decoration: const InputDecoration(
                  labelText: 'Loan Term (months)',
                  suffixText: 'months',
                  helperText: 'Enter a term between 6 and 60 months',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateTerm,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'Loan Purpose',
                  helperText: 'Provide a detailed explanation (minimum 10 characters)',
                ),
                maxLines: 3,
                validator: _validatePurpose,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _uploadDocuments,
                child: const Text('Upload Documents'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitApplication,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a loan amount';
    }
    final amount = int.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number';
    }
    if (amount < 1000) {
      return 'Minimum loan amount is \$1,000';
    }
    if (amount > 100000) {
      return 'Maximum loan amount is \$100,000';
    }
    return null;
  }

  String? _validateTerm(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a loan term';
    }
    final term = int.tryParse(value);
    if (term == null) {
      return 'Please enter a valid number';
    }
    if (term < 6) {
      return 'Minimum loan term is 6 months';
    }
    if (term > 60) {
      return 'Maximum loan term is 60 months';
    }
    return null;
  }

  String? _validatePurpose(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the purpose of the loan';
    }
    if (value.length < 10) {
      return 'Please provide more details about the loan purpose (minimum 10 characters)';
    }
    return null;
  }

  void _uploadDocuments() {
    // TODO: Implement document upload functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document upload functionality not implemented yet')),
    );
  }

  Future<void> _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final currentUser = UserService.currentUser;
        if (currentUser == null) {
          throw Exception('User not logged in');
        }

        final loanApplication = LoanApplication(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: currentUser.id,
          requestedAmount: double.parse(_amountController.text),
          requestedTermMonths: int.parse(_termController.text),
          applicationDate: DateTime.now(),
          status: ApplicationStatus.pending,
          documents: [], // TODO: Add uploaded documents
        );

        await LoanApplicationService.createLoanApplication(loanApplication);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting application: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _termController.dispose();
    _purposeController.dispose();
    super.dispose();
  }
}