import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:loan_management_app/models/payment.dart';
import 'package:loan_management_app/services/payment_service.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveBox extends Mock implements Box<Payment> {}

void main() {
  late MockHiveBox mockPaymentsBox;

  setUp(() {
    mockPaymentsBox = MockHiveBox();
    Hive.registerAdapter(PaymentAdapter());
    Hive.registerAdapter(PaymentStatusAdapter());
  });

  group('PaymentService', () {
    test('createPayment should add a new payment', () async {
      final payment = Payment(
        id: '1',
        loanId: 'loan1',
        amount: 1000,
        dueDate: DateTime.now().add(const Duration(days: 30)),
        status: PaymentStatus.scheduled,
      );
      when(() => mockPaymentsBox.put(any(), any())).thenAnswer((_) async {});

      await PaymentService.createPayment(payment);

      verify(() => mockPaymentsBox.put(payment.id, payment)).called(1);
    });

    test('getAllPayments should return all payments', () async {
      final payments = [
        Payment(
          id: '1',
          loanId: 'loan1',
          amount: 1000,
          dueDate: DateTime.now().add(const Duration(days: 30)),
          status: PaymentStatus.scheduled,
        ),
        Payment(
          id: '2',
          loanId: 'loan2',
          amount: 500,
          dueDate: DateTime.now().add(const Duration(days: 60)),
          status: PaymentStatus.paid,
        ),
      ];
      when(() => mockPaymentsBox.values).thenReturn(payments);

      final result = await PaymentService.getAllPayments();

      expect(result, payments);
    });

    test('getPaymentsByLoanId should return payments for a specific loan', () async {
      final payments = [
        Payment(
          id: '1',
          loanId: 'loan1',
          amount: 1000,
          dueDate: DateTime.now().add(const Duration(days: 30)),
          status: PaymentStatus.scheduled,
        ),
        Payment(
          id: '2',
          loanId: 'loan1',
          amount: 1000,
          dueDate: DateTime.now().add(const Duration(days: 60)),
          status: PaymentStatus.scheduled,
        ),
      ];
      when(() => mockPaymentsBox.values).thenReturn(payments);

      final result = await PaymentService.getPaymentsByLoanId('loan1');

      expect(result, payments);
    });

    test('updatePayment should update an existing payment', () async {
      final payment = Payment(
        id: '1',
        loanId: 'loan1',
        amount: 1000,
        dueDate: DateTime.now().add(const Duration(days: 30)),
        status: PaymentStatus.paid,
        paidDate: DateTime.now(),
      );
      when(() => mockPaymentsBox.put(any(), any())).thenAnswer((_) async {});

      await PaymentService.updatePayment(payment);

      verify(() => mockPaymentsBox.put(payment.id, payment)).called(1);
    });

    test('deletePayment should remove a payment', () async {
      when(() => mockPaymentsBox.delete(any())).thenAnswer((_) async {});

      await PaymentService.deletePayment('1');

      verify(() => mockPaymentsBox.delete('1')).called(1);
    });
  });
}