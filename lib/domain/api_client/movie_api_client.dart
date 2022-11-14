import 'package:movies_app_tmbd/config/configuration.dart';
import 'package:movies_app_tmbd/domain/entity/movie_details.dart';
import 'package:movies_app_tmbd/domain/entity/popular_movie_response.dart';
import 'network_client.dart';

class MovieApiClient {
  final _networkClient = NetworkClient();

  Future<PopularMovieResponse> searchMovie(
      int page, String locale, String query,String apiKey) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result =
        _networkClient.get('/search/movie/', parser, <String, dynamic>{
      'api_key': apiKey,
      'page': page.toString(),
      'language': locale,
      'query': query,
      'include_adult': true.toString(),
    });
    return result;
  }

  Future<MovieDetails> movieDetails(int movieId, String locale) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    }

    final result =
        _networkClient.get('/movie/$movieId', parser, <String, dynamic>{
      'append_to_response': 'credits,videos',
      'api_key': Configuration.apiKey,
      'language': locale,
    });
    return result;
  }

  Future<bool> isFavorite(int movieId, String sessionID) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final isFavorite = jsonMap['favorite'] as bool;
      return isFavorite;
    }

    final result = _networkClient
        .get('/movie/$movieId/account_states', parser, <String, dynamic>{
      'api_key': Configuration.apiKey,
      'session_id': sessionID,
    });
    var res = await result;
    print('isFavorite $res');
    return result;
  }

  Future<PopularMovieResponse> popularMovie(int page, String locale,String apiKey) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
        '/movie/popular', parser, <String, dynamic>{
      'api_key': apiKey,
      'page': page.toString(),
      'language': locale
    });

    return result;
  }



}