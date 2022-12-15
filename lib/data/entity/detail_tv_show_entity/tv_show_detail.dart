import 'package:json_annotation/json_annotation.dart';
import 'package:movies_app_tmbd/data/entity/details_movie_entity/details_videos.dart';
import 'package:movies_app_tmbd/data/entity/movie_list/movie_date_parser.dart';

import 'tv_show_detail_credits.dart';

part 'tv_show_detail.g.dart';
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DetailTvShow {
 final bool? adult;
 final List<CreatedBy>? createdBy;
 final String? backdropPath;
 @JsonKey(fromJson: parseDateFromString)
 final  DateTime? firstAirDate;
 final List<Genre> genres;
 final String? homepage;
 final int id;
 final bool? inProduction;
 final List<String>? languages;
 final String? lastAirDate;
 final String? name;
 final List<ProductionCompanies>? productionCompanies;
final List<ProductionCountries>? productionCountries;
 final List<Networks>? networks;
 final int? numberOfEpisodes;
 final int? numberOfSeasons;
 final List<String>? originCountry;
 final String? originalLanguage;
 final  String? originalName;
 final  String overview;
 final double? popularity;
 final String? posterPath;
 final  List<Seasons>? seasons;
 final List<SpokenLanguages> spokenLanguages;
 final String? status;
 final String? tagline;
 final String? type;
 final  double voteAverage;
 final  int? voteCount;
 final TvShowDetailsCredits credits;
 final DetailsVideos? videos;

  DetailTvShow(
      { required this.adult,
      this.createdBy,
        this.backdropPath,
       required this.firstAirDate,
        required this.genres,
        required  this.homepage,
        required  this.id,
        this.inProduction,
        this.languages,
        this.lastAirDate,
       this.productionCompanies,
       this.productionCountries,
        required  this.name,
       this.networks,
        this.numberOfEpisodes,
        this.numberOfSeasons,
        this.originCountry,
        this.originalLanguage,
        this.originalName,
        required this.overview,
        this.popularity,
        this.posterPath,
        this.seasons,
        required this.spokenLanguages,
        this.status,
        this.tagline,
        this.type,
        required this.voteAverage,
        required this.voteCount,
        required this.credits,
        this.videos,
      });

 factory DetailTvShow.fromJson(Map<String, dynamic> json) =>
     _$DetailTvShowFromJson(json);

 Map<String, dynamic> toJson() => _$DetailTvShowToJson(this);
}
@JsonSerializable(fieldRename: FieldRename.snake)
class CreatedBy {
  int? id;
  String? creditId;
  String? name;
  int? gender;
  CreatedBy({this.id, this.creditId, this.name, this.gender});

  factory CreatedBy.fromJson(Map<String, dynamic> json) =>
      _$CreatedByFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedByToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Genre {
  final int id;
  final String name;

  Genre({ required this.id,required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) =>
      _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);

}
@JsonSerializable(fieldRename: FieldRename.snake)
class Networks {
  final int? id;
  final  String? name;
  final String? logoPath;
  final  String? originCountry;
  Networks({this.id, this.name, this.logoPath, this.originCountry});

  factory Networks.fromJson(Map<String, dynamic> json) =>
      _$NetworksFromJson(json);

  Map<String, dynamic> toJson() => _$NetworksToJson(this);

}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductionCompanies {
  final int id;
  final String? logoPath;
  final String name;
  @JsonKey(name: 'origin_country')
  final String originCountry;

  ProductionCompanies(
      {required this.id,
        required this.logoPath,
        required this.name,
        required this.originCountry});

  factory ProductionCompanies.fromJson(Map<String, dynamic> json) =>
      _$ProductionCompaniesFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCompaniesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductionCountries {
  @JsonKey(name: 'iso_3166_1')
  final String iso31661;
  final String name;

  ProductionCountries({required this.iso31661, required this.name});

  factory ProductionCountries.fromJson(Map<String, dynamic> json) =>
      _$ProductionCountriesFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCountriesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Seasons {
  final String? airDate;
  final int? episodeCount;
  final int? id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final  int? seasonNumber;

  Seasons(
      {this.airDate,
        this.episodeCount,
        this.id,
        this.name,
        this.overview,
        this.posterPath,
        this.seasonNumber});

  factory Seasons.fromJson(Map<String, dynamic> json) =>
      _$SeasonsFromJson(json);

  Map<String, dynamic> toJson() => _$SeasonsToJson(this);

}

@JsonSerializable(fieldRename: FieldRename.snake)
class SpokenLanguages {
  final  String? englishName;
  @JsonKey(name: 'iso_639_1')
  final String? iso6391;
  final String? name;

  SpokenLanguages({this.englishName, this.iso6391, this.name});

  factory SpokenLanguages.fromJson(Map<String, dynamic> json) =>
      _$SpokenLanguagesFromJson(json);

  Map<String, dynamic> toJson() => _$SpokenLanguagesToJson(this);

}