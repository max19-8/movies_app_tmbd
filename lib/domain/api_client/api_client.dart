import 'dart:convert';
import 'dart:io';

import 'package:movies_app_tmbd/domain/entity/movie_details.dart';
import 'package:movies_app_tmbd/domain/entity/popular_movie_response.dart';

enum ApiClientExceptionType { network, auth, other,sessionExpired }

enum ApiClientMediaType { movie,tv }

extension MediaTypeAsString on ApiClientMediaType {
  String asString() {
    switch(this){
      case ApiClientMediaType.movie: return 'movie';
      case ApiClientMediaType.tv: return 'tv';
  }
}

}
class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}

class ApiClient {
  final _client = HttpClient();
  static const _host = 'https://api.themoviedb.org/3';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
  static const _apiKey = '3cfd9e9aade3b868966f742eea2665c5';



  Future<PopularMovieResponse> searchMovie(int page, String locale,String query) async {
    parser(dynamic json) {
      final jsonMap = json  as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = _get('/search/movie/', parser,
        <String, dynamic>
        {'api_key': _apiKey,
          'page': page.toString(),
          'language': locale,
          'query':query,
          'include_adult':true.toString(),
        }
    );
    return result;
  }

  Future<MovieDetails> movieDetails(int movieId, String locale) async {
    parser(dynamic json) {
      final jsonMap = json  as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    }

    final result = _get('/movie/$movieId', parser,
        <String, dynamic>{
          'append_to_response': 'credits,videos',
          'api_key': _apiKey,
          'language': locale,
        }
    );
    return result;
  }

  Future<bool> isFavorite(int movieId,String sessionID) async {
    parser(dynamic json) {
      final jsonMap = json  as Map<String, dynamic>;
      final isFavorite = jsonMap['favorite'] as bool;
      return isFavorite;
    }

    final result = _get('/movie/$movieId/account_states', parser,
        <String, dynamic>{
          'api_key': _apiKey,
          'session_id':sessionID,
        }
    );
    var res = await result;
    print( 'isFavorite $res');
    return result;
  }


  Future<PopularMovieResponse> popularMovie(int page, String locale) async {
    parser(dynamic json) {
      final jsonMap = json  as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = _get('/movie/popular', parser,
        <String, dynamic>
        {'api_key': _apiKey,
          'page': page.toString(),
          'language': locale
        }
        );

    return result;
  }

  static String imageUrl(String path) => _imageUrl + path;

  Future<String> auth(
      {required String userName, required String password}) async {
    final token = await _makeToken();
    final validToken = await _validateUser(
        userName: userName, password: password, requestToken: token);

    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  Uri _makeUri(String path, Map<String, dynamic>? parameters) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Future<int> markAsFavorite(
      {required int accountId,
        required String sessionId,
        required ApiClientMediaType mediaType,
        required int mediaId,
        required bool isFavorite,
      }) async {

   parser(dynamic json){ return 1;}

    final bodyParameters = <String, dynamic>{
      'media_type': mediaType.asString(),
      'media_id': mediaId,
      'favorite': isFavorite,
    };
   print('bodyParameters $bodyParameters');

    final result = _post('/account/$accountId/favorite',
        bodyParameters, parser,
        <String, dynamic>{
          'api_key': _apiKey,
          'session_id':sessionId,
        });

    print('markAsFavorite $isFavorite');
    return result;
  }



  Future<int> getAccountInfo(String sessionID) async {
    parser(dynamic json) {
      final jsonMap = json  as Map<String, dynamic>;
      final result =jsonMap['id'] as int;
      return result;
    }

    final result = _get('/account', parser,
        <String, dynamic>{
          'api_key': _apiKey,
          'session_id':sessionID,
        }
    );
    return result;
  }

  Future<String> _makeToken() async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result = _get('/authentication/token/new', parser,
        <String, dynamic>{'api_key': _apiKey});

    return result;
  }

  Future<String> _validateUser(
      {required String userName,
      required String password,
      required String requestToken}) async {
    final bodyParameters = <String, dynamic>{
      'username': userName,
      'password': password,
      'request_token': requestToken,
    };
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result = _post('/authentication/token/validate_with_login',
        bodyParameters, parser, <String, dynamic>{'api_key': _apiKey});
    return result;
  }

  Future<String> _makeSession({required String requestToken}) async {
    final bodyParameters = <String, dynamic>{
      'request_token': requestToken,
    };
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final sessionID = jsonMap['session_id'] as String;
      return sessionID;
    }

    final result = _post('/authentication/session/new', bodyParameters, parser,
        <String, dynamic>{'api_key': _apiKey});
    return result;
  }

  Future<T> _post<T>(String path, Map<String, dynamic>? bodyParameters,
      T Function(dynamic json) parser,
      [Map<String, dynamic>? urlParameters]) async {
    try {
      final url = _makeUri(path, urlParameters);

      final request = await _client.postUrl(url);

      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParameters));

      final response = await request.close();

      final dynamic json = (await response.jsonDecode());
      _validateResponse(response, json);

      final result = parser(json);

      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      print( 'exception ' + e.toString());
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<T> _get<T>(String path, T Function(dynamic json) parser,
      [Map<String, dynamic>? parameters]) async {
    final url = _makeUri(path, parameters);
    try {
      final request = await _client.getUrl(url);
      final response = await request.close();
      final dynamic json = (await response.jsonDecode());

      _validateResponse(response, json);

      final result = parser(json);

      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      print( 'exception ' + e.toString());
       throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  void _validateResponse(HttpClientResponse response, dynamic json) {
    if (response.statusCode == 401) {
      final dynamic status = json['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiClientException(ApiClientExceptionType.auth);
      } else if(code == 3){
        throw ApiClientException(ApiClientExceptionType.sessionExpired);
      }else {
        throw ApiClientException(ApiClientExceptionType.other);
      }
    }
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((v) => json.decode(v));
  }
}
