// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TvShowResponse _$TvShowResponseFromJson(Map<String, dynamic> json) =>
    TvShowResponse(
      json['page'] as int,
      (json['results'] as List<dynamic>)
          .map((e) => TvShow.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['total_results'] as int,
      json['total_pages'] as int,
    );

Map<String, dynamic> _$TvShowResponseToJson(TvShowResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.tvShows.map((e) => e.toJson()).toList(),
      'total_results': instance.totalResults,
      'total_pages': instance.totalPages,
    };
