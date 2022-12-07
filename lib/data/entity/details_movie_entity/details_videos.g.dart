// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details_videos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailsVideos _$DetailsVideosFromJson(Map<String, dynamic> json) =>
    DetailsVideos(
      results: (json['results'] as List<dynamic>)
          .map((e) => DetailsVideosResults.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DetailsVideosToJson(DetailsVideos instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

DetailsVideosResults _$DetailsVideosResultsFromJson(
        Map<String, dynamic> json) =>
    DetailsVideosResults(
      iso6391: json['iso_639_1'] as String,
      iso31661: json['iso_3166_1'] as String,
      name: json['name'] as String,
      key: json['key'] as String,
      site: json['site'] as String,
      size: json['size'] as int,
      type: json['type'] as String,
      official: json['official'] as bool,
      publishedAt: json['published_at'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$DetailsVideosResultsToJson(
        DetailsVideosResults instance) =>
    <String, dynamic>{
      'iso_639_1': instance.iso6391,
      'iso_3166_1': instance.iso31661,
      'name': instance.name,
      'key': instance.key,
      'site': instance.site,
      'size': instance.size,
      'type': instance.type,
      'official': instance.official,
      'published_at': instance.publishedAt,
      'id': instance.id,
    };
