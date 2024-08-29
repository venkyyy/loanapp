import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:loan_management_app/models/loan_application.dart';
import 'package:loan_management_app/services/loan_application_service.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveBox extends Mock implements Box<LoanApplication> {}

void main() {
  late MockHiveBox mockApplicationsBox;

  setUp(() {
    mockApplicationsBox = MockHiveBox();
    Hive.registerAdapter(LoanApplicationAdapter());
    Hive.registerAdapter(ApplicationStatusAdapter());
  });

  group('LoanApplicationService', () {
    test('createLoanApplication should add a new loan application', () async {
      final application = LoanApplication(
        id: '1',
        userId: 'user1',
        requestedAmount: 10000,
        requestedTermMonths: 12,
        applicationDate: DateTime.now(),
        status: ApplicationStatus.pending,
        documents: [],
      );
      when(() => mockApplicationsBox.put(any(), any())).thenAnswer((_) async {});

      await LoanApplicationService.createLoanApplication(application);

      verify(() => mockApplicationsBox.put(application.id, application)).called(1);
    });

    test('getAllLoanApplications should return all loan applications', () async {
      final applications = [
        LoanApplication(
          id: '1',
          userId: 'user1',
          requestedAmount: 10000,
          requestedTermMonths: 12,
          applicationDate: DateTime.now(),
          status: ApplicationStatus.pending,
          documents: [],
        ),
        LoanApplication(
          id: '2',
          userId: 'user2',
          requestedAmount: 5000,
          requestedTermMonths: 6,
          applicationDate: DateTime.now(),
          status: ApplicationStatus.approved,
          documents: [],
        ),
      ];
      when(() => mockApplicationsBox.values).thenReturn(applications);

      final result = await LoanApplicationService.getAllLoanApplications();

      expect(result, applications);
    });

    test('getLoanApplicationsByUserId should return applications for a specific user', () async {
      final applications = [
        LoanApplication(
          id: '1',
          userId: 'user1',
          requestedAmount: 10000,
          requestedTermMonths: 12,
          applicationDate: DateTime.now(),
          status: ApplicationStatus.pending,
          documents: [],
        ),
        LoanApplication(
          id: '2',
          userId: 'user1',
          requestedAmount: 5000,
          requestedTermMonths: 6,
          applicationDate: DateTime.now(),
          status: ApplicationStatus.approved,
          documents: [],
        ),
      ];
      when(() => mockApplicationsBox.values).thenReturn(applications);

      final result = await LoanApplicationService.getLoanApplicationsByUserId('user1');

      expect(result, applications);
    });

    test('updateLoanApplication should update an existing loan application', () async {
      final application = LoanApplication(
        id: '1',
        userId: 'user1',
        requestedAmount: 10000,
        requestedTermMonths: 12,
        applicationDate: DateTime.now(),
        status: ApplicationStatus.approved,
        documents: [],
      );
      when(() => mockApplicationsBox.put(any(), any())).thenAnswer((_) async {});

      await LoanApplicationService.updateLoanApplication(application);

      verify(() => mockApplicationsBox.put(application.id, application)).called(1);
    });

    test('deleteLoanApplication should remove a loan application', () async {
      when(() => mockApplicationsBox.delete(any())).thenAnswer((_) async {});

      await LoanApplicationService.deleteLoanApplication('1');

      verify(() => mockApplicationsBox.delete('1')).called(1);
    });
  });
}