import 'package:hive/hive.dart';
import '../models/payment.dart';

class PaymentService {
  static Future<void> createPayment(Payment payment) async {
    final paymentsBox = Hive.box<Payment>('payments');
    await paymentsBox.put(payment.id, payment);
  }

  static Future<List<Payment>> getAllPayments() async {
    final paymentsBox = Hive.box<Payment>('payments');
    return paymentsBox.values.toList();
  }

  static Future<List<Payment>> getPaymentsByLoanId(String loanId) async {
    final paymentsBox = Hive.box<Payment>('payments');
    return paymentsBox.values.where((payment) => payment.loanId == loanId).toList();
  }

  static Future<Payment?> getPaymentById(String id) async {
    final paymentsBox = Hive.box<Payment>('payments');
    return paymentsBox.get(id);
  }

  static Future<void> updatePayment(Payment payment) async {
    final paymentsBox = Hive.box<Payment>('payments');
    await paymentsBox.put(payment.id, payment);
  }

  static Future<void> deletePayment(String id) async {
    final paymentsBox = Hive.box<Payment>('payments');
    await paymentsBox.delete(id);
  }
}