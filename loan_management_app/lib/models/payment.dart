import 'package:flutter/foundation.dart';

enum PaymentStatus { scheduled, paid, overdue }

class Payment {
  final String id;
  final String loanId;
  final double amount;
  final DateTime dueDate;
  final DateTime? paidDate;
  final PaymentStatus status;

  Payment({
    required this.id,
    required this.loanId,
    required this.amount,
    required this.dueDate,
    this.paidDate,
    required this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      loanId: json['loanId'],
      amount: json['amount'],
      dueDate: DateTime.parse(json['dueDate']),
      paidDate: json['paidDate'] != null ? DateTime.parse(json['paidDate']) : null,
      status: PaymentStatus.values.firstWhere((e) => describeEnum(e) == json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loanId': loanId,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'status': describeEnum(status),
    };
  }
}