import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:loan_management_app/models/loan.dart';
import 'package:loan_management_app/services/loan_service.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveBox extends Mock implements Box<Loan> {}

void main() {
  late MockHiveBox mockLoansBox;

  setUp(() {
    mockLoansBox = MockHiveBox();
    Hive.registerAdapter(LoanAdapter());
    Hive.registerAdapter(LoanStatusAdapter());
  });

  group('LoanService', () {
    test('createLoan should add a new loan', () async {
      final loan = Loan(
        id: '1',
        userId: 'user1',
        amount: 10000,
        interestRate: 5.5,
        termMonths: 12,
        applicationDate: DateTime.now(),
        status: LoanStatus.pending,
      );
      when(() => mockLoansBox.put(any(), any())).thenAnswer((_) async {});

      await LoanService.createLoan(loan);

      verify(() => mockLoansBox.put(loan.id, loan)).called(1);
    });

    test('getAllLoans should return all loans', () async {
      final loans = [
        Loan(
          id: '1',
          userId: 'user1',
          amount: 10000,
          interestRate: 5.5,
          termMonths: 12,
          applicationDate: DateTime.now(),
          status: LoanStatus.approved,
        ),
        Loan(
          id: '2',
          userId: 'user2',
          amount: 5000,
          interestRate: 6.0,
          termMonths: 6,
          applicationDate: DateTime.now(),
          status: LoanStatus.pending,
        ),
      ];
      when(() => mockLoansBox.values).thenReturn(loans);

      final result = await LoanService.getAllLoans();

      expect(result, loans);
    });

    test('getLoansByUserId should return loans for a specific user', () async {
      final loans = [
        Loan(
          id: '1',
          userId: 'user1',
          amount: 10000,
          interestRate: 5.5,
          termMonths: 12,
          applicationDate: DateTime.now(),
          status: LoanStatus.approved,
        ),
        Loan(
          id: '2',
          userId: 'user1',
          amount: 5000,
          interestRate: 6.0,
          termMonths: 6,
          applicationDate: DateTime.now(),
          status: LoanStatus.pending,
        ),
      ];
      when(() => mockLoansBox.values).thenReturn(loans);

      final result = await LoanService.getLoansByUserId('user1');

      expect(result, loans);
    });

    test('updateLoan should update an existing loan', () async {
      final loan = Loan(
        id: '1',
        userId: 'user1',
        amount: 10000,
        interestRate: 5.5,
        termMonths: 12,
        applicationDate: DateTime.now(),
        status: LoanStatus.approved,
      );
      when(() => mockLoansBox.put(any(), any())).thenAnswer((_) async {});

      await LoanService.updateLoan(loan);

      verify(() => mockLoansBox.put(loan.id, loan)).called(1);
    });

    test('deleteLoan should remove a loan', () async {
      when(() => mockLoansBox.delete(any())).thenAnswer((_) async {});

      await LoanService.deleteLoan('1');

      verify(() => mockLoansBox.delete('1')).called(1);
    });
  });
}