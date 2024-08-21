import 'package:flutter/material.dart';
import '../models/loan_application.dart';

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
                decoration: const InputDecoration(labelText: 'Loan Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a loan amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _termController,
                decoration: const InputDecoration(labelText: 'Loan Term (months)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a loan term';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(labelText: 'Loan Purpose'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the purpose of the loan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement document upload functionality
                },
                child: const Text('Upload Documents'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitApplication,
                child: const Text('Submit Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitApplication() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement application submission logic
      // For now, we'll just print the values
      print('Amount: ${_amountController.text}');
      print('Term: ${_termController.text}');
      print('Purpose: ${_purposeController.text}');

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application submitted successfully')),
      );

      // Navigate back to the home screen
      Navigator.pop(context);
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