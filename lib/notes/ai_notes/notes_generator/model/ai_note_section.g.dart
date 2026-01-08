// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_note_section.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AiNoteSectionAdapter extends TypeAdapter<AiNoteSection> {
  @override
  final int typeId = 2;

  @override
  AiNoteSection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AiNoteSection(
      id: fields[0] as String,
      noteId: fields[1] as String,
      topic: fields[2] as String,
      content: fields[3] as String,
      createdAt: fields[4] as DateTime,
      isSynced: fields[5] as bool,
      isDeleted: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AiNoteSection obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.noteId)
      ..writeByte(2)
      ..write(obj.topic)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.createdAt)
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
      other is AiNoteSectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
