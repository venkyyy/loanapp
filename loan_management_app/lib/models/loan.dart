import 'package:flutter/foundation.dart';

enum LoanStatus { pending, approved, rejected, disbursed, closed }

class Loan {
  final String id;
  final String userId;
  final double amount;
  final double interestRate;
  final int termMonths;
  final DateTime applicationDate;
  final LoanStatus status;

  Loan({
    required this.id,
    required this.userId,
    required this.amount,
    required this.interestRate,
    required this.termMonths,
    required this.applicationDate,
    required this.status,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      userId: json['userId'],
      amount: json['amount'],
      interestRate: json['interestRate'],
      termMonths: json['termMonths'],
      applicationDate: DateTime.parse(json['applicationDate']),
      status: LoanStatus.values.firstWhere((e) => describeEnum(e) == json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'interestRate': interestRate,
      'termMonths': termMonths,
      'applicationDate': applicationDate.toIso8601String(),
      'status': describeEnum(status),
    };
  }
}