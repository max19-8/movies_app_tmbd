import 'package:movies_app_tmbd/data/entity/details_movie_entity/details_result.dart';
import 'package:movies_app_tmbd/data/entity/movie_list/movies_response.dart';
import 'package:movies_app_tmbd/library/config/configuration.dart';
import 'network_client.dart';

abstract class MovieApiClient {
  Future<MovieResponse> searchMovie(
      int page, String locale, String query,String apiKey);

  Future<MovieDetailsResult> movieDetails(int movieId, String locale);

  Future<bool> isFavorite(int movieId, String sessionID);

  Future<MovieResponse> popularMovie(int page, String locale,String apiKey);

  Future<MovieResponse> topRatedMovies(
      int page, String locale, String apiKey);
}

class MovieApiClientDefault implements MovieApiClient {
  final NetworkClient networkClient;

 const MovieApiClientDefault(this.networkClient);

  @override
  Future<MovieResponse> topRatedMovies(
      int page, String locale, String apiKey) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = networkClient.get('/movie/top_rated', parser, <String, dynamic>{
      'api_key': apiKey,
      'page': page.toString(),
      'language': locale
    });

    return result;
  }

  @override
  Future<MovieResponse> searchMovie(
      int page, String locale, String query,String apiKey) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieResponse.fromJson(jsonMap);
      return response;
    }

    final result =
    networkClient.get('/search/movie/', parser, <String, dynamic>{
      'api_key': apiKey,
      'page': page.toString(),
      'language': locale,
      'query': query,
      'include_adult': true.toString(),
    });
    return result;
  }
  @override
  Future<MovieDetailsResult> movieDetails(int movieId, String locale) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetailsResult.fromJson(jsonMap);
      return response;
    }

    final result =
    networkClient.get('/movie/$movieId', parser, <String, dynamic>{
      'append_to_response': 'credits,videos',
      'api_key': Configuration.apiKey,
      'language': locale,
    });
    return result;
  }

  @override
  Future<bool> isFavorite(int movieId, String sessionID) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final isFavorite = jsonMap['favorite'] as bool;
      return isFavorite;
    }
    final result = networkClient
        .get('/movie/$movieId/account_states', parser, <String, dynamic>{
      'api_key': Configuration.apiKey,
      'session_id': sessionID,
    });
    return result;
  }

  @override
  Future<MovieResponse> popularMovie(int page, String locale,String apiKey) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = networkClient.get(
        '/movie/popular', parser, <String, dynamic>{
      'api_key': apiKey,
      'page': page.toString(),
      'language': locale
    });

    return result;
  }



}