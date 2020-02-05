import 'package:json_annotation/json_annotation.dart';

part 'json_model.g.dart';

@JsonSerializable()
class GameEntry2 {
  final double rating;

  GameEntry2(this.rating);

  factory GameEntry2.fromJson(Map<String, dynamic> json) =>
      _$GameEntry2FromJson(json);

  Map<String, dynamic> toJson() => _$GameEntry2ToJson(this);
}
