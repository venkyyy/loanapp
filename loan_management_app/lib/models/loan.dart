import 'package:hive/hive.dart';

part 'loan.g.dart';

@HiveType(typeId: 1)
enum LoanStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  approved,
  @HiveField(2)
  rejected,
  @HiveField(3)
  disbursed,
  @HiveField(4)
  closed
}

@HiveType(typeId: 2)
class Loan extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String userId;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late double interestRate;

  @HiveField(4)
  late int termMonths;

  @HiveField(5)
  late DateTime applicationDate;

  @HiveField(6)
  late LoanStatus status;

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
      status: LoanStatus.values.firstWhere((e) => e.toString() == 'LoanStatus.${json['status']}'),
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
      'status': status.toString().split('.').last,
    };
  }
}