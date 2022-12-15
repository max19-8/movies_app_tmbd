import 'package:movies_app_tmbd/data/entity/detail_tv_show_entity/tv_show_detail.dart';
import 'package:movies_app_tmbd/data/entity/movie_list/movies_response.dart';
import 'package:movies_app_tmbd/data/entity/tv_show_list/tv_show_response.dart';
import 'package:movies_app_tmbd/library/config/configuration.dart';
import 'media_type.dart';
import 'network_client.dart';
import 'time_window.dart';

abstract class NewsApiClient {
  Future<MovieResponse> getUpcomingMovies(
      int page, String locale, String apiKey);

  Future<MovieResponse> getTrendingMovies(
      ApiClientMediaType mediaType, TimeWindow timeWindow, String apiKey);
  Future<TvShowResponse> getTrendingTvShows(
      ApiClientMediaType mediaType, TimeWindow timeWindow, String apiKey);
  Future<DetailTvShow> tvShowDetails(int tvId, String locale);

  Future<bool> isFavorite(int tvShowId, String sessionID);
}

class NewsApiClientDefault implements NewsApiClient {
  final NetworkClient networkClient;

  const NewsApiClientDefault(this.networkClient);

  @override
  Future<MovieResponse> getUpcomingMovies(
      int page, String locale, String apiKey) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = networkClient.get(
        '/movie/upcoming', parser, <String, dynamic>{
      'api_key': apiKey,
      'page': page.toString(),
      'language': locale
    });
    return result;
  }

  @override
  Future<MovieResponse> getTrendingMovies(ApiClientMediaType mediaType,
      TimeWindow timeWindow, String apiKey) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieResponse.fromJson(jsonMap);
      return response;
    }

    final media = mediaType.asString();
    final time = timeWindow.asString();

    final result =
        networkClient.get('/trending/$media/$time', parser, <String, dynamic>{
      'api_key': apiKey,
    });
    return result;
  }

  @override
  Future<TvShowResponse> getTrendingTvShows(ApiClientMediaType mediaType, TimeWindow timeWindow, String apiKey) {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = TvShowResponse.fromJson(jsonMap);
      return response;
    }
    final media = mediaType.asString();
    final time = timeWindow.asString();

    final result =
    networkClient.get('/trending/$media/$time', parser, <String, dynamic>{
      'api_key': apiKey,
    });
    return result;
  }
  @override
  Future<DetailTvShow> tvShowDetails(int tvId, String locale) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = DetailTvShow.fromJson(jsonMap);
      return response;
    }
    final result =
    networkClient.get('/tv/$tvId', parser, <String, dynamic>{
      'append_to_response': 'credits,videos',
      'api_key': Configuration.apiKey,
      'language': locale,
    });
    return result;
  }
  @override
  Future<bool> isFavorite(int tvShowId, String sessionID) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final isFavorite = jsonMap['favorite'] as bool;
      return isFavorite;
    }
    final result = networkClient
        .get('/tv/$tvShowId/account_states', parser, <String, dynamic>{
      'api_key': Configuration.apiKey,
      'session_id': sessionID,
    });
    return result;
  }

}
