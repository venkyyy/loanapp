// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_application.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoanApplicationAdapter extends TypeAdapter<LoanApplication> {
  @override
  final int typeId = 4;

  @override
  LoanApplication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoanApplication(
      id: fields[0] as String,
      userId: fields[1] as String,
      requestedAmount: fields[2] as double,
      requestedTermMonths: fields[3] as int,
      applicationDate: fields[4] as DateTime,
      status: fields[5] as ApplicationStatus,
      documents: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, LoanApplication obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.requestedAmount)
      ..writeByte(3)
      ..write(obj.requestedTermMonths)
      ..writeByte(4)
      ..write(obj.applicationDate)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.documents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanApplicationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ApplicationStatusAdapter extends TypeAdapter<ApplicationStatus> {
  @override
  final int typeId = 3;

  @override
  ApplicationStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ApplicationStatus.pending;
      case 1:
        return ApplicationStatus.underReview;
      case 2:
        return ApplicationStatus.approved;
      case 3:
        return ApplicationStatus.rejected;
      default:
        return ApplicationStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, ApplicationStatus obj) {
    switch (obj) {
      case ApplicationStatus.pending:
        writer.writeByte(0);
        break;
      case ApplicationStatus.underReview:
        writer.writeByte(1);
        break;
      case ApplicationStatus.approved:
        writer.writeByte(2);
        break;
      case ApplicationStatus.rejected:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
