import 'package:json_annotation/json_annotation.dart';
import 'package:movies_app_tmbd/data/entity/movie_list/movie_date_parser.dart';
part 'tv_show.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TvShow {
  final bool adult;
  final String? backdropPath;
  final int id;
  final String name;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final String? posterPath;
  final String mediaType;
  final List<int> genreIds;
  final double popularity;
  @JsonKey(fromJson: parseDateFromString)
  final DateTime? firstAirDate;
  final double voteAverage;
  final int voteCount;
  final List<String> originCountry;

  TvShow({ required this.adult,
    required this.backdropPath,
    required this.id,
    required this.name,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.mediaType,
    required this.genreIds,
    required this.popularity,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    required this.originCountry
  });
  factory TvShow.fromJson(Map<String,dynamic> json) => _$TvShowFromJson(json);

  Map<String,dynamic> toJson() => _$TvShowToJson(this);
}
