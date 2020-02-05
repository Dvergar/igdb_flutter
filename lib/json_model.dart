import 'package:json_annotation/json_annotation.dart';

part 'json_model.g.dart';

////////////////// SEARCH

@JsonSerializable()
class SearchEntries {
  List<SearchEntry2> entries;

  SearchEntries(this.entries);

  factory SearchEntries.fromJson(Map<String, dynamic> json) =>
      _$SearchEntriesFromJson(json);

  Map<String, dynamic> toJson() => _$SearchEntriesToJson(this);
}

@JsonSerializable()
class SearchEntry2 {
  final String name;
  final int id;

  @JsonKey(defaultValue: [])
  List<Platform> platforms;

  SearchEntry2(this.name, this.id, this.platforms);

  String get platform {
    print("GETPLAFORM");
    var platformName = "N/A";
    var date = 9999999999999999;
    for (var platform in platforms) {
      for (var version in platform.versions) {
        print("dates ${version.platformVersionReleaseDates}");
        if(version.platformVersionReleaseDates == null) continue;
        var tmpDate = version?.platformVersionReleaseDates[0]?.date;
        print("date $tmpDate");
        if (tmpDate != null && tmpDate < date) {
          date = tmpDate;
          platformName = platform.abbreviation;
        }
      }
    }
    return platformName;
  }

  factory SearchEntry2.fromJson(Map<String, dynamic> json) =>
      _$SearchEntry2FromJson(json);

  Map<String, dynamic> toJson() => _$SearchEntry2ToJson(this);
}

@JsonSerializable()
class Platform {
  @JsonKey(defaultValue: "N/A")
  final String abbreviation;
  List<PlatformVersion> versions;

  Platform(this.abbreviation, this.versions);

  factory Platform.fromJson(Map<String, dynamic> json) =>
      _$PlatformFromJson(json);

  Map<String, dynamic> toJson() => _$PlatformToJson(this);
}

@JsonSerializable()
class PlatformVersion {
  @JsonKey(name: "platform_version_release_dates")
  List<PlatformVersionReleaseDate> platformVersionReleaseDates;

  PlatformVersion(this.platformVersionReleaseDates);

  factory PlatformVersion.fromJson(Map<String, dynamic> json) =>
      _$PlatformVersionFromJson(json);

  Map<String, dynamic> toJson() => _$PlatformVersionToJson(this);
}

@JsonSerializable()
class PlatformVersionReleaseDate {
  final int date;

  PlatformVersionReleaseDate(this.date);

  factory PlatformVersionReleaseDate.fromJson(Map<String, dynamic> json) =>
      _$PlatformVersionReleaseDateFromJson(json);

  Map<String, dynamic> toJson() => _$PlatformVersionReleaseDateToJson(this);
}

////////////////////////////////// GAME

@JsonSerializable()
class GameEntry {
  final double rating;

  @JsonKey(defaultValue: "No summary")
  final String summary;

  @JsonKey(defaultValue: [])
  List<Genre> genres;

  GameEntry(this.rating, this.genres, this.summary);

  factory GameEntry.fromJson(Map<String, dynamic> json) =>
      _$GameEntryFromJson(json);

  Map<String, dynamic> toJson() => _$GameEntryToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Genre {
  @JsonKey(defaultValue: "")
  final String name;

  Genre(this.name);

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);
}
