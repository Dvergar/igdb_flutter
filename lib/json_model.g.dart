// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchEntries _$SearchEntriesFromJson(Map<String, dynamic> json) {
  return SearchEntries(
    (json['entries'] as List)
        ?.map((e) =>
            e == null ? null : SearchEntry2.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SearchEntriesToJson(SearchEntries instance) =>
    <String, dynamic>{
      'entries': instance.entries,
    };

SearchEntry2 _$SearchEntry2FromJson(Map<String, dynamic> json) {
  return SearchEntry2(
    json['name'] as String,
    json['id'] as int,
    (json['platforms'] as List)
            ?.map((e) =>
                e == null ? null : Platform.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$SearchEntry2ToJson(SearchEntry2 instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'platforms': instance.platforms,
    };

Platform _$PlatformFromJson(Map<String, dynamic> json) {
  return Platform(
    json['abbreviation'] as String ?? 'N/A',
    (json['versions'] as List)
        ?.map((e) => e == null
            ? null
            : PlatformVersion.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PlatformToJson(Platform instance) => <String, dynamic>{
      'abbreviation': instance.abbreviation,
      'versions': instance.versions,
    };

PlatformVersion _$PlatformVersionFromJson(Map<String, dynamic> json) {
  return PlatformVersion(
    (json['platform_version_release_dates'] as List)
        ?.map((e) => e == null
            ? null
            : PlatformVersionReleaseDate.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PlatformVersionToJson(PlatformVersion instance) =>
    <String, dynamic>{
      'platform_version_release_dates': instance.platformVersionReleaseDates,
    };

PlatformVersionReleaseDate _$PlatformVersionReleaseDateFromJson(
    Map<String, dynamic> json) {
  return PlatformVersionReleaseDate(
    json['date'] as int,
  );
}

Map<String, dynamic> _$PlatformVersionReleaseDateToJson(
        PlatformVersionReleaseDate instance) =>
    <String, dynamic>{
      'date': instance.date,
    };

GameEntry _$GameEntryFromJson(Map<String, dynamic> json) {
  return GameEntry(
    (json['rating'] as num)?.toDouble(),
    (json['genres'] as List)
            ?.map((e) =>
                e == null ? null : Genre.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    json['summary'] as String ?? 'No summary',
  );
}

Map<String, dynamic> _$GameEntryToJson(GameEntry instance) => <String, dynamic>{
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
