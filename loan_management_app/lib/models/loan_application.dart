import 'package:flutter/foundation.dart';

enum ApplicationStatus { pending, underReview, approved, rejected }

class LoanApplication {
  final String id;
  final String userId;
  final double requestedAmount;
  final int requestedTermMonths;
  final DateTime applicationDate;
  final ApplicationStatus status;
  final List<String> documents;

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
      status: ApplicationStatus.values.firstWhere((e) => describeEnum(e) == json['status']),
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
      'status': describeEnum(status),
      'documents': documents,
    };
  }
}