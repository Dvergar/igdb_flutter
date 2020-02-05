import 'package:json_annotation/json_annotation.dart';

part 'json_model.g.dart';

@JsonSerializable()
class GameEntry2 {
  final double rating;

  @JsonKey(defaultValue: "No summary")
  final String summary;

  @JsonKey(defaultValue: [])
  List<Genre> genres;

  GameEntry2(this.rating, this.genres, this.summary);

  factory GameEntry2.fromJson(Map<String, dynamic> json) =>
      _$GameEntry2FromJson(json);

  Map<String, dynamic> toJson() => _$GameEntry2ToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Genre {
  @JsonKey(defaultValue: "")
  final String name;

  Genre(this.name);

  factory Genre.fromJson(Map<String, dynamic> json) =>
      _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);
}
