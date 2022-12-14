import 'dart:convert';
import 'dart:io';
import 'package:movies_app_tmbd/library/HttpClient/app_http_client.dart';
import 'package:movies_app_tmbd/library/config/configuration.dart';
import 'api_client_exception.dart';

abstract class NetworkClient{

  Future<T> get<T>(String path, T Function(dynamic json) parser,
      [Map<String, dynamic>? parameters]);

  Future<T> post<T>(String path, Map<String, dynamic>? bodyParameters,
      T Function(dynamic json) parser,
      [Map<String, dynamic>? urlParameters]);

}


class NetworkClientDefault  implements NetworkClient{

  final AppHttpClient appHttpClient;

   const NetworkClientDefault(this.appHttpClient);

  Uri _makeUri(String path, Map<String, dynamic>? parameters) {
    final uri = Uri.parse('${Configuration.host}$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  @override
  Future<T> get<T>(String path, T Function(dynamic json) parser,
      [Map<String, dynamic>? parameters]) async {
    final url = _makeUri(path, parameters);
    try {
      final request = await appHttpClient.getUrl(url);
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
      print(e.toString());
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  @override
  Future<T> post<T>(String path, Map<String, dynamic>? bodyParameters,
      T Function(dynamic json) parser,
      [Map<String, dynamic>? urlParameters]) async {
    try {
      final url = _makeUri(path, urlParameters);

      final request = await appHttpClient.postUrl(url);

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
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  void _validateResponse(HttpClientResponse response, dynamic json) {
    if (response.statusCode == 401) {
      final dynamic status = json['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiClientException(ApiClientExceptionType.auth);
      } else if (code == 3) {
        throw ApiClientException(ApiClientExceptionType.sessionExpired);
      } else {
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
