// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AiNoteAdapter extends TypeAdapter<AiNote> {
  @override
  final int typeId = 1;

  @override
  AiNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AiNote(
      id: fields[0] as String,
      userId: fields[1] as String,
      title: fields[2] as String,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      isSynced: fields[5] as bool,
      isDeleted: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AiNote obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.isSynced)
      ..writeByte(6)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
