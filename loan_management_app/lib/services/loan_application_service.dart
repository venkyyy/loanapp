import 'package:hive/hive.dart';
import '../models/loan_application.dart';

class LoanApplicationService {
  static Future<void> createLoanApplication(LoanApplication application) async {
    final applicationsBox = Hive.box<LoanApplication>('loanApplications');
    await applicationsBox.put(application.id, application);
  }

  static Future<List<LoanApplication>> getAllLoanApplications() async {
    final applicationsBox = Hive.box<LoanApplication>('loanApplications');
    return applicationsBox.values.toList();
  }

  static Future<List<LoanApplication>> getLoanApplicationsByUserId(String userId) async {
    final applicationsBox = Hive.box<LoanApplication>('loanApplications');
    return applicationsBox.values.where((application) => application.userId == userId).toList();
  }

  static Future<LoanApplication?> getLoanApplicationById(String id) async {
    final applicationsBox = Hive.box<LoanApplication>('loanApplications');
    return applicationsBox.get(id);
  }

  static Future<void> updateLoanApplication(LoanApplication application) async {
    final applicationsBox = Hive.box<LoanApplication>('loanApplications');
    await applicationsBox.put(application.id, application);
  }

  static Future<void> deleteLoanApplication(String id) async {
    final applicationsBox = Hive.box<LoanApplication>('loanApplications');
    await applicationsBox.delete(id);
  }
}