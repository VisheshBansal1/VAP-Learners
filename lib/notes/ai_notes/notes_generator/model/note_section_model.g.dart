// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_section_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteSectionAdapter extends TypeAdapter<NoteSection> {
  @override
  final int typeId = 1;

  @override
  NoteSection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteSection(
      id: fields[0] as String,
      noteId: fields[1] as String,
      topic: fields[2] as String,
      content: fields[3] as String,
      createdAt: fields[4] as DateTime,
      isSynced: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NoteSection obj) {
    writer
      ..writeByte(6)
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
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteSectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
