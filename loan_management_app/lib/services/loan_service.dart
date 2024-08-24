import 'package:hive/hive.dart';
import '../models/loan.dart';

class LoanService {
  static Future<void> createLoan(Loan loan) async {
    final loansBox = Hive.box<Loan>('loans');
    await loansBox.put(loan.id, loan);
  }

  static Future<List<Loan>> getAllLoans() async {
    final loansBox = Hive.box<Loan>('loans');
    return loansBox.values.toList();
  }

  static Future<List<Loan>> getLoansByUserId(String userId) async {
    final loansBox = Hive.box<Loan>('loans');
    return loansBox.values.where((loan) => loan.userId == userId).toList();
  }

  static Future<Loan?> getLoanById(String id) async {
    final loansBox = Hive.box<Loan>('loans');
    return loansBox.get(id);
  }

  static Future<void> updateLoan(Loan loan) async {
    final loansBox = Hive.box<Loan>('loans');
    await loansBox.put(loan.id, loan);
  }

  static Future<void> deleteLoan(String id) async {
    final loansBox = Hive.box<Loan>('loans');
    await loansBox.delete(id);
  }
}