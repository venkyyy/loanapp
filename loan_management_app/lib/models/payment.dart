import 'package:hive/hive.dart';

part 'payment.g.dart';

@HiveType(typeId: 5)
enum PaymentStatus {
  @HiveField(0)
  scheduled,
  @HiveField(1)
  paid,
  @HiveField(2)
  overdue
}

@HiveType(typeId: 6)
class Payment extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String loanId;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late DateTime dueDate;

  @HiveField(4)
  DateTime? paidDate;

  @HiveField(5)
  late PaymentStatus status;

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
      status: PaymentStatus.values.firstWhere((e) => e.toString() == 'PaymentStatus.${json['status']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loanId': loanId,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }
}