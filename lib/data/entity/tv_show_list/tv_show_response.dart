import 'package:json_annotation/json_annotation.dart';
import 'package:movies_app_tmbd/data/entity/tv_show_list/tv_show.dart';

part 'tv_show_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake,explicitToJson: true)
class TvShowResponse{
  final int page;
  @JsonKey(name: 'results')
  final List<TvShow> tvShows;
  final int totalResults;
  final int totalPages;

  TvShowResponse(this.page, this.tvShows, this.totalResults, this.totalPages);

  factory TvShowResponse.fromJson(Map<String, dynamic> json) =>
      _$TvShowResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TvShowResponseToJson(this);
}