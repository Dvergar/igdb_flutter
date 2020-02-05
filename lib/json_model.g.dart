// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameEntry2 _$GameEntry2FromJson(Map<String, dynamic> json) {
  return GameEntry2(
    (json['rating'] as num)?.toDouble(),
    (json['genres'] as List)
            ?.map((e) =>
                e == null ? null : Genre.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    json['summary'] as String ?? 'No summary',
  );
}

Map<String, dynamic> _$GameEntry2ToJson(GameEntry2 instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'summary': instance.summary,
      'genres': instance.genres,
    };

Genre _$GenreFromJson(Map<String, dynamic> json) {
  return Genre(
    json['name'] as String ?? '',
  );
}

Map<String, dynamic> _$GenreToJson(Genre instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  return val;
}
