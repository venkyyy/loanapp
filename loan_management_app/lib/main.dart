import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'screens/login_screen.dart';
import 'models/user.dart';
import 'models/loan.dart';
import 'models/loan_application.dart';
import 'models/payment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(LoanStatusAdapter());
  Hive.registerAdapter(LoanAdapter());
  Hive.registerAdapter(ApplicationStatusAdapter());
  Hive.registerAdapter(LoanApplicationAdapter());
  Hive.registerAdapter(PaymentStatusAdapter());
  Hive.registerAdapter(PaymentAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<Loan>('loans');
  await Hive.openBox<LoanApplication>('loanApplications');
  await Hive.openBox<Payment>('payments');

  runApp(const LoanManagementApp());
}

class LoanManagementApp extends StatelessWidget {
  const LoanManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
    );
  }
}
