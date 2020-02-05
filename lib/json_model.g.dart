// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchEntries _$SearchEntriesFromJson(Map<String, dynamic> json) {
  return SearchEntries(
    (json['entries'] as List)
        ?.map((e) =>
            e == null ? null : SearchEntry.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SearchEntriesToJson(SearchEntries instance) =>
    <String, dynamic>{
      'entries': instance.entries,
    };

SearchEntry _$SearchEntryFromJson(Map<String, dynamic> json) {
  return SearchEntry(
    json['name'] as String,
    json['id'] as int,
    (json['platforms'] as List)
            ?.map((e) =>
                e == null ? null : Platform.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    (json['screenshots'] as List)
        ?.map((e) =>
            e == null ? null : Screenshot.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['cover'] == null
        ? null
        : Cover.fromJson(json['cover'] as Map<String, dynamic>),
  )..releaseDates = (json['release_dates'] as List)
          ?.map((e) => e == null
              ? null
              : ReleaseDate.fromJson(e as Map<String, dynamic>))
          ?.toList() ??
      [];
}

Map<String, dynamic> _$SearchEntryToJson(SearchEntry instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'cover': instance.cover,
      'screenshots': instance.screenshots,
      'platforms': instance.platforms,
      'release_dates': instance.releaseDates,
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

ReleaseDate _$ReleaseDateFromJson(Map<String, dynamic> json) {
  return ReleaseDate(
    json['date'] as int,
  );
}

Map<String, dynamic> _$ReleaseDateToJson(ReleaseDate instance) =>
    <String, dynamic>{
      'date': instance.date,
    };

Cover _$CoverFromJson(Map<String, dynamic> json) {
  return Cover(
    json['image_id'] as String,
  );
}

Map<String, dynamic> _$CoverToJson(Cover instance) => <String, dynamic>{
      'image_id': instance.imageId,
    };

Screenshot _$ScreenshotFromJson(Map<String, dynamic> json) {
  return Screenshot(
    json['image_id'] as String,
  );
}

Map<String, dynamic> _$ScreenshotToJson(Screenshot instance) =>
    <String, dynamic>{
      'image_id': instance.imageId,
    };

GameEntry _$GameEntryFromJson(Map<String, dynamic> json) {
  return GameEntry(
    (json['rating'] as num)?.toDouble() ?? 0,
    (json['genres'] as List)
            ?.map((e) =>
                e == null ? null : Genre.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    json['summary'] as String ?? 'No summary',
    (json['involved_companies'] as List)
            ?.map((e) => e == null
                ? null
                : InvolvedCompany.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$GameEntryToJson(GameEntry instance) => <String, dynamic>{
      'rating': instance.rating,
      'summary': instance.summary,
      'genres': instance.genres,
      'involved_companies': instance.involvedCompanies,
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

InvolvedCompany _$InvolvedCompanyFromJson(Map<String, dynamic> json) {
  return InvolvedCompany(
    json['company'] == null
        ? null
        : Company.fromJson(json['company'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$InvolvedCompanyToJson(InvolvedCompany instance) =>
    <String, dynamic>{
      'company': instance.company,
    };

Company _$CompanyFromJson(Map<String, dynamic> json) {
  return Company(
    json['name'] as String,
  );
}

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'name': instance.name,
    };
