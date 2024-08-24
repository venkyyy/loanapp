import 'package:hive/hive.dart';

part 'loan_application.g.dart';

@HiveType(typeId: 3)
enum ApplicationStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  underReview,
  @HiveField(2)
  approved,
  @HiveField(3)
  rejected
}

@HiveType(typeId: 4)
class LoanApplication extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String userId;

  @HiveField(2)
  late double requestedAmount;

  @HiveField(3)
  late int requestedTermMonths;

  @HiveField(4)
  late DateTime applicationDate;

  @HiveField(5)
  late ApplicationStatus status;

  @HiveField(6)
  late List<String> documents;

  LoanApplication({
    required this.id,
    required this.userId,
    required this.requestedAmount,
    required this.requestedTermMonths,
    required this.applicationDate,
    required this.status,
    required this.documents,
  });

  factory LoanApplication.fromJson(Map<String, dynamic> json) {
    return LoanApplication(
      id: json['id'],
      userId: json['userId'],
      requestedAmount: json['requestedAmount'],
      requestedTermMonths: json['requestedTermMonths'],
      applicationDate: DateTime.parse(json['applicationDate']),
      status: ApplicationStatus.values.firstWhere((e) => e.toString() == 'ApplicationStatus.${json['status']}'),
      documents: List<String>.from(json['documents']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'requestedAmount': requestedAmount,
      'requestedTermMonths': requestedTermMonths,
      'applicationDate': applicationDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'documents': documents,
    };
  }
}