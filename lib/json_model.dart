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
  final Cover cover;
  List<Screenshot> screenshots;

  @JsonKey(defaultValue: [])
  List<Platform> platforms;

  @JsonKey(defaultValue: [], name: 'release_dates')
  List<ReleaseDate> releaseDates;

  SearchEntry2(
      this.name, this.id, this.platforms, this.screenshots, this.cover);

  String get platform {
    print("GETPLAFORM");
    var platformName = "N/A";
    var date = 9999999999999999;
    for (var platform in platforms) {
      for (var version in platform.versions) {
        print("dates ${version.platformVersionReleaseDates}");
        if (version.platformVersionReleaseDates == null) continue;
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

  String get releaseDate {
    if (releaseDates.length == 0) return "N/A";
    var date = 9999999999999999;

    // TODO : Use reduce ?
    for (var tmpDate in releaseDates) {
      if (tmpDate.date < date) date = tmpDate.date;
    }

    return DateTime.fromMillisecondsSinceEpoch(date * 1000).year.toString();
  }

  String get banner {
    // SCREENSHOT
    if (screenshots != null)
      return 'https://images.igdb.com/igdb/image/upload/t_screenshot_med/${screenshots[0].imageId}.jpg';

    // OR COVER
    if (cover != null)
      return 'https://images.igdb.com/igdb/image/upload/t_screenshot_med/${cover.imageId}.jpg';

    // OR PLACEHOLDER
    return 'https://i.picsum.photos/id/15/400/200.jpg?blur=10';
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

@JsonSerializable()
class ReleaseDate {
  final int date;

  ReleaseDate(this.date);

  factory ReleaseDate.fromJson(Map<String, dynamic> json) =>
      _$ReleaseDateFromJson(json);

  Map<String, dynamic> toJson() => _$ReleaseDateToJson(this);
}

@JsonSerializable()
class Cover {
  @JsonKey(name: "image_id")
  final String imageId;

  Cover(this.imageId);

  factory Cover.fromJson(Map<String, dynamic> json) => _$CoverFromJson(json);

  Map<String, dynamic> toJson() => _$CoverToJson(this);
}

@JsonSerializable()
class Screenshot {
  @JsonKey(name: "image_id")
  final String imageId;

  Screenshot(this.imageId);

  factory Screenshot.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotFromJson(json);

  Map<String, dynamic> toJson() => _$ScreenshotToJson(this);
}

////////////////////////////////// GAME

@JsonSerializable()
class GameEntry {
  @JsonKey(defaultValue: 0)
  final double rating;

  @JsonKey(defaultValue: "No summary")
  final String summary;

  @JsonKey(defaultValue: [])
  List<Genre> genres;

  @JsonKey(defaultValue: [], name: "involved_companies")
  List<InvolvedCompany> involvedCompanies;

  GameEntry(this.rating, this.genres, this.summary, this.involvedCompanies);

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

@JsonSerializable()
class InvolvedCompany {
  final Company company;

  InvolvedCompany(this.company);

  factory InvolvedCompany.fromJson(Map<String, dynamic> json) =>
      _$InvolvedCompanyFromJson(json);

  Map<String, dynamic> toJson() => _$InvolvedCompanyToJson(this);
}

@JsonSerializable()
class Company {
  final String name;

  Company(this.name);

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
