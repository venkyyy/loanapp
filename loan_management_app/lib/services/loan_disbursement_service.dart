import '../models/loan.dart';
import '../models/payment.dart';
import 'loan_service.dart';
import 'payment_service.dart';

class LoanDisbursementService {
  static Future<void> disburseLoan(Loan loan) async {
    // Update loan status to disbursed
    loan.status = LoanStatus.disbursed;
    await LoanService.updateLoan(loan);

    // Generate repayment schedule
    final repaymentSchedule = _generateRepaymentSchedule(loan);

    // Create payment records
    for (var payment in repaymentSchedule) {
      await PaymentService.createPayment(payment);
    }
  }

  static List<Payment> _generateRepaymentSchedule(Loan loan) {
    final totalAmount = loan.amount * (1 + loan.interestRate / 100);
    final monthlyPayment = totalAmount / loan.termMonths;
    final payments = <Payment>[];

    for (int i = 0; i < loan.termMonths; i++) {
      payments.add(Payment(
        id: '${loan.id}_${i + 1}',
        loanId: loan.id,
        amount: monthlyPayment,
        dueDate: loan.applicationDate.add(Duration(days: 30 * (i + 1))),
        status: PaymentStatus.scheduled,
      ));
    }

    return payments;
  }

  static Future<void> simulateBankTransfer(Loan loan) async {
    // In a real-world scenario, this would integrate with a banking API
    // For now, we'll just simulate a delay
    await Future.delayed(const Duration(seconds: 2));

    // Update loan status to indicate successful transfer
    loan.disbursementDate = DateTime.now();
    await LoanService.updateLoan(loan);
  }
}