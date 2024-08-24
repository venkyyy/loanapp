// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoanAdapter extends TypeAdapter<Loan> {
  @override
  final int typeId = 2;

  @override
  Loan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Loan(
      id: fields[0] as String,
      userId: fields[1] as String,
      amount: fields[2] as double,
      interestRate: fields[3] as double,
      termMonths: fields[4] as int,
      applicationDate: fields[5] as DateTime,
      status: fields[6] as LoanStatus,
    );
  }

  @override
  void write(BinaryWriter writer, Loan obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.interestRate)
      ..writeByte(4)
      ..write(obj.termMonths)
      ..writeByte(5)
      ..write(obj.applicationDate)
      ..writeByte(6)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LoanStatusAdapter extends TypeAdapter<LoanStatus> {
  @override
  final int typeId = 1;

  @override
  LoanStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LoanStatus.pending;
      case 1:
        return LoanStatus.approved;
      case 2:
        return LoanStatus.rejected;
      case 3:
        return LoanStatus.disbursed;
      case 4:
        return LoanStatus.closed;
      default:
        return LoanStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, LoanStatus obj) {
    switch (obj) {
      case LoanStatus.pending:
        writer.writeByte(0);
        break;
      case LoanStatus.approved:
        writer.writeByte(1);
        break;
      case LoanStatus.rejected:
        writer.writeByte(2);
        break;
      case LoanStatus.disbursed:
        writer.writeByte(3);
        break;
      case LoanStatus.closed:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
