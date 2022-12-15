import 'package:json_annotation/json_annotation.dart';

import 'movie.dart';

part 'movies_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake,explicitToJson: true)
class MovieResponse{
  final int page;
  @JsonKey(name: 'results')
  final List<Movie> movies;
  final int totalResults;
  final int totalPages;

  MovieResponse(this.page, this.movies, this.totalResults, this.totalPages);

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}