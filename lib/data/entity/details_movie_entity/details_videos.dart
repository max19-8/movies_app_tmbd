import 'package:json_annotation/json_annotation.dart';

part 'details_videos.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DetailsVideos {
  List<DetailsVideosResults> results;
  DetailsVideos({required this.results});

  factory DetailsVideos.fromJson(Map<String,dynamic> json) => _$DetailsVideosFromJson(json);

  Map<String,dynamic> toJson() => _$DetailsVideosToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DetailsVideosResults {
  @JsonKey(name:'iso_639_1')
  final  String iso6391;
  @JsonKey(name:'iso_3166_1')
  final String iso31661;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String publishedAt;
  final String id;

  DetailsVideosResults(
      { required this.iso6391,
        required this.iso31661,
        required  this.name,
        required  this.key,
        required  this.site,
        required  this.size,
        required  this.type,
        required  this.official,
        required  this.publishedAt,
        required  this.id});

  factory DetailsVideosResults.fromJson(Map<String,dynamic> json) => _$DetailsVideosResultsFromJson(json);

  Map<String,dynamic> toJson() => _$DetailsVideosResultsToJson(this);
}