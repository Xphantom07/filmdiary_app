// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieModelAdapter extends TypeAdapter<MovieModel> {
  @override
  final int typeId = 0;

  @override
  MovieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieModel(
      id: fields[0] as String,
      title: fields[1] as String,
      director: fields[2] as String,
      releaseYear: fields[3] as int,
      genre: fields[4] as String,
      contentType: fields[5] as String,
      rating: fields[6] as double,
      review: fields[7] as String,
      dateAdded: fields[8] as DateTime,
      posterUrl: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.director)
      ..writeByte(3)
      ..write(obj.releaseYear)
      ..writeByte(4)
      ..write(obj.genre)
      ..writeByte(5)
      ..write(obj.contentType)
      ..writeByte(6)
      ..write(obj.rating)
      ..writeByte(7)
      ..write(obj.review)
      ..writeByte(8)
      ..write(obj.dateAdded)
      ..writeByte(9)
      ..write(obj.posterUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
